#!/usr/bin/env python3
"""PyTester - Automated Esko Tester (Python Migration)

Entry point for the Dynamic Tables testing workflow.

Usage:
    python main.py                    # Automatic mode (default)
    python main.py --manual           # Manual mode - confirm each step
    python main.py --csv tasks.csv    # Specific CSV only
    python main.py --dry-run          # Simulate without AI
"""

import argparse
import logging
import sys
from pathlib import Path

from core.orchestrator import TabTesterOrchestrator
from utils.logging_utils import setup_logging

SCRIPT_DIR = Path(__file__).parent.resolve()
logger = logging.getLogger(__name__)


def parse_args() -> argparse.Namespace:
    """Parse command line arguments."""
    default_config = SCRIPT_DIR / "config" / "aet.yaml"

    parser = argparse.ArgumentParser(
        description="PyTester - Automated Esko Tester",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                           # Automatic mode (default)
  %(prog)s --manual                  # Manual mode - confirm each step
  %(prog)s --config my_config.yaml   # Custom config
  %(prog)s --csv tasks.csv           # Specific CSV only
  %(prog)s --dry-run                 # Simulate without AI
        """
    )

    parser.add_argument(
        "--config",
        default=str(default_config),
        help=f"Path to YAML configuration file (default: {default_config})"
    )

    parser.add_argument(
        "--topic",
        default="Tab",
        help="Test topic name (default: Tab)"
    )

    parser.add_argument(
        "--csv",
        help="Process only specific CSV file from tickets directory"
    )

    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Simulate workflow without executing AI"
    )

    parser.add_argument(
        "--manual",
        action="store_true",
        help="Manual mode - confirm each step with option to skip"
    )

    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Enable verbose (debug) logging"
    )

    return parser.parse_args()


def main() -> int:
    """Main entry point."""
    args = parse_args()

    log_level = "DEBUG" if args.verbose else "INFO"
    setup_logging(default_level=getattr(logging, log_level))

    config_path = Path(args.config)

    logger.debug(f"Script directory: {SCRIPT_DIR}")
    logger.debug(f"Config path: {config_path}")
    logger.debug(f"Config exists: {config_path.exists()}")

    if not config_path.exists():
        logger.error(f"Configuration file not found: {config_path}")
        print(f"Error: Configuration file not found: {config_path}", file=sys.stderr)
        return 1

    try:
        orchestrator = TabTesterOrchestrator(
            config_path=str(config_path),
            script_dir=SCRIPT_DIR,
            manual_mode=args.manual  # Pass manual flag
        )
        success = orchestrator.run(
            topic=args.topic,
            specific_csv=args.csv,
            dry_run=args.dry_run
        )
        return 0 if success else 1

    except Exception as e:
        logger.exception("Unhandled exception")
        print(f"Fatal error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        logger.info("Interrupted by user")
        sys.exit(130)
