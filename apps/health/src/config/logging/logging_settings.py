from config.logging.formatter.custom_json_formatter import CustomJSONFormatter
from config.env import Environment


environment = Environment.load()

LOGGING_CONFIG = { 
    'version': 1,
    'disable_existing_loggers': True,
    'formatters': { 
        'standard': { 
            'format': environment.log_format,
        },
        'custom_json_formatter': { 
            '()':  lambda: CustomJSONFormatter(fmt='%(asctime)s')           
        },
        'custom_formatter': { 
            'format': environment.log_format,  
        },
    },
    'handlers': { 
        'default': { 
            'formatter': 'standard',
            'class': 'logging.StreamHandler',
            'stream': 'ext://sys.stdout',  # Default is stderr
        },
        'stream_handler': { 
            'formatter': 'custom_formatter',
            'class': 'logging.StreamHandler',
            'stream': 'ext://sys.stdout',  # Default is stderr
        },
        'file_handler': { 
            'formatter': 'custom_json_formatter',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': environment.log_file,  # Default log file name
            'maxBytes': environment.log_max_bytes, # = 1MB
            'backupCount': environment.log_backup_count,  # Number of backup log files to keep
            'mode': 'w',  # Overwrite file each run
        },
    },
    'loggers': {
        f'{environment.logger_name}': {
            'handlers': ['default', 'file_handler'],
            'level': 'INFO', 
            'propagate': False
        },
        # 'uvicorn': {
        #     'handlers': ['default', 'file_handler'],
        #     'level': 'TRACE',
        #     'propagate': False
        # },
        # 'uvicorn.access': {
        #     'handlers': ['stream_handler', 'file_handler'],
        #     'level': 'TRACE',
        #     'propagate': False
        # },
        # 'uvicorn.error': { 
        #     'handlers': ['stream_handler', 'file_handler'],
        #     'level': 'TRACE',
        #     'propagate': False
        # },
        # 'uvicorn.asgi': {
        #     'handlers': ['stream_handler', 'file_handler'],
        #     'level': 'TRACE',
        #     'propagate': False
        # },
    },
}
