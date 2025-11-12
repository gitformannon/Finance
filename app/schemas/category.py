import uuid
from datetime import datetime
from pydantic import BaseModel
from models.categories import CategoryType

class CategoryCreate(BaseModel):
    name: str
    type: CategoryType
    budget: int | None = None
    emoji_path: str | None = None

class CategoryUpdate(BaseModel):
    name: str | None = None
    type: CategoryType | None = None
    budget: int | None = None
    emoji_path: str | None = None

class CategoryRead(BaseModel):
    id: uuid.UUID
    name: str
    type: CategoryType
    budget: int | None = None
    emoji_path: str | None = None
    created_at: datetime

    model_config = {"from_attributes": True}
