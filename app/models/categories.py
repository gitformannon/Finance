from database import Base
from sqlalchemy import Column, String, ForeignKey, DateTime, func, BigInteger
from sqlalchemy.dialects.postgresql import UUID
from uuid import uuid4
from enum import IntEnum
from .types import IntEnumType

class CategoryType(IntEnum):
    INCOME = 1
    PURCHASE = -1

    @classmethod
    def _missing_(cls, value):
        """Support case-insensitive conversion from strings or numeric values."""
        if isinstance(value, str):
            # try to parse numeric value first
            try:
                value_int = int(value)
                for member in cls:
                    if member.value == value_int:
                        return member
            except ValueError:
                pass

            value_lower = value.lower()
            for member in cls:
                if member.name.lower() == value_lower:
                    return member
        elif isinstance(value, int):
            for member in cls:
                if member.value == value:
                    return member
        return None

class Category(Base):
    __tablename__ = "categories"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    name = Column(String(50), nullable=False)
    type = Column(IntEnumType(CategoryType), nullable=False)
    budget = Column(BigInteger, nullable=True)
    emoji_path = Column(String(255), nullable=True)  # Path to emoji SVG file in assets
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)
