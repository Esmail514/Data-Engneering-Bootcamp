from pydantic import BaseModel
from typing import Optional

from schemas.project import ProjectResponse
from schemas.user import UserResponse

class TaskBase(BaseModel):
    title: str
    description: Optional[str] = None
    status: Optional[str] = "pending"
    project_id: int
    assigned_to: Optional[int] = None

class TaskCreate(TaskBase):
    pass

class TaskUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    status: Optional[str] = None
    assigned_to: Optional[int] = None

class TaskResponse(TaskBase):
    id: int
    project: Optional[ProjectResponse] = None
    assignee: Optional[UserResponse] = None

    class Config:
        orm_mode = True