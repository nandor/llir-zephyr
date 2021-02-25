# SPDX-License-Identifier: Apache-2.0

set(LLVM_TOOLCHAIN_PATH $ENV{HOME}/Projects/llir/dist/)
set(TOOLCHAIN_HOME $ENV{HOME}/Projects/llir/dist/bin/)

set(COMPILER llir)
set(LINKER llir)
set(BINTOOLS llir)

set(triple llir_x86_64-pc-none)
set(LLIR_PREFIX ${triple}-)

set(CMAKE_C_COMPILER_TARGET   ${triple})
set(CMAKE_ASM_COMPILER_TARGET ${triple})
set(CMAKE_CXX_COMPILER_TARGET ${triple})

if("${ARCH}" STREQUAL "posix")
  set(TOOLCHAIN_HAS_NEWLIB OFF CACHE BOOL "True if toolchain supports newlib")
endif()

message(STATUS "Found toolchain: llir")
