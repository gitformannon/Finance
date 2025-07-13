import os
from dotenv import load_dotenv
# Load environment variables from .env file
load_dotenv()

# ──────────── CONFIG ────────────
SECRET_KEY = os.getenv("SECRET_KEY", "dev-secret-key")
ALGORITHM = os.getenv("ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 15))
REFRESH_TOKEN_EXPIRE_DAYS = int(os.getenv("REFRESH_TOKEN_EXPIRE_DAYS", 30))

REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379")

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql+asyncpg://user:pass@localhost/db")

SQLALCHEMY_ECHO = os.getenv("SQLALCHEMY_ECHO", "false").lower() == "true"
# Password reset configuration

FERNET_KEY = os.getenv("FERNET_KEY", "0" * 32)

# Paths
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
PROFILE_IMAGES_PATH = BASE_DIR / 'mobile_frontend' / 'assets' / 'png'
DEFAULT_PROFILE_IMAGE = 'assets/png/defaultProfileImage.png'

# ────────────────────────────────
