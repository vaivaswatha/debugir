cmake_minimum_required(VERSION 3.5.1)

project(DebugIR LANGUAGES C CXX)

option(LINK_LLVM_SHARED "Control whether debugir links to a shared LLVM library, or individual static components" ON)

# export compile commands
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# C++ standard
set(CMAKE_CXX_STANDARD 20)

# detect operating system
message(STATUS "We are on a ${CMAKE_SYSTEM_NAME} system")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Print build type: Debug/Release etc.
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
#
# check dependencies
#
# LLVM stuff
find_package(LLVM 18.1 REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
if(LINK_LLVM_SHARED)
  set(llvm_libs LLVM)
else()
  # Find the libraries that correspond to the LLVM components we use
  llvm_map_components_to_libnames(llvm_libs support core irreader transformutils Passes)
endif()

add_library(dbgir SHARED DebugIR.cpp)

# Match LLVM's RTTI build mode
if (NOT LLVM_ENABLE_RTTI)
  message(STATUS "LLVM does not have RTTI enabled. Building with -fno-rtti")
  target_compile_options(dbgir PUBLIC -fno-rtti)
endif()

set(DEBUGIR_WARN_FLAGS
  -Wall
  -Werror
  -pedantic
  -Wextra
  -Wno-unknown-pragmas
  -Wno-unused-parameter
)

# compiler and linker options
#   PUBLIC because we apply the same to the debugir executable
target_compile_options(dbgir PRIVATE ${DEBUGIR_WARN_FLAGS})

separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
target_compile_definitions(dbgir PUBLIC ${LLVM_DEFINITIONS_LIST})
target_include_directories(dbgir PUBLIC ${PROJECT_SOURCE_DIR}/include/)
target_include_directories(dbgir PUBLIC ${LLVM_INCLUDE_DIRS})
target_link_libraries (dbgir PUBLIC ${llvm_libs})

add_executable(debugir Main.cpp)
target_compile_options(debugir PRIVATE ${DEBUGIR_WARN_FLAGS})
target_link_libraries(debugir dbgir)
