import logging
import logging.config
from config.logging.logging_settings import LOGGING_CONFIG
from functools import lru_cache
from config.env import Environment


@lru_cache()
def load_logger():
    """Load and configure the logger based on settings."""
    environment = Environment.load()
    logging.config.dictConfig(LOGGING_CONFIG)
    logger = logging.getLogger(environment.logger_name)
    return logger


def get_logger():
    """
    Dependency that provides a logger instance.
    This function loads the logger configuration and returns a logger instance that can be used for logging throughout
    the application.
    
    Returns
    -------
    Logger
        A logger instance configured according to the application's logging settings.
    """
    return load_logger()
