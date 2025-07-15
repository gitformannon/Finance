import uuid
from datetime import datetime
from pydantic import BaseModel

class TransactionRead(BaseModel):
    id: uuid.UUID
    account_id: uuid.UUID
    amount: int
    description: str | None = None
    created_at: datetime

    model_config = {"from_attributes": True}
