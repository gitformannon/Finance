import uuid
from datetime import datetime
from pydantic import BaseModel
from models.accounts import AccountType

class AccountCreate(BaseModel):
    account_name: str | None = None
    account_number: str | None = None
    account_type: AccountType | None = None
    initial_balance: int = 0

class AccountRead(BaseModel):
    id: uuid.UUID
    account_name: str | None = None
    account_number: str | None = None
    account_type: AccountType | None = None
    balance: int
    created_at: datetime

    model_config = {"from_attributes": True}
