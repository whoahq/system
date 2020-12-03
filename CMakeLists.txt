cmake_minimum_required(VERSION 3.1)

if (${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
    message(FATAL_ERROR
        "In-source builds not allowed.
        Please make a new directory (called a build directory) and run CMake from there.
        You may need to remove CMakeCache.txt."
    )
endif()

if(TARGET system)
    # Guard for use as transitive dependency
    return()
endif()

# Project
project(system)

set(CMAKE_CXX_STANDARD 11)

add_subdirectory(system)
