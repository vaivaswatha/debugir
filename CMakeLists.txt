cmake_minimum_required(VERSION 3.5.1)

project(DebugIR)
set(TARGET debugir)

# detect operating system
message(STATUS "We are on a ${CMAKE_SYSTEM_NAME} system")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Print build type: Debug/Release etc.
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
#
# check dependencies
#
# LLVM stuff
find_package(LLVM REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

# Find the libraries that correspond to the LLVM components we use
llvm_map_components_to_libnames(llvm_libs support core irreader transformutils)

# include llvm cmake module
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

# compiler and linker options
add_compile_options(-Wall)
add_compile_options(-Werror)
add_compile_options(-pedantic)
add_compile_options(-Wextra)
add_compile_options(-Wno-unknown-pragmas)

# export compile commands
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# C++ standard
set(CMAKE_CXX_STANDARD 14)

# use add llvm
add_llvm_executable(${TARGET}
  DebugIR.cpp
  Main.cpp
)

target_compile_definitions(${TARGET} PUBLIC ${LLVM_DEFINITIONS})
target_include_directories(${TARGET} PUBLIC ${PROJECT_SOURCE_DIR})
# We include LLVM includes as system includes to avoid warnings from there.
target_include_directories(${TARGET} SYSTEM PUBLIC ${LLVM_INCLUDE_DIRS})
target_link_libraries (${TARGET} PUBLIC ${llvm_libs})
