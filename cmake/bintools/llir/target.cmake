# SPDX-License-Identifier: Apache-2.0

# Configures binary tools as GNU binutils

find_program(CMAKE_OBJCOPY ${LLIR_PREFIX}objcopy PATHS ${TOOLCHAIN_HOME} NO_DEFAULT_PATH)
find_program(CMAKE_OBJDUMP ${LLIR_PREFIX}objdump PATHS ${TOOLCHAIN_HOME} NO_DEFAULT_PATH)
find_program(CMAKE_AS      ${LLIR_PREFIX}as      PATHS ${TOOLCHAIN_HOME} NO_DEFAULT_PATH)
find_program(CMAKE_AR      ${LLIR_PREFIX}ar      PATHS ${TOOLCHAIN_HOME} NO_DEFAULT_PATH)
find_program(CMAKE_RANLIB  ${LLIR_PREFIX}ranlib  PATHS ${TOOLCHAIN_HOME} NO_DEFAULT_PATH)
find_program(CMAKE_READELF ${LLIR_PREFIX}readelf PATHS ${TOOLCHAIN_HOME} NO_DEFAULT_PATH)
find_program(CMAKE_NM      ${LLIR_PREFIX}nm      PATHS ${TOOLCHAIN_HOME} NO_DEFAULT_PATH)
find_program(CMAKE_STRIP   ${LLIR_PREFIX}strip   PATHS ${TOOLCHAIN_HOME} NO_DEFAULT_PATH)

