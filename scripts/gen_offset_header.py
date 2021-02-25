#!/usr/bin/env python3
#
# Copyright (c) 2017 Intel Corporation.
#
# SPDX-License-Identifier: Apache-2.0
#

"""
This script scans a specified object file and generates a header file
that defined macros for the offsets of various found structure members
(particularly symbols ending with ``_OFFSET`` or ``_SIZEOF``), primarily
intended for use in assembly code.
"""

from elftools.elf.elffile import ELFFile
from elftools.elf.sections import SymbolTableSection
import argparse
import sys
import subprocess


def get_symbol_table(obj):
    for section in obj.iter_sections():
        if isinstance(section, SymbolTableSection):
            return section

    raise LookupError("Could not find symbol table")


def gen_elf_offset_header(input_name, input_file, output_file):
    include_guard = "__GEN_OFFSETS_H__"
    output_file.write("""/* THIS FILE IS AUTO GENERATED.  PLEASE DO NOT EDIT.
 *
 * This header file provides macros for the offsets of various structure
 * members.  These offset macros are primarily intended to be used in
 * assembly code.
 */

#ifndef %s
#define %s\n\n""" % (include_guard, include_guard))

    obj = ELFFile(input_file)
    for sym in get_symbol_table(obj).iter_symbols():
        if isinstance(sym.name, bytes):
            sym.name = str(sym.name, 'ascii')

        if not sym.name.endswith(('_OFFSET', '_SIZEOF')):
            continue
        if sym.entry['st_shndx'] != 'SHN_ABS':
            continue
        if sym.entry['st_info']['bind'] != 'STB_GLOBAL':
            continue

        output_file.write(
            "#define %s 0x%x\n" %
            (sym.name, sym.entry['st_value']))

    output_file.write("\n#endif /* %s */\n" % include_guard)

    return 0


def gen_llir_offset_header(input_name, input_file, output_file):
    include_guard = "__GEN_OFFSETS_H__"
    output_file.write("""/* THIS FILE IS AUTO GENERATED.  PLEASE DO NOT EDIT.
 *
 * This header file provides macros for the offsets of various structure
 * members.  These offset macros are primarily intended to be used in
 * assembly code.
 */

#ifndef %s
#define %s\n\n""" % (include_guard, include_guard))

    source = subprocess.check_output(['llir-dump', input_name, '-o', '-'])
    data = source.split(b'.section\t.data')[1].decode('utf-8')
    for chunk in data.split('.end'):
        lines = [l for l in chunk.strip().split('\n') if l]
        if not lines: continue
        name = [l for l in lines if l.endswith(':')][0].split(':')[0]
        length = int(lines[-1].split('.long')[1])
        output_file.write("#define %s 0x%x\n" % (name, length))
    output_file.write("\n#endif /* %s */\n" % include_guard)
    return 0


def is_llir(f):
    pos = f.tell()
    data = f.read(4)
    f.seek(pos)
    return data == b'LLIR'


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument(
        "-i",
        "--input",
        required=True,
        help="Input object file")
    parser.add_argument(
        "-o",
        "--output",
        required=True,
        help="Output header file")

    args = parser.parse_args()

    input_file = open(args.input, 'rb')
    output_file = open(args.output, 'w')

    if is_llir(input_file):
        ret = gen_llir_offset_header(args.input, input_file, output_file)
    else:
        ret = gen_elf_offset_header(args.input, input_file, output_file)
    sys.exit(ret)
