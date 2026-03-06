from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base


engine = create_engine("postgresql://postgres:root@localhost:5432/esmail")

SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)

base = declarative_base()

def get_db():
    session = SessionLocal()
    try:
        yield session
    finally:
        session.close()

