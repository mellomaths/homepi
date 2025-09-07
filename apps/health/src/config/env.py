from functools import lru_cache
from pydantic import BaseModel
from pydantic_settings import BaseSettings, SettingsConfigDict


class ApplicationSettings(BaseModel):
    """
    Application settings.
    """
    name: str = "health-check"
    version: str = "0.0.1"
    description: str = "Health Check API"
    root_path: str = "/health"


class APISettings(BaseModel):
    """
    API settings.
    """
    version: str = "v1"
    path: str = "/api/v1"


class ServerSettings(BaseModel):
    """
    Server settings.
    """
    http_port: int = 3000


class FeatureFlags(BaseModel):
    """
    Feature flags.
    """
    pass


class LoggerSettings(BaseModel):
    """
    Logger settings.
    """
    name: str = "health-check-api"
    level: str = "TRACE"
    format: str = '%(asctime)s [%(processName)s: %(process)d] [%(threadName)s: %(thread)d] [%(levelname)s] %(name)s: %(message)s'
    file: str = "app.log"
    max_bytes: int = 1048576 # 1MB
    backup_count: int = 5 # Number of backup log files to keep


class PostgresSettings(BaseModel):
    """
    Postgres settings.
    """
    dialect: str = "postgresql+psycopg2"
    host: str = "localhost"
    port: int = 5432
    database_name: str = "postgres"
    username: str = "postgres"
    password: str = "postgres"


class CorsSettings(BaseModel):
    """
    CORS settings.
    """
    allow_origins: list[str] = ["*"]
    allow_credentials: bool = True
    allow_methods: list[str] = ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS']
    allow_headers: list[str] = ['*']


class Environment(BaseSettings):
    """
    Environment class that loads the application environment from the configuration file.
    """

    model_config = SettingsConfigDict(
        env_nested_delimiter='__',
        extra='ignore',
    )
    py_env: str = "local"  # Environment type (local, dev, prod)
    app: ApplicationSettings
    api: APISettings
    server: ServerSettings
    feature_flags: FeatureFlags
    logger: LoggerSettings
    postgres: PostgresSettings
    cors: CorsSettings

    @property
    def postgres_url(self):
        """
        Get the postgres URL.
        """
        return f"{self.postgres.dialect}://{self.postgres.username}:{self.postgres.password}@{self.postgres.host}:{self.postgres.port}/{self.postgres.database_name}"

    @property
    def is_production(self):
        """
        Check if the environment is production.
        """
        return self.py_env == "production"

    @staticmethod
    @lru_cache()
    def load():
        """
        Load the environment.
        """
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
