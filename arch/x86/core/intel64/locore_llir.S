/*
 * Copyright (c) 2019 Intel Corporation
 * SPDX-License-Identifier: Apache-2.0
 */

#include <toolchain.h>
#include <arch/x86/multiboot.h>
#include <sys/util.h>
#include <arch/x86/msr.h>
#include <kernel_arch_data.h>
#include <offsets_short.h>
#include <drivers/interrupt_controller/loapic.h>
#include <arch/cpu.h>
#include <sys/mem_manage.h>

/*
 * Definitions/macros for enabling paging
 */

/* Long mode, no-execute, syscall */
#define EFER_BITS (X86_EFER_MSR_LME | X86_EFER_MSR_NXE | X86_EFER_MSR_SCE)

/* Paging, write-protect */
#define CR0_BITS (CR0_PG | CR0_WP)

/* PAE, SSE */
#define CR4_BITS (CR4_PAE | CR4_OSFXSR)

  .section .text
__start:
  .subtarget "i686"
  lgdt gdt48
  lidt idt48

#include <arch/x86/multiboot.h>

#ifdef CONFIG_MULTIBOOT_INFO
#error "not implemented"
#endif

#ifdef CONFIG_BOOT_TIME_MEASUREMENT
#error "not implemented"
#endif

#ifdef CONFIG_PIC_DISABLE
  mov.i8  $1000,  0xFF
  mov.i16 $1001, 0x21
  x86_out $1001, $1000
  mov.i16 $1002, 0xA1
  x86_out $1001, $1000
#endif

#ifdef CONFIG_MULTIBOOT
  #error "not implemented"

  #ifdef CONFIG_MULTIBOOT_FRAMEBUF
  #error "not implemented"
  #endif /* CONFIG_MULTIBOOT_FRAMEBUF */

#endif

  trap
  .end

