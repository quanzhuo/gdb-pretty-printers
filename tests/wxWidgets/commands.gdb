# Load common test helper functions
source ../test_helpers.gdb

# Set breakpoints
break main.cpp:32

# Run the program
run

# ---------------------------------------------------------
# Test Cases (Output checks happen inside GDB now)
# ---------------------------------------------------------

python check("str_ascii", '\"Hello wxWidgets\"')
python check("str_unicode", '\"你好 wxWidgets\"')

# wxDateTime: isoformat(' ') uses space separator.
# Matches: 2023-12-25 13:30:45
python check("dt_fixed", '2023-12-25 13:30:45')

# wxFileName: The printer evaluates GetFullPath(0)
# We match part of the path to be safe cross-platform or expect the specific string set in main.cpp
python check("fname", r'Projects|projects.*readme\.txt')

# wxPoint: (%d, %d)
python check("pt", r'\(10, 20\)')

# wxSize: %d*%d
python check("sz", r'800\*600')

# wxRect: (%d, %d) %d*%d
python check("rect", r'\(10, 20\) 800\*600')

# Continue to finish
continue
quit
