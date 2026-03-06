from pydantic import BaseModel
from typing import Optional

class UserBase(BaseModel):
    username: str
    phone: str
    password: str

class UserCreate(UserBase):
    pass

class UserUpdate(BaseModel):
    username: Optional[str] = None
    phone: Optional[str] = None
    password: Optional[str] = None
class UserResponse(UserBase):
    id: int

    class Config:
        orm_mode = True