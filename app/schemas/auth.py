import uuid
from pydantic import BaseModel, EmailStr

from .user import UserBase

class TokenBase(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user_id: uuid.UUID

class LoginRequest(UserBase):
    email: EmailStr
    password: str

class LoginResponse(TokenBase):
    pass

class NewRefreshRequest(BaseModel):
    refresh_token: str

class NewRefreshResponse(TokenBase):
    pass

class PasswordResetTOTP(BaseModel):
    email: EmailStr
    code: str
    new_password: str


class TOTPSetupOut(BaseModel):
    otpauth_uri: str
    qr_png_base64: str


class TOTPCodeIn(BaseModel):
    code: str


class TOTPStatusOut(BaseModel):
    is_enabled: bool
