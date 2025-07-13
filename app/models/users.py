from database import Base
from sqlalchemy import Column, Integer, String, DateTime, func, Boolean, LargeBinary
from sqlalchemy.orm import relationship
from uuid import uuid4
from sqlalchemy.dialects.postgresql import UUID
from enum import Enum

class Status(Enum):
    ACTIVE = 1
    INACTIVE = 0
    SUSPENDED = -1

class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid4)
    username = Column(String(50), unique=True, nullable=False)
    hashed_password = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    first_name = Column(String(50), nullable=False, server_default="User")
    last_name = Column(String(50), nullable=True)
    profile_image = Column(String(255), nullable=True)
    totp_secret = Column(LargeBinary, nullable=True)
    is_totp_enabled = Column(Boolean, default=False, nullable=False)
    status = Column(Integer, default=1, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Отношения
    transactions = relationship("Transaction", back_populates="user", cascade="all, delete-orphan")
    accounts = relationship("Account", back_populates="user", cascade="all, delete-orphan")

