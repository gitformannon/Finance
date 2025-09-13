import uuid
from datetime import datetime, date
from pydantic import BaseModel


class TransactionCreate(BaseModel):
    type: str
    account_id: uuid.UUID
    to_account_id: uuid.UUID | None = None
    to_account: str | None = None
    category_id: uuid.UUID | None = None
    amount: float
    note: str | None = None
    date: date


class TransactionRead(BaseModel):
    id: uuid.UUID
    account_id: uuid.UUID
    to_account: str | None = None
    category_id: uuid.UUID | None = None
    amount: int
    description: str | None = None
    created_at: datetime
    account_name: str | None = None
    category_name: str | None = None

    model_config = {"from_attributes": True}


class TransactionUpdate(BaseModel):
    # Restrict update to safer fields; amount/account changes require balance logic
    category_id: uuid.UUID | None = None
    note: str | None = None
