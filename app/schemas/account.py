import uuid
from datetime import datetime
from pydantic import BaseModel

class AccountCreate(BaseModel):
    account_name: str | None = None
    account_number: str | None = None
    account_type: int | None = None
    initial_balance: int = 0

class AccountRead(BaseModel):
    id: uuid.UUID
    account_name: str | None = None
    account_number: str | None = None
    account_type: int | None = None
    balance: int
    created_at: datetime

    model_config = {"from_attributes": True}
