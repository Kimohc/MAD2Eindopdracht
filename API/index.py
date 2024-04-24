import models
from database import engine, SessionLocal
from sqlalchemy.orm import Session
from starlette.middleware.cors import CORSMiddleware
from datetime import datetime, timedelta, timezone
from typing import Annotated, Union
from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt
from passlib.context import CryptContext
from pydantic import BaseModel


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins="*",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
models.Base.metadata.create_all(bind=engine)
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 0.5

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


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


class UserInDB(UserBase):
    user_id: int


def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)


def get_user_by_username(db: Session, username: str):
    return db.query(models.users).filter(models.users.username == username).first()


def authenticate_user(db: Session, username: str, password: str):
    user = get_user_by_username(db, username)
    if not user:
        return False
    if not verify_password(password, user.password):
        return False
    return user


def create_access_token(data: dict, expires_delta: timedelta):
    to_encode = data.copy()
    expire = datetime.utcnow() + expires_delta
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    db = SessionLocal()
    user = get_user_by_username(db, username)
    db.close()
    if user is None:
        raise credentials_exception
    return user


@app.post("/users/login")
async def login(user: UserBase):
    db = SessionLocal()
    user = authenticate_user(db, user.username, user.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer", "user_id": user.user_id, "username": user.username,
            "password": user.password}


@app.get("/users/me")
async def read_users_me(current_user: UserInDB = Depends(get_current_user)):
    return current_user


@app.get('/refresh')
async def get_new_acces_token(username: str):
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    acces_token = create_access_token(data={"sub": username}, expires_delta=access_token_expires)
    return {"acces_token": acces_token}


@app.post('/users/', status_code=status.HTTP_201_CREATED)
async def create_user(user: UserBase, db: db_dependency):
    db_user = models.users(**user.dict())
    db_user.password = pwd_context.hash(db_user.password)
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


@app.post('/users/getid', status_code=status.HTTP_200_OK)
async def get_user_by_username_password(user: UserBase, db: db_dependency):
    db_user = models.users(**user.dict())
    user = db.query(models.users).filter(models.users.username == db_user.username).filter(
        models.users.password == db_user.password).first()
    return user.user_id


@app.post('/tasks/', status_code=status.HTTP_201_CREATED)
async def create_task(task: TaskBase, db: db_dependency, current_user: UserInDB = Depends(get_current_user)):
    db_task = models.tasks(**task.dict())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task


@app.get("/tasks", status_code=status.HTTP_200_OK)
async def get_tasks(db: db_dependency, current_user: UserInDB = Depends(get_current_user)):
    return db.query(models.tasks).all()


@app.get("/tasks/{task_id}", status_code=status.HTTP_200_OK)
async def get_task(task_id: int, db: db_dependency):
    return db.query(models.tasks).filter(models.tasks.task_id == task_id).first()


@app.get("/tasks/users/{user_id}", status_code=status.HTTP_200_OK)
async def get_tasks_user(user_id: int, db: db_dependency):
    return db.query(models.tasks).filter(models.tasks.user_id == user_id).all()


@app.delete("/tasks/{task_id}", status_code=status.HTTP_200_OK)
async def delete_task(task_id: int, db: db_dependency, current_user: UserInDB = Depends(get_current_user)):
    db.query(models.tasks).filter(models.tasks.task_id == task_id).delete()
    db.commit()
    return {"message": "Task deleted"}


@app.patch("/tasks/{task_id}", status_code=status.HTTP_200_OK)
async def update_task(task_id: int, task: TaskBase, db: db_dependency, current_user: UserInDB = Depends(get_current_user)):
    db.query(models.tasks).filter(models.tasks.task_id == task_id).update(task.dict())
    db.commit()
    return {"message": "Task updated"}
