# Centralized logging configuration

import logging
import logging.config
from pathlib import Path
from typing import Optional

import yaml


def setup_logging(
    config_path: str = "config/logging.yaml",
    default_level: int = logging.INFO,
    log_dir: Optional[Path] = None
) -> None:
    """Setup logging from YAML configuration or use defaults.

    Args:
        config_path: Path to YAML logging configuration
        default_level: Default logging level if config file not found
        log_dir: Optional directory for log files
    """
    config_path = Path(config_path)

    if config_path.exists():
        with open(config_path, "r", encoding="utf-8") as f:
            config = yaml.safe_load(f)
        logging.config.dictConfig(config)
    else:
        # Default console logging
        handlers = [logging.StreamHandler()]

        # Add file handler if log directory provided
        if log_dir is not None:
            log_dir = Path(log_dir)
            log_dir.mkdir(parents=True, exist_ok=True)
            file_handler = logging.FileHandler(
                log_dir / "pytester.log",
                encoding="utf-8"
            )
            file_handler.setFormatter(
                logging.Formatter(
                    "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
                )
            )
            handlers.append(file_handler)

        logging.basicConfig(
            level=default_level,
            format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
            handlers=handlers
        )


def get_logger(name: str) -> logging.Logger:
    """Get logger instance with given name.

    Args:
        name: Logger name (typically __name__)

    Returns:
        Configured logger instance
    """
    return logging.getLogger(name)
