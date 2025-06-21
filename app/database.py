from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy import NullPool
import config

# Базовый класс моделей (DeclarativeBase с поддержкой AsyncAttrs, если нужно)
class Base(DeclarativeBase):
    pass

# Создаем асинхронный движок SQLAlchemy (PostgreSQL + asyncpg)
engine = create_async_engine(
    config.DATABASE_URL,
    echo=config.SQLALCHEMY_ECHO,
    poolclass=NullPool   # Не сохраняем пул соединений между запросами (опционально)
)

# Фабрика сессий (не истекают объекты при коммите для удобства)
SessionMaker = async_sessionmaker(engine, expire_on_commit=False)

# Зависимость для получения сессии в маршрутах FastAPI
async def get_session() -> AsyncSession:
    async with SessionMaker() as session:
        yield session
        # Сессия автоматически закрывается по выходу