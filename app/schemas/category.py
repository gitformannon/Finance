import uuid
from datetime import datetime
from pydantic import BaseModel
from models.categories import CategoryType

class CategoryCreate(BaseModel):
    name: str
    type: CategoryType

class CategoryRead(BaseModel):
    id: uuid.UUID
    name: str
    type: CategoryType
    created_at: datetime

    model_config = {"from_attributes": True}
