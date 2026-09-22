cmake_minimum_required(VERSION 3.20)

project(DebugIR LANGUAGES C CXX)

option(LINK_LLVM_SHARED "Control whether debugir links to a shared LLVM library, or individual static components" ON)

# export compile commands
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# C++ standard
set(CMAKE_CXX_STANDARD 20)

# detect operating system
message(STATUS "We are on a ${CMAKE_SYSTEM_NAME} system")

# Print build type: Debug/Release etc.
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
#
# check dependencies
#
# LLVM stuff
# Keep this in step with the check at the top of DebugIR.cpp and with the README.
set(DEBUGIR_LLVM_MIN_VERSION 16)
set(DEBUGIR_LLVM_MAX_VERSION 23)

# Set DEBUGIR_LLVM_VERSION to choose between several installed LLVM versions,
# or set LLVM_DIR to point at one of them.
if(DEFINED DEBUGIR_LLVM_VERSION)
  find_package(LLVM ${DEBUGIR_LLVM_VERSION} REQUIRED CONFIG)
else()
  find_package(LLVM REQUIRED CONFIG)
endif()
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")
if(LLVM_VERSION_MAJOR LESS DEBUGIR_LLVM_MIN_VERSION OR
   LLVM_VERSION_MAJOR GREATER DEBUGIR_LLVM_MAX_VERSION)
  message(FATAL_ERROR
          "debugir needs LLVM ${DEBUGIR_LLVM_MIN_VERSION} to "
          "${DEBUGIR_LLVM_MAX_VERSION}, but found ${LLVM_PACKAGE_VERSION}")
endif()
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

#
# tests
#
# Find FileCheck in the LLVM tools directory. lit can also be under build/utils.
# Do not add the test target if either tool is absent.
find_program(DEBUGIR_LIT NAMES lit llvm-lit lit.py
             HINTS ${LLVM_TOOLS_BINARY_DIR}
                   ${LLVM_TOOLS_BINARY_DIR}/../build/utils/lit)
find_program(DEBUGIR_FILECHECK NAMES FileCheck HINTS ${LLVM_TOOLS_BINARY_DIR})
if(DEBUGIR_LIT AND DEBUGIR_FILECHECK)
  set(DEBUGIR_EXE ${CMAKE_CURRENT_BINARY_DIR}/debugir)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/test/lit.site.cfg.py.in
                 ${CMAKE_CURRENT_BINARY_DIR}/test/lit.site.cfg.py @ONLY)
  add_custom_target(check
                    COMMAND ${DEBUGIR_LIT} -sv ${CMAKE_CURRENT_BINARY_DIR}/test
                    DEPENDS debugir
                    USES_TERMINAL)
  message(STATUS "Tests are available through the 'check' target")
else()
  message(STATUS "lit or FileCheck not found: the 'check' target is not available")
endif()
