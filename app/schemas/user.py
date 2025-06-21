import uuid
from datetime import datetime
from pydantic import BaseModel, EmailStr

class UserBase(BaseModel):
    username: str

class UserCreate(UserBase):
    password: str
    email: EmailStr

class UserRead(UserBase):
    id: uuid.UUID
    email: EmailStr
    status: int
    created_at: datetime
    updated_at: datetime

    model_config = {
        "from_attributes": True
    }
