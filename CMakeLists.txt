
include(CMakePrintHelpers)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(CMAKE_GENERATOR MATCHES "Visual Studio")
    message(FATAL_ERROR "Visual Studio generator not supported, use: cmake -G Ninja")
endif()


# This is working (thanks to Simon for finding this trick)
set(CMAKE_AR "zig-ar.sh")
set(CMAKE_RANLIB "zig-ranlib.sh")

project(fibonacci CXX)
find_package(fmt REQUIRED)
find_package(range-v3 REQUIRED)
find_package(cxxopts REQUIRED)

add_library(fibo SHARED src/main.cpp)

target_include_directories(fibo
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)


  set_target_properties(fibo PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS ON)
  set_target_properties(fibo PROPERTIES ARCHIVE_OUTPUT_NAME "fibo")
  set_target_properties(fibo PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")


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