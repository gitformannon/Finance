from jose import jwt
import uuid, time
from datetime import datetime, timedelta, timezone
from fastapi import HTTPException, status, Depends
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from database import get_session
from passlib.context import CryptContext
import redis.asyncio as aioredis

import config

oauth_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")  # используется в get_current_user

from models.users import User
from schemas.auth import TokenBase, NewRefreshRequest

pwd_ctx = CryptContext(schemes=["bcrypt"], deprecated="auto")

redis = aioredis.from_url(config.REDIS_URL, decode_responses=True)

# simple e-mail sender
def send_email(to_email: str, subject: str, body: str):
    """Send e-mails using SMTP settings from config."""
    import smtplib
    from email.message import EmailMessage

    msg = EmailMessage()
    msg["Subject"] = subject
    msg["From"] = config.EMAIL_FROM
    msg["To"] = to_email
    msg.set_content(body)

    try:
        with smtplib.SMTP(config.SMTP_HOST, config.SMTP_PORT) as server:
            if config.SMTP_USER:
                server.starttls()
                server.login(config.SMTP_USER, config.SMTP_PASSWORD or "")
            server.send_message(msg)
    except Exception:
        # In case e-mail sending fails we just ignore it for now
        pass


# ---------- хэширование пароля ----------
def hash_password(raw: str) -> str:
    return pwd_ctx.hash(raw)

def verify_password(raw: str, hashed: str) -> bool:
    return pwd_ctx.verify(raw, hashed)


# ---------- генерация токенов ----------
def build_jwt(data: dict, expires_delta: timedelta) -> str:
    to_encode = data.copy()
    expire = datetime.now(tz=timezone.utc) + expires_delta
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, config.SECRET_KEY, algorithm=config.ALGORITHM)


def create_access_token(user_id: str, scope: str | None = None) -> str:
    """Живёт ACCESS_EXPIRE_MIN мин."""
    payload = {"sub": str(user_id), "type": "access"}
    if scope:
        payload["scope"] = scope
    return build_jwt(payload,
                     timedelta(minutes=config.ACCESS_TOKEN_EXPIRE_MINUTES))




def create_refresh_token(user_id: str) -> str:
    """
    refresh несёт:
      jti — уникальный UUID (чтобы можно было заблокировать конкретный токен)
      sub — user_id
      type — 'refresh'
    TTL задаём в payload и контролируем при decode.
    """
    jti = str(uuid.uuid4())
    token = build_jwt(
        {"sub": str(user_id), "jti": jti, "type": "refresh"},
        timedelta(days=config.REFRESH_TOKEN_EXPIRE_DAYS),
    )
    return token


# ---------- проверка токенов ----------
def decode_token(token: str, required_scope: str | None = None) -> dict:
    try:
        payload = jwt.decode(token, config.SECRET_KEY, algorithms=[config.ALGORITHM])
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                            detail="Token expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                            detail="Invalid token")
    if required_scope and payload.get("scope") != required_scope:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
                            detail="Invalid scope")
    return payload

async def get_current_user(
    token: str = Depends(oauth_scheme),
    session: AsyncSession = Depends(get_session),
    # использует зависимость для получения текущей сессии БД
    required_scope: str | None = None,
):
    payload = decode_token(token, required_scope)
    if payload.get("type") != "access":
        raise HTTPException(status_code=401, detail="Wrong token type")

    user = await session.scalar(select(User).where(User.id == payload["sub"]))
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


async def blacklist_refresh(jti: str, exp: int):
    """Сохраняем jti в redis до истечения срока токена, чтобы его нельзя было переиспользовать."""
    ttl = exp - int(time.time())
    if ttl > 0:
        await redis.setex(f"bl:{jti}", ttl, "1")


async def is_blacklisted(jti: str) -> bool:
    return await redis.exists(f"bl:{jti}") == 1




# ---------- сервис-вызовы ----------
async def issue_token_pair(user_id: str) -> TokenBase:
    """Возвращает новую пару токенов."""
    return TokenBase(
        access_token=create_access_token(user_id),
        refresh_token=create_refresh_token(user_id),
    )


async def refresh_tokens(data: NewRefreshRequest) -> TokenBase:
    payload = decode_token(data.refresh_token)

    if payload.get("type") != "refresh":
        raise HTTPException(status_code=401, detail="Wrong token type")

    jti = payload["jti"]
    if await is_blacklisted(jti):
        raise HTTPException(status_code=401, detail="Token is revoked")

    # здесь можно дополнительно проверить в БД, что user активен
    new_pair = await issue_token_pair(payload["sub"])

    # помещаем старый refresh в чёрный список
    await blacklist_refresh(jti, payload["exp"])

    return new_pair

async def authenticate(session: AsyncSession, username: str, password: str) -> User | None:
    res = await session.execute(select(User).where(User.username == username))
    user = res.scalars().first()
    if user and verify_password(password, user.hashed_password):
        return user
    return None


async def update_password(session: AsyncSession, user: User, new_password: str):
    user.hashed_password = hash_password(new_password)
    session.add(user)
    await session.commit()
