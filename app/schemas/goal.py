import uuid
from datetime import date, datetime
from pydantic import BaseModel, Field


class GoalCreate(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    target_amount: int
    target_date: date | None = None
    initial_amount: int = 0
    emoji_path: str | None = None


class GoalRead(BaseModel):
    id: uuid.UUID
    name: str
    target_amount: int
    current_amount: int
    target_date: date | None = None
    emoji_path: str | None = None
    created_at: datetime

    model_config = {"from_attributes": True}


class GoalContribute(BaseModel):
    amount: int

class GoalUpdate(BaseModel):
    name: str | None = None
    target_amount: int | None = None
    target_date: date | None = None
    emoji_path: str | None = None
