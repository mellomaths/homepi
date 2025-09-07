from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.sql import text

from config.env import Environment

SQLALCHEMY_DATABASE_URL = Environment.load().postgres.url

engine = create_engine(
    SQLALCHEMY_DATABASE_URL
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def check_postgres_health(session: Session):
    is_database_working = True
    error = None

    try:
        # to check database we will execute raw query
        session.execute(text("SELECT 1"))
    except Exception as e:
        error = str(e)
        is_database_working = False

    return is_database_working, error

def get_postgres_session():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
