from database import Base
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, func, Enum as SQLEnum
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import UUID
from uuid import uuid4
from enum import Enum

class AccountType(Enum):
    DEBIT_CARD = 1
    CREDIT_CARD = 2
    SAVINGS = 3
    INVESTMENT = 4
    CASH = 5
    OTHER = 6

class AccountStatus(Enum):
    ACTIVE = 1
    INACTIVE = 0
    SUSPENDED = -1

class Account(Base):
    __tablename__ = "accounts"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    account_name = Column(String(50), nullable=True)
    account_number = Column(String(20), nullable=True, unique=True)
    account_type = Column(SQLEnum(AccountType), nullable=True)
    status = Column(SQLEnum(AccountStatus), default=1, nullable=False)
    balance = Column(Integer, nullable=False, default=0)
    initial_balance = Column(Integer, nullable=False, default=0)
    limit = Column(Integer, nullable=True)  # лимит для кредитных карт
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Отношения
    user = relationship("User", back_populates="accounts")
    transactions = relationship("Transaction", back_populates="account", cascade="all, delete-orphan")