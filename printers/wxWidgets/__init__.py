import re
import sys
from . import printer

# Defines the pattern to match the wxWidgets core shared library.
# We want to register the printers only once when the core wx library is loaded.
if sys.platform.startswith("win"):
    # Windows: Matches things like wxbase31u.dll, wxbase32ud.dll, wxbase32u_vc140.dll
    OBJFILE_MATCH_PATTERN = re.compile(r"(?:^|[/\\])wxbase.*\.dll$", re.IGNORECASE)
else:
    # Linux/Unix: Matches libwx_baseu-3.0.so, etc.
    OBJFILE_MATCH_PATTERN = re.compile(r"(?:^|/)libwx_base.*\.so", re.IGNORECASE)

def register_printers(objfile):
    """
    Registers the wxWidgets pretty printers for the specific objfile.
    """
    # Defensive check: ensure we don't register twice for the same objfile
    tag_name = "wxPrettyPrinters_Autoload"
    for p in objfile.pretty_printers:
        if getattr(p, "name", None) == tag_name:
            return

    # Add the lookup function to the objfile's pretty printers list
    # The lookup function is defined in printer.py
    objfile.pretty_printers.append(printer.wxLookupFunction)

    # Tag the last added printer so we can identify it later
    if objfile.pretty_printers:
        objfile.pretty_printers[-1].name = tag_name
