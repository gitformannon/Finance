import uuid
from datetime import datetime, date
from pydantic import BaseModel


class TransactionCreate(BaseModel):
    type: str
    account_id: uuid.UUID
    to_account_id: uuid.UUID | None = None
    category_id: uuid.UUID | None = None
    amount: float
    note: str | None = None
    date: date


class TransactionRead(BaseModel):
    id: uuid.UUID
    account_id: uuid.UUID
    category_id: uuid.UUID | None = None
    amount: int
    description: str | None = None
    created_at: datetime

    model_config = {"from_attributes": True}
