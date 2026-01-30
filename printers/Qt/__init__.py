import re
import sys
from . import qt

# Protocol: Regular expression to match against the objfile filename.
if sys.platform.startswith("win"):
    # Windows: Match Qt5Core.dll, Qt6Cored.dll, etc.
    # Strictly end with .dll to verify it's the executable module and avoid .debug files
    OBJFILE_MATCH_PATTERN = re.compile(r"(?:^|[/\\])Qt\d?Core(?:d)?\.dll$", re.IGNORECASE)
else:
    # Linux/Unix: Match libQt5Core.so, libQt6Core.so, etc.
    OBJFILE_MATCH_PATTERN = re.compile(r"(?:^|/)libQt\d?Core\.so", re.IGNORECASE)

def register_printers(objfile):
    """
    Protocol: The registration entry point.
    """
    # Defensive check: Avoid duplicate registration without modifying qt.py
    # We check if we've already tagged a printer in this objfile.
    tag_name = "QtPrettyPrinters_Autoload"
    for p in objfile.pretty_printers:
        if getattr(p, "name", None) == tag_name:
            return

    # Call the original registration logic
    qt.register_qt_printers(objfile)

    # Post-registration: Tag the last added printer so we can identify it later
    if objfile.pretty_printers:
        objfile.pretty_printers[-1].name = tag_name
