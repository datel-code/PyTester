# Path utilities for cross-platform UNC/DOS/Unix path conversions

import logging
import platform
from pathlib import Path
from typing import Optional, Union

logger = logging.getLogger(__name__)


def resolve_root(config: dict, script_dir: Path) -> Path:
    """Resolve test data root directory from configuration.

    Supports multiple root types:
    - "auto": Use script directory + optional subpath
    - "." : Use current working directory
    - "T:": Windows drive letter
    - "/Volumes/share": macOS/Linux mount point
    - "\\\\server\\share": UNC path (Windows)

    Args:
        config: System configuration dictionary with 'root' key
        script_dir: Directory where the main script is located

    Returns:
        Resolved Path object for root directory
    """
    root_value = config.get("root", "auto")

    if root_value == "auto":
        # Use script directory as base
        subpath = config.get("auto_root_subpath", "")
        root = script_dir
        if subpath:
            root = root / subpath
        logger.debug(f"Auto root resolved: {root}")
        return root

    elif root_value == ".":
        # Use current working directory
        root = Path.cwd()
        logger.debug(f"CWD root resolved: {root}")
        return root

    elif len(root_value) == 2 and root_value.endswith(":"):
        # Windows drive letter (e.g., "T:")
        root = Path(root_value + "/")
        logger.debug(f"Drive root resolved: {root}")
        return root

    elif root_value.startswith("\\\\"):
        # UNC path (Windows network share)
        root = normalize_unc_path(root_value)
        logger.debug(f"UNC root resolved: {root}")
        return root

    else:
        # Regular absolute or relative path
        root = Path(root_value)
        logger.debug(f"Explicit root resolved: {root}")
        return root


def normalize_unc_path(path_str: str) -> Path:
    """Normalize UNC path for current platform.

    On Windows: returns Path as-is
    On macOS/Linux: converts UNC to mount point (/Volumes/share or /mnt/share)

    Args:
        path_str: UNC path string (e.g., "\\\\server\\share\\path")

    Returns:
        Normalized Path object
    """
    if platform.system() == "Windows":
        return Path(path_str)
    else:
        # Convert UNC to mount point
        # \\\\server\\share\\path -> /Volumes/share/path or /mnt/share/path
        parts = path_str.replace("\\\\", "/").split("/")
        # parts = ["", "", "server", "share", "path", ...]

        # Try common mount points
        for mount_base in ["/Volumes", "/mnt", "/media"]:
            mount_point = Path(mount_base) / parts[2]
            if mount_point.exists():
                result = mount_point / "/".join(parts[3:])
                logger.debug(f"UNC mapped to: {result}")
                return result

        # Fallback to /Volumes (most common on macOS)
        result = Path("/Volumes") / parts[2] / "/".join(parts[3:])
        logger.debug(f"UNC fallback to: {result}")
        return result


def to_unc_path(path: Path) -> str:
    """Convert Path back to UNC string for JSX usage.

    Args:
        path: Path object to convert

    Returns:
        UNC-style path string with backslashes
    """
    return str(path).replace("/", "\\\\")


def to_jsx_string(path: Path) -> str:
    """Convert path to JSX-compatible string with double-escaped backslashes.

    In JSX strings, backslashes must be escaped as \\\\\\\\.

    Args:
        path: Path object to convert

    Returns:
        String with properly escaped backslashes for JSX
    """
    return str(path).replace("\\\\", "\\\\\\\\\\\\\\\\")


def ensure_dir(path: Union[str, Path]) -> Path:
    """Ensure directory exists, create if necessary.

    Args:
        path: Directory path to ensure

    Returns:
        Path object
    """
    path = Path(path)
    path.mkdir(parents=True, exist_ok=True)
    return path


def is_unc_path(path_str: str) -> bool:
    """Check if string is a UNC path.

    Args:
        path_str: Path string to check

    Returns:
        True if UNC path
    """
    return path_str.startswith("\\\\")


def get_relative_to_root(full_path: Path, root: Path) -> Path:
    """Get path relative to root directory.

    Args:
        full_path: Absolute path
        root: Root directory

    Returns:
        Relative path from root
    """
    try:
        return full_path.relative_to(root)
    except ValueError:
        # Path is not under root, return as-is
        return full_path
