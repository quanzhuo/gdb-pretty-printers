cmake_minimum_required(VERSION 3.16)

project(wxWidgetsTypes LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find wxWidgets
find_package(wxWidgets REQUIRED COMPONENTS base)
include(${wxWidgets_USE_FILE})

add_executable(wxWidgetsTypes
    main.cpp
)

target_link_libraries(wxWidgetsTypes PRIVATE ${wxWidgets_LIBRARIES})

include(GNUInstallDirs)
install(TARGETS wxWidgetsTypes
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
