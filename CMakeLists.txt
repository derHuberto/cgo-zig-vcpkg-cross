set(CMAKE_C_COMPILER "zig" cc -target x86_64-windows-gnu)
set(CMAKE_CXX_COMPILER "zig" c++ -target x86_64-windows-gnu)
set(CMAKE_SYSTEM_NAME "Windows")
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR "x86_64")

include(CMakePrintHelpers)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(CMAKE_GENERATOR MATCHES "Visual Studio")
    message(FATAL_ERROR "Visual Studio generator not supported, use: cmake -G Ninja")
endif()

cmake_print_variables(${SCRIPT_SUFFIX})

if(WIN32)
    set(SCRIPT_SUFFIX ".cmd")
else()
    set(SCRIPT_SUFFIX ".sh")
endif()

# This is working (thanks to Simon for finding this trick)
set(CMAKE_AR "${CMAKE_CURRENT_LIST_DIR}/zig-ar${SCRIPT_SUFFIX}")
set(CMAKE_RANLIB "${CMAKE_CURRENT_LIST_DIR}/zig-ranlib${SCRIPT_SUFFIX}")

project(fibonacci CXX)
find_package(fmt REQUIRED)
find_package(range-v3 REQUIRED)
find_package(cxxopts REQUIRED)

add_library(fibo SHARED src/main.cpp)

target_include_directories(fibo
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

if(WIN32)
  set_target_properties(fibo PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS ON)
  set_target_properties(fibo PROPERTIES ARCHIVE_OUTPUT_NAME "fibo")
  set_target_properties(fibo PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
endif()

target_link_libraries(fibo
  PRIVATE
    fmt::fmt-header-only
    range-v3::range-v3
    cxxopts::cxxopts)

set_target_properties(fibo PROPERTIES
    PUBLIC_HEADER include/fibo.h
    WINDOWS_EXPORT_ALL_SYMBOLS ON
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
    OUTPUT_NAME "fibo"
)

install(TARGETS fibo
    RUNTIME DESTINATION ${CMAKE_BINARY_DIR}/bin
    LIBRARY DESTINATION ${CMAKE_BINARY_DIR}/lib
    ARCHIVE DESTINATION ${CMAKE_BINARY_DIR}/lib
    PUBLIC_HEADER DESTINATION ${CMAKE_BINARY_DIR}/include
)