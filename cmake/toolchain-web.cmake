# Toolchain file for WebAssembly/WebGPU using Emscripten
#
# Usage:
#   cmake -DCMAKE_TOOLCHAIN_FILE=lib/system/cmake/toolchain-web.cmake ..
#
# Requires EMSDK environment variable to be set, or emcmake to be in PATH

set(CMAKE_SYSTEM_NAME Emscripten)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SIZEOF_VOID_P 4)  # wasm32 uses 32-bit pointers
set(CMAKE_C_BYTE_ORDER LITTLE_ENDIAN)
set(CMAKE_CXX_BYTE_ORDER LITTLE_ENDIAN)

# Find Emscripten
if(DEFINED ENV{EMSDK})
    set(EMSDK_PATH "$ENV{EMSDK}")
    set(EMSCRIPTEN_ROOT "${EMSDK_PATH}/upstream/emscripten")
elseif(EXISTS "/usr/share/emscripten")
    set(EMSCRIPTEN_ROOT "/usr/share/emscripten")
else()
    message(FATAL_ERROR "Could not find Emscripten. Set EMSDK environment variable or install Emscripten.")
endif()

# Compilers
set(CMAKE_C_COMPILER "${EMSCRIPTEN_ROOT}/emcc")
set(CMAKE_CXX_COMPILER "${EMSCRIPTEN_ROOT}/em++")
set(CMAKE_AR "${EMSCRIPTEN_ROOT}/emar")
set(CMAKE_RANLIB "${EMSCRIPTEN_ROOT}/emranlib")

# Target environment
set(CMAKE_FIND_ROOT_PATH "${EMSCRIPTEN_ROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Output settings
set(CMAKE_EXECUTABLE_SUFFIX ".js")

# WebGPU support (requires Emscripten 3.1.35+)
set(WHOA_WEB_USE_WEBGPU ON CACHE BOOL "Enable WebGPU support")

# Emscripten linker flags
set(WHOA_WEB_LINK_FLAGS "")

# Memory and async support
string(APPEND WHOA_WEB_LINK_FLAGS " -sALLOW_MEMORY_GROWTH=1")

string(APPEND WHOA_WEB_LINK_FLAGS " -sASYNCIFY")
string(APPEND WHOA_WEB_LINK_FLAGS " -sASYNCIFY_DEBUG=0")
string(APPEND WHOA_WEB_LINK_FLAGS " -sEXIT_RUNTIME=0")

# Debug symbols and source maps
string(APPEND WHOA_WEB_LINK_FLAGS " -g")
string(APPEND WHOA_WEB_LINK_FLAGS " -gsource-map")
string(APPEND WHOA_WEB_LINK_FLAGS " --source-map-base ./")

# Filesystem support
string(APPEND WHOA_WEB_LINK_FLAGS " -sFORCE_FILESYSTEM=1")
string(APPEND WHOA_WEB_LINK_FLAGS " -sFETCH=1")

# WebGPU (uses browser's native implementation via emdawnwebgpu bindings)
if(WHOA_WEB_USE_WEBGPU)
    set(WHOA_WEB_WEBGPU_PORT "--use-port=emdawnwebgpu")
    string(APPEND WHOA_WEB_LINK_FLAGS " ${WHOA_WEB_WEBGPU_PORT}")
endif()

# Export settings
string(APPEND WHOA_WEB_LINK_FLAGS " -sEXPORTED_RUNTIME_METHODS=['ccall','cwrap']")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${WHOA_WEB_WEBGPU_PORT}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${WHOA_WEB_WEBGPU_PORT}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${WHOA_WEB_LINK_FLAGS}")
