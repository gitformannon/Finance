import uuid
from datetime import datetime
from pydantic import BaseModel

class CategoryCreate(BaseModel):
    name: str
    type: str

class CategoryRead(BaseModel):
    id: uuid.UUID
    name: str
    type: str
    created_at: datetime

    model_config = {"from_attributes": True}
