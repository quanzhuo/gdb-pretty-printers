# GDB Pretty Printers Collection

This repository houses a collection of GDB pretty printers for various C++ libraries (e.g., Qt).

It is primarily maintained for use with the **kylinideteam.cppdebug** VS Code extension, but can be used in any GDB environment. Its main feature is an intelligent autoloading mechanism that registers specific printers only when the corresponding library is loaded into the debug session.

## Architecture

The core of this repository is the `autoload.py` script. Instead of registering all printers at startup (which can be slow and pollute the global namespace), `autoload.py` listens to GDB's `new_objfile` event.

When a shared library (e.g., `Qt6Core.dll` or `libQt6Core.so`) is loaded, the script dynamically scans the `printers/` directory for matching handlers and registers the appropriate printers *scoped to that specific object file*.

## Usage

To use these printers in GDB, simply source the `autoload.py` script.

In VS Code (`launch.json`):
```json
"setupCommands": [
    {
        "description": "Load GDB Pretty Printers",
        "text": "source /path/to/gdb-pretty-printers/autoload.py",
        "ignoreFailures": false
    }
]
```

## Adding New Printers

The system is designed to be extensible without modifying the core `autoload.py` script. To add support for a new library, you must follow the **Printer Module Protocol**.

### Step 1: Create a Module

Create a new subdirectory inside the `printers/` folder (e.g., `printers/MyLibrary/`).

### Step 2: Implement the Protocol

Inside your new folder, create an `__init__.py` file. This file **MUST** expose the following two symbols:

1.  `OBJFILE_MATCH_PATTERN`: A compiled Python `re` pattern (or regex string) that matches the filename of the shared library or executable.
2.  `register_printers(objfile)`: A function that accepts a `gdb.Objfile` object and registers the printers for it.

### Example Implementation

**File:** `printers/MyLibrary/__init__.py`

```python
import re
import sys
# Import your actual printer logic (assuming you have a my_impl.py in the same folder)
# from . import my_impl

# --- Protocol Requirement 1: The Match Pattern ---
# Define regex to match the library name. 
# It is good practice to handle platform differences.
if sys.platform.startswith("win"):
    # Windows: match MyLib.dll, ignoring case
    OBJFILE_MATCH_PATTERN = re.compile(r"(?:^|[/\\])MyLib(?:d)?\.dll$", re.IGNORECASE)
else:
    # Linux/Unix: match libMyLib.so
    OBJFILE_MATCH_PATTERN = re.compile(r"(?:^|/)libMyLib\.so", re.IGNORECASE)

# --- Protocol Requirement 2: The Registration Entry Point ---
def register_printers(objfile):
    """
    Called by autoload.py when a matching objfile is loaded.
    """
    
    # Recommended: Prevent duplicate registration
    # Assign a unique name to your printer collection
    PRINTER_NAME = "MyLibrary_PrettyPrinters"
    
    for p in objfile.pretty_printers:
        if getattr(p, "name", None) == PRINTER_NAME:
            return

    # Perform the actual registration
    # my_impl.register_printers(objfile)
    
    # Or simple example:
    # objfile.pretty_printers.append(my_lookup_function)
    # objfile.pretty_printers[-1].name = PRINTER_NAME
```

Once the file is created, `autoload.py` will automatically discover it on the next run.