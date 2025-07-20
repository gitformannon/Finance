import uuid
from datetime import datetime
from pydantic import BaseModel, EmailStr
from models.users import Status

class UserBase(BaseModel):
    username: str
    first_name: str = "User"
    last_name: str | None = None

class UserCreate(UserBase):
    password: str
    email: EmailStr

class UserRead(UserBase):
    id: uuid.UUID
    email: EmailStr
    profile_image: str | None = None
    status: Status
    created_at: datetime
    updated_at: datetime

    model_config = {
        "from_attributes": True
    }


class UserUpdate(BaseModel):
    first_name: str | None = None
    last_name: str | None = None
