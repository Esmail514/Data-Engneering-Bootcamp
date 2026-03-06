from fastapi import FastAPI
from routes import user, project, task
from database import base, engine

import models.user, models.project, models.task

base.metadata.create_all(bind=engine)

app = FastAPI(title="Esmail API")

origins = [
    "http://127.0.0.1:5000",
    "http://localhost:5000",
]

app.include_router(user.router)
app.include_router(project.router)
app.include_router(task.router)
