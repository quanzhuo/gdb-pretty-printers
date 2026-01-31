#!/bin/bash

# wxWidgets Test Case Runner
# This script builds the test case and runs GDB with pretty printers

set -e  # Exit on error

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AUTOLOAD_SCRIPT="$PROJECT_ROOT/autoload.py"

echo "=== Running wxWidgets GDB Pretty Printer Test ==="

# 1. Build the test executable
echo "[Build] Compiling test case..."
cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" -DCMAKE_BUILD_TYPE=Debug -G "Unix Makefiles"
cmake --build "$SCRIPT_DIR/build"

# Check if executable exists
EXE_PATH="$SCRIPT_DIR/build/wxWidgetsTypes"
if [ ! -f "$EXE_PATH" ]; then
    echo "[ERROR] Executable not found: $EXE_PATH"
    exit 1
fi

# 2. Run GDB with pretty printers
echo "[GDB] Running debugger with pretty printers..."
gdb -n -batch \
    -ex "source $AUTOLOAD_SCRIPT" \
    -ex "file $EXE_PATH" \
    -x "$SCRIPT_DIR/commands.gdb"

# Check GDB exit code
if [ $? -eq 0 ]; then
    echo ""
    echo "[SUCCESS] All tests passed!"
    exit 0
else
    echo ""
    echo "[FAILED] Some tests failed!"
    exit 1
fi
