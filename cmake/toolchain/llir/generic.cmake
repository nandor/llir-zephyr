# SPDX-License-Identifier: Apache-2.0


set_ifndef(LLIR_TRIPLE "$ENV{LLIR_TRIPLE}")
set_ifndef(LLIR_TRIPLE "llir_x86_64-unknown-unknown")

set(LLVM_TOOLCHAIN_PATH $ENV{HOME}/Projects/llir/dist/)
set(TOOLCHAIN_HOME $ENV{HOME}/Projects/llir/dist/bin/)

set(COMPILER llir)
set(LINKER llir)
set(BINTOOLS llir)

set(CMAKE_C_COMPILER_TARGET   ${LLIR_TRIPLE})
set(CMAKE_ASM_COMPILER_TARGET ${LLIR_TRIPLE})
set(CMAKE_CXX_COMPILER_TARGET ${LLIR_TRIPLE})

if("${ARCH}" STREQUAL "posix")
  set(TOOLCHAIN_HAS_NEWLIB OFF CACHE BOOL "True if toolchain supports newlib")
endif()

message(STATUS "Found toolchain: llir")
