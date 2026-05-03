# Path validator - checks directory existence and creates if allowed

import logging
from pathlib import Path
from typing import Dict, Any, List, Tuple

logger = logging.getLogger(__name__)


class PathValidationError(Exception):
    """Raised when a required path does not exist."""
    pass


class PathValidator:
    """Validates and manages test directories.

    Handles two types of paths:
    - Required: Must exist before run, process stops if missing
    - Auto-create: Created automatically if missing

    Configuration from YAML:
        paths:
          source:
            name: "Source"
            required: true        # Must exist
            auto_create: false    # Do not create
          processed:
            name: "Processed"
            required: false      # Optional
            auto_create: true     # Create if missing
    """

    def __init__(self, paths_config: Dict[str, Any], base_path: Path):
        """Initialize path validator.

        Args:
            paths_config: Paths configuration from YAML
            base_path: Base directory for all paths
        """
        self.paths_config = paths_config
        self.base_path = Path(base_path)
        self.missing_required: List[str] = []
        self.created_paths: List[Path] = []

    def validate_all(self) -> Tuple[bool, List[str]]:
        """Validate all configured paths.

        Checks each path:
        - If required=true: Must exist, error if missing
        - If auto_create=true: Created if missing

        Returns:
            Tuple of (success, error_messages)
        """
        errors = []

        for path_key, path_info in self.paths_config.items():
            path_name = path_info.get("name", path_key)
            full_path = self.base_path / path_name

            required = path_info.get("required", False)
            auto_create = path_info.get("auto_create", False)
            description = path_info.get("description", path_key)

            logger.debug(
                f"Checking {path_key}: {full_path} "
                f"(required={required}, auto_create={auto_create})"
            )

            if full_path.exists():
                logger.debug(f"  Exists: {full_path}")
                continue

            # Path does not exist
            if required and not auto_create:
                # Must exist but cannot create -> error
                error_msg = (
                    f"Required directory missing: {full_path}\n"
                    f"  Config key: paths.{path_key}\n"
                    f"  Description: {description}\n"
                    f"  This directory must exist before running tests."
                )
                errors.append(error_msg)
                self.missing_required.append(path_key)
                logger.error(error_msg)

            elif auto_create:
                # Can create -> create directory
                try:
                    full_path.mkdir(parents=True, exist_ok=True)
                    self.created_paths.append(full_path)
                    logger.info(f"Created directory: {full_path}")
                except OSError as e:
                    error_msg = (
                        f"Failed to create directory: {full_path}\n"
                        f"  Config key: paths.{path_key}\n"
                        f"  Error: {e}"
                    )
                    errors.append(error_msg)
                    logger.error(error_msg)

            else:
                # Optional and not auto-create -> just log
                logger.warning(
                    f"Optional directory missing: {full_path} "
                    f"(paths.{path_key})"
                )

        if errors:
            return False, errors

        return True, []

    def get_path(self, path_key: str) -> Path:
        """Get resolved path for given config key.

        Args:
            path_key: Key from paths config (e.g., "source", "processed")

        Returns:
            Resolved Path object
        """
        path_info = self.paths_config.get(path_key, {})
        path_name = path_info.get("name", path_key)
        return self.base_path / path_name

    def get_all_paths(self) -> Dict[str, Path]:
        """Get all resolved paths.

        Returns:
            Dictionary mapping path keys to Path objects
        """
        return {
            key: self.get_path(key)
            for key in self.paths_config.keys()
        }

    def print_summary(self) -> None:
        """Print validation summary."""
        if self.created_paths:
            logger.info("Created directories:")
            for path in self.created_paths:
                logger.info(f"  + {path}")

        if self.missing_required:
            logger.error("Missing required directories:")
            for key in self.missing_required:
                path_info = self.paths_config.get(key, {})
                path_name = path_info.get("name", key)
                logger.error(f"  - {self.base_path / path_name}")
