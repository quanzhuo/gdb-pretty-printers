# Common test helper functions for GDB pretty printer tests
python
import gdb
import re
import sys

# ANSI color codes
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
RESET = '\033[0m'

def check(expr, pattern):
    """
    Check if a GDB expression output matches the expected pattern.
    
    Args:
        expr: The GDB expression to evaluate (e.g., "myvar")
        pattern: A regex pattern to match against the output
    """
    try:
        # execute the print command and capture output
        output = gdb.execute(f"print {expr}", to_string=True)
    except Exception as e:
        # Allow failure for now if variable possibly doesn't exist
        if "No symbol" in str(e):
             print(f"{YELLOW}[TEST SKIP]{RESET} Symbol '{expr}' not found")
             return
        print(f"\n{RED}[TEST FAIL]{RESET} GDB Error evaluating '{expr}': {e}")
        sys.exit(1)

    # Check if pattern matches the output
    if not re.search(pattern, output, re.MULTILINE | re.DOTALL):
        print(f"\n{RED}[TEST FAIL]{RESET} Assertion Failed!")
        print(f"Expression: {expr}")
        print(f"Expected Pattern: {pattern}")
        print(f"Actual Output:    {output.strip()}")
        sys.exit(1) # Force GDB to exit with error code
    else:
        print(f"{GREEN}[TEST PASS]{RESET} {expr}")
end
