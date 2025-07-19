from database import Base
from sqlalchemy import Column, String, Enum as SQLEnum, ForeignKey, DateTime, func
from sqlalchemy.dialects.postgresql import UUID
from uuid import uuid4
from enum import Enum

class CategoryType(Enum):
    INCOME = "income"
    PURCHASE = "purchase"

class Category(Base):
    __tablename__ = "categories"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    name = Column(String(50), nullable=False)
    type = Column(SQLEnum(CategoryType), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

