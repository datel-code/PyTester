# Mailer - sends email notifications with reports

import logging
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders
from pathlib import Path
from typing import Dict, Any
from datetime import datetime

logger = logging.getLogger(__name__)


class Mailer:
    """Sends email notifications with test reports.

    Replaces the original MAILER.bat functionality (blat.exe).
    """

    def __init__(self, config: Dict[str, Any]):
        """Initialize mailer.

        Args:
            config: Email configuration dictionary
        """
        self.config = config

    def send_report(
        self,
        report_path: Path,
        topic: str,
        stats: Dict[str, Any]
    ) -> bool:
        """Send HTML report via email.

        Args:
            report_path: Path to HTML report file
            topic: Test topic name
            stats: Statistics dictionary

        Returns:
            True if sent successfully
        """
        try:
            msg = MIMEMultipart()
            msg["From"] = self.config["from"]
            msg["To"] = ", ".join(self.config["to"])
            msg["Subject"] = self.config["subject_template"].format(
                topic=topic,
                date=datetime.now().strftime("%Y-%m-%d")
            )

            # Attach HTML report
            with open(report_path, "rb") as f:
                attachment = MIMEBase("text", "html")
                attachment.set_payload(f.read())
                encoders.encode_base64(attachment)
                attachment.add_header(
                    "Content-Disposition",
                    f'attachment; filename="{report_path.name}"'
                )
                msg.attach(attachment)

            # Send
            with smtplib.SMTP(self.config["smtp_server"]) as server:
                server.send_message(msg)

            logger.info(f"Report sent to {self.config['to']}")
            return True

        except Exception as e:
            logger.exception("Failed to send email")
            return False
