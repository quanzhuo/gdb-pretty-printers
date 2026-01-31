#!/bin/bash

# wxWidgets Test Case Runner
# This script builds the test case and runs GDB with pretty printers

set -e  # Exit on error

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AUTOLOAD_SCRIPT="$PROJECT_ROOT/autoload.py"

echo "=== Running wxWidgets GDB Pretty Printer Test ==="

# 1. Check if executable exists
EXE_PATH="$SCRIPT_DIR/build/wxWidgetsTypes"
if [ ! -f "$EXE_PATH" ]; then
    echo "[Build] Executable not found, compiling test case..."
    cmake -S "$SCRIPT_DIR" -B "$SCRIPT_DIR/build" -DCMAKE_BUILD_TYPE=Debug -G "Unix Makefiles"
    cmake --build "$SCRIPT_DIR/build"
    
    # Verify build succeeded
    if [ ! -f "$EXE_PATH" ]; then
        echo "[ERROR] Build failed: Executable not found: $EXE_PATH"
        exit 1
    fi
else
    echo "[Build] Using existing executable: $EXE_PATH"
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
