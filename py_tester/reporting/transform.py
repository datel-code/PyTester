# HTML transformer - transforms XML statistics to HTML

import logging
from pathlib import Path
from typing import Dict

try:
    from lxml import etree
    HAS_LXML = True
except ImportError:
    HAS_LXML = False

logger = logging.getLogger(__name__)


class HTMLTransformer:
    """Transforms XML statistics to HTML using XSLT.

    Replaces the original TRANSFORM.bat functionality.
    """

    def __init__(self, paths: Dict[str, Path]):
        """Initialize HTML transformer.

        Args:
            paths: Dictionary of resolved paths
        """
        self.paths = paths
        self.xsl_path = Path(__file__).parent.parent / "templates" / "report.xsl"

    def transform(self, xml_path: Path) -> Path:
        """Transform XML statistics to HTML.

        Args:
            xml_path: Path to XML statistics file

        Returns:
            Path to generated HTML file
        """
        html_path = xml_path.with_suffix(".html")

        if HAS_LXML and self.xsl_path.exists():
            return self._xslt_transform(xml_path, html_path)
        else:
            return self._default_html(xml_path, html_path)

    def _xslt_transform(self, xml_path: Path, html_path: Path) -> Path:
        """Transform using XSLT."""
        try:
            xml_doc = etree.parse(str(xml_path))
            xsl_doc = etree.parse(str(self.xsl_path))
            transform = etree.XSLT(xsl_doc)
            html_doc = transform(xml_doc)

            html_doc.write(str(html_path), pretty_print=True, encoding="utf-8")
            logger.info(f"HTML report generated: {html_path}")
            return html_path

        except Exception as e:
            logger.exception("XSLT transform failed, using default HTML")
            return self._default_html(xml_path, html_path)

    def _default_html(self, xml_path: Path, html_path: Path) -> Path:
        """Generate simple default HTML."""
        from datetime import datetime

        content = f"""<!DOCTYPE html>
<html>
<head>
    <title>PyTester Report</title>
    <style>
        body {{ font-family: Arial, sans-serif; margin: 40px; }}
        h1 {{ color: #333; }}
        pre {{ background: #f5f5f5; padding: 20px; border-radius: 5px; overflow: auto; }}
    </style>
</head>
<body>
    <h1>Test Report</h1>
    <p>Generated: {datetime.now()}</p>
    <pre>{xml_path.read_text(encoding="utf-8")}</pre>
</body>
</html>"""

        html_path.write_text(content, encoding="utf-8")
        logger.info(f"Default HTML report generated: {html_path}")
        return html_path
