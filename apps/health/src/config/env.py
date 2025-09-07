from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict
from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())


class Environment(BaseSettings):
    """
    Environment class that loads the application environment from the configuration file.
    """

    model_config = SettingsConfigDict(
        env_file='.env',
        env_file_encoding='utf-8',
        case_sensitive=True,
        extra='ignore'
    )
    py_env: str = "local"  # Environment type (local, dev, prod)

    # Application Settings
    app_name: str = "health-check"
    app_version: str = "0.0.1"
    app_description: str = "Health Check API"
    app_root_path: str = "/health"
    
    # API Settings
    api_version: str = "v1"
    api_path: str = f"/api/{api_version}"

    # Server Settings
    http_port: int = 3000

    # Feature Flags
    # ------------------------------

    # Logging Settings
    logger_name: str = "health-check-api"
    log_level: str = "TRACE"  # Default log level
    log_format: str = '%(asctime)s [%(processName)s: %(process)d] [%(threadName)s: %(thread)d] [%(levelname)s] %(name)s: %(message)s'
    log_file: str = "app.log"
    log_max_bytes: int = 1048576 # 1MB
    log_backup_count: int = 5 # Number of backup log files to keep

    service_name: str = "health-check"

    # Postgres Settings
    postgres_dialect: str = "postgresql+psycopg2"
    postgres_host: str = "localhost"
    postgres_port: int = 5432
    postgres_database_name: str = "postgres"
    postgres_username: str = "postgres"
    postgres_password: str = "postgres"
    postgres_url: str = f"{postgres_dialect}://{postgres_username}:{postgres_password}@{postgres_host}:{postgres_port}/{postgres_database_name}"

    # CORS Settings
    cors_allow_origins: list[str] = ["*"]
    cors_allow_credentials: bool = True
    cors_allow_methods: list[str] = ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'] # Allow common HTTP methods
    cors_allow_headers: list[str] = ['*']


    @staticmethod
    @lru_cache()
    def load():
        return Environment()


def get_environment():
    """
    Dependency that provides application environment.
    This function loads the application environment from the configuration file.
    
    Returns
    -------
    Environment
        An instance of the Environment class containing the application configuration.
    """
    environment = Environment.load()
    if not environment:
        raise ValueError("Environment could not be loaded")
    return environment
