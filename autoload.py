import gdb
import os
import sys
import re
import importlib
import pkgutil
import datetime

# --- Configuration ---
# Set to True to enable debug logging to autoload.log in the same directory
ENABLE_LOGGING = False

# Ensure the local printers directory is in sys.path so we can import modules from it.
current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.insert(0, current_dir)

log_file = os.path.join(current_dir, "autoload.log")


def log_to_file(msg):
    if not ENABLE_LOGGING:
        return

    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    try:
        with open(log_file, "a", encoding="utf-8") as f:
            f.write(f"[{timestamp}] [Autoload] {msg}\n")
    except:
        pass


def log_info(msg):
    log_to_file(msg)


def log_error(msg):
    """Log errors to GDB console and file."""
    try:
        gdb.write(f"[Autoload Error] {msg}\n")
    except:
        pass
    log_to_file(f"ERROR: {msg}")


if ENABLE_LOGGING:
    log_info("Script execution started.")

# List to hold (regex_pattern, register_function, module_name) tuples
_registered_printer_modules = []


def load_printer_modules():
    """
    Dynamically discover and load printer modules from the 'printers' package.
    Each submodule in 'printers' is expected to have an __init__.py defining:
      - OBJFILE_MATCH_PATTERN: A compiled regex object or string to match filenames.
      - register_printers(objfile): A function to perform registration.
    """
    global _registered_printer_modules
    _registered_printer_modules = []

    try:
        import printers
    except Exception as e:
        log_error(f"Failed to import 'printers' package: {e}")
        return

    # Iterate over all submodules in the 'printers' package (e.g., printers.Qt, printers.wxWidgets)
    package_path = (
        os.path.dirname(printers.__file__)
        if hasattr(printers, "__file__")
        else os.path.join(current_dir, "printers")
    )
    log_info(f"Scanning for printers in: {package_path}")

    try:
        for _, name, ispkg in pkgutil.iter_modules([package_path]):
            if ispkg:
                try:
                    # Use absolute import based on the package name
                    module = importlib.import_module(f"printers.{name}")

                    # Check if the module conforms to the protocol
                    if hasattr(module, "register_printers") and hasattr(
                        module, "OBJFILE_MATCH_PATTERN"
                    ):
                        pattern = module.OBJFILE_MATCH_PATTERN
                        if isinstance(pattern, str):
                            pattern = re.compile(pattern, re.IGNORECASE)

                        _registered_printer_modules.append(
                            {
                                "pattern": pattern,
                                "func": module.register_printers,
                                "name": name,
                            }
                        )
                        log_info(f"Registered printer module: {name}")
                    else:
                        log_info(
                            f"Skipped {name}: missing 'register_printers' or 'OBJFILE_MATCH_PATTERN'"
                        )
                except Exception as e:
                    log_error(f"Error loading printer module '{name}': {e}")
    except Exception as e:
        log_error(f"Error during module iteration: {e}")


def register_printers_hook(event):
    """
    GDB event hook: Called when a new objfile is loaded.
    """
    objfile = event.new_objfile
    filename = objfile.filename

    # Check if the loaded file matches any registered printer module
    for handler in _registered_printer_modules:
        if handler["pattern"].search(filename):
            log_info(
                f"Matched '{handler['name']}' handler for {filename}. Registering..."
            )
            try:
                # Some register functions might not take arguments, but our protocol says one arg (objfile)
                handler["func"](objfile)
            except Exception as e:
                log_error(f"Error registering printers for {handler['name']}: {e}")


# --- Initialization ---

# 1. Discover modules
load_printer_modules()

# 2. Connect the hook for future loads
gdb.events.new_objfile.connect(register_printers_hook)

# 3. Process already loaded objfiles (in case script is sourced after startup)
for objfile in gdb.objfiles():

    class MockEvent:
        def __init__(self, o):
            self.new_objfile = o

    register_printers_hook(MockEvent(objfile))
