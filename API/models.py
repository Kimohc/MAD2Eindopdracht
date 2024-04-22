
from sqlalchemy import Boolean, Column, Integer, String
from database import Base

class users(Base):
    __tablename__ = 'users'

    user_id = Column(Integer, primary_key = True, index = True)
    username = Column(String(255), unique = True)
    password = Column(String(255) , unique = True)

class tasks(Base):
    __tablename__ = 'tasks'
    task_id = Column(Integer, primary_key = True, index = True)
    naam = Column(String(255))
    beschrijving = Column(String(255))
    user_id = Column(Integer)