from fastapi import FastAPI, HTTPException, Depends, status
from pydantic import BaseModel
from typing import Annotated
import models
from database import engine, SessionLocal
from sqlalchemy.orm import Session
from starlette.middleware.cors import CORSMiddleware

password_length_total = 0
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins="*",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
models.Base.metadata.create_all(bind=engine)


class TaskBase(BaseModel):
    naam: str
    beschrijving: str
    user_id: int


class UserBase(BaseModel):
    username: str
    password: str


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


db_dependency = Annotated[Session, Depends(get_db)]


@app.post('/users/', status_code=status.HTTP_201_CREATED)
async def create_user(user: UserBase, db: db_dependency):
    db_user = models.users(**user.dict())
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


@app.get("/users", status_code=status.HTTP_200_OK)
async def get_users(db: db_dependency):
    return db.query(models.users).all()


@app.delete("/users/{user_id}", status_code=status.HTTP_200_OK)
async def delete_user(user_id: int, db: db_dependency):
    db.query(models.users).filter(models.users.user_id == user_id).delete()
    db.commit()
    return {"message": "User deleted"}


@app.post('/tasks/', status_code=status.HTTP_201_CREATED)
async def create_task(task: TaskBase, db: db_dependency):
    db_task = models.tasks(**task.dict())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task


@app.get("/tasks", status_code=status.HTTP_200_OK)
async def get_tasks(db: db_dependency):
    return db.query(models.tasks).all()


@app.get("/tasks/{task_id}", status_code=status.HTTP_200_OK)
async def get_task(task_id: int, db: db_dependency):
    return db.query(models.tasks).filter(models.tasks.task_id == task_id).first()


@app.get("/tasks/users/{user_id}", status_code=status.HTTP_200_OK)
async def get_tasks_user(user_id: int, db: db_dependency):
    return db.query(models.tasks).filter(models.tasks.user_id == user_id).all()


@app.delete("/tasks/{task_id}", status_code=status.HTTP_200_OK)
async def delete_task(task_id: int, db: db_dependency):
    db.query(models.tasks).filter(models.tasks.task_id == task_id).delete()
    db.commit()
    return {"message": "Task deleted"}


@app.patch("/tasks/{task_id}", status_code=status.HTTP_200_OK)
async def update_task(task_id: int, task: TaskBase, db: db_dependency):
    db.query(models.tasks).filter(models.tasks.task_id == task_id).update(task.dict())
    db.commit()
    return {"message": "Task updated"}


@app.post("/users/login", status_code=status.HTTP_200_OK)
async def check_if_user_exists(user: UserBase, db: db_dependency):
    db_user = models.users(**user.dict())
    can_login = False
    user = db.query(models.users).filter(models.users.username == db_user.username).filter(
        models.users.password == db_user.password).first()
    if user is None:
        can_login = False
        return can_login
    can_login = True
    return can_login


@app.post('/users/getid', status_code=status.HTTP_200_OK)
async def get_user_by_username_password(user: UserBase, db: db_dependency):
    db_user = models.users(**user.dict())
    user = db.query(models.users).filter(models.users.username == db_user.username).filter(
        models.users.password == db_user.password).first()
    return user.user_id
