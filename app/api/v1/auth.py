from __future__ import annotations

from fastapi import (
    APIRouter, Depends, HTTPException, status, Body, Response
)
from fastapi.security import OAuth2PasswordRequestForm

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from database import get_session
from models.users import User
import services.auth_service as auth_service
from schemas.user import UserCreate, UserRead
from schemas.auth import (
    TokenBase,
    NewRefreshRequest,
    PasswordResetTOTP,
    TOTPSetupOut,
    TOTPCodeIn,
    TOTPStatusOut,
)
import services.mfa_service as mfa_service

# ─────────── Router setup ───────────
router = APIRouter(prefix="/auth", tags=["Auth"])
# ─────────────────────────────────────


# ─────────── Endpoints ───────────
@router.post("/register", response_model=UserRead, status_code=status.HTTP_201_CREATED)
async def register(data: UserCreate, session: AsyncSession = Depends(get_session)):
    # uniqueness checks
    if await session.scalar(select(User).where(User.username == data.username)):
        raise HTTPException(400, "Username already in use")
    if await session.scalar(select(User).where(User.email == data.email)):
        raise HTTPException(400, "E‑mail already registered")

    user = User(
        username=data.username,
        email=data.email,
        hashed_password=auth_service.hash_password(data.password)
    )
    session.add(user)
    await session.commit()
    await session.refresh(user)
    return user


@router.post("/login", response_model=TokenBase)
async def login(
    form: OAuth2PasswordRequestForm = Depends(),
    session: AsyncSession = Depends(get_session)
):
    user = await auth_service.authenticate(session, form.username, form.password)
    if not user:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Invalid credentials")
    return TokenBase(
        access_token=auth_service.create_access_token(str(user.id), scope="setup_2fa"),
        refresh_token=auth_service.create_refresh_token(str(user.id)),
        user_id=user.id
    )


@router.post("/enable-totp", response_model=TOTPSetupOut)
async def enable_totp(
    user: User = Depends(auth_service.get_current_user),
    token: str = Depends(auth_service.oauth_scheme),
    session: AsyncSession = Depends(get_session),
):
    auth_service.decode_token(token, required_scope="setup_2fa")
    if user.is_totp_enabled:
        raise HTTPException(400, "Already enabled")
    secret = mfa_service.gen_secret()
    user.totp_secret = mfa_service.encrypt(secret)
    user.is_totp_enabled = False
    session.add(user)
    await session.commit()
    uri = mfa_service.provisioning_uri(user.username, secret)
    qr_b64 = mfa_service.qr_png_base64(uri)
    return TOTPSetupOut(otpauth_uri=uri, qr_png_base64=qr_b64)


@router.post("/confirm-totp", status_code=204)
async def confirm_totp(
    data: TOTPCodeIn,
    user: User = Depends(auth_service.get_current_user),
    token: str = Depends(auth_service.oauth_scheme),
    session: AsyncSession = Depends(get_session),
):
    auth_service.decode_token(token, required_scope="setup_2fa")
    if not user.totp_secret:
        raise HTTPException(400, "TOTP not initiated")
    secret = mfa_service.decrypt(user.totp_secret)
    if not mfa_service.verify(data.code, secret):
        raise HTTPException(400, "Invalid code")
    user.is_totp_enabled = True
    session.add(user)
    await session.commit()
    return Response(status_code=204)


@router.post("/disable-totp", status_code=204)
async def disable_totp(
    data: TOTPCodeIn,
    user: User = Depends(auth_service.get_current_user),
    session: AsyncSession = Depends(get_session),
):
    """Disable TOTP for the current user after verifying the provided code."""
    if not user.totp_secret or not user.is_totp_enabled:
        raise HTTPException(400, "TOTP not enabled")

    secret = mfa_service.decrypt(user.totp_secret)
    if not mfa_service.verify(data.code, secret):
        raise HTTPException(400, "Invalid code")

    user.totp_secret = None
    user.is_totp_enabled = False
    session.add(user)
    await session.commit()
    return Response(status_code=204)


@router.get("/totp-status", response_model=TOTPStatusOut)
async def totp_status(
    user: User = Depends(auth_service.get_current_user)
):
    """Return whether TOTP is enabled for current user."""
    return TOTPStatusOut(is_enabled=user.is_totp_enabled)


@router.get("/me", response_model=UserRead)
async def read_current_user(
    user: User = Depends(auth_service.get_current_user)
):
    """Return information about the currently authenticated user."""
    return user




@router.post("/refresh", response_model=TokenBase)
async def refresh(data: NewRefreshRequest, session: AsyncSession = Depends(get_session)):
    try:
        payload = auth_service.decode_token(data.refresh_token)
    except HTTPException:
        raise
    except Exception:
        raise HTTPException(401, "Invalid refresh token")

    if payload.get("type") != "refresh":
        raise HTTPException(401, "Wrong token type")

    jti = payload.get("jti")
    if not jti or await auth_service.is_blacklisted(jti):
        raise HTTPException(401, "Token is revoked")

    # Verify user exists
    user = await session.get(User, payload["sub"])
    if not user:
        raise HTTPException(404, "User not found")

    # blacklist old refresh
    await auth_service.blacklist_refresh(jti, payload["exp"])

    return TokenBase(
        access_token=auth_service.create_access_token(str(user.id)),
        refresh_token=auth_service.create_refresh_token(str(user.id)),
        user_id=user.id
    )


@router.post("/logout", status_code=204)
async def logout(refresh: str = Body(..., embed=True)):
    """
    Клиент присылает текущий refresh‑token, мы кладём его jti в blacklist.
    """
    try:
        payload = auth_service.decode_token(refresh)
        if payload.get("type") != "refresh":
            raise ValueError
    except Exception:
        raise HTTPException(401, "Invalid token")

    await auth_service.blacklist_refresh(payload["jti"], payload["exp"])
    return Response(status_code=204)


@router.post("/password-reset", status_code=204)
async def password_reset(data: PasswordResetTOTP, session: AsyncSession = Depends(get_session)):
    """Reset password using TOTP verification."""
    user = await session.scalar(select(User).where(User.email == data.email))
    if not user:
        raise HTTPException(404, "User not found")

    if not user.totp_secret:
        raise HTTPException(400, "TOTP not enabled")

    secret = mfa_service.decrypt(user.totp_secret)
    if not mfa_service.verify(data.code, secret):
        raise HTTPException(400, "Invalid code")

    await auth_service.update_password(session, user, data.new_password)
    return Response(status_code=204)
