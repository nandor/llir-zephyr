/*
 * Copyright (c) 2011-2015 Wind River Systems, Inc.
 * SPDX-License-Identifier: Apache-2.0
 */

#include <zephyr.h>
#include <tracing/tracing.h>
#include <arch/cpu.h>

void arch_cpu_idle(void)
{
	sys_trace_idle();
#ifdef __llir__
	__asm__ volatile ("x86_sti\n\tx86_hlt\n\t");
#else
	__asm__ volatile ("sti\n\thlt\n\t");
#endif
}

void arch_cpu_atomic_idle(unsigned int key)
{
	sys_trace_idle();

  /*
   * The following statement appears in "Intel 64 and IA-32
   * Architectures Software Developer's Manual", regarding the 'sti'
   * instruction:
   *
   * "After the IF flag is set, the processor begins responding to
   *    external, maskable interrupts after the next instruction is
   *    executed."
   *
   * Thus the IA-32 implementation of arch_cpu_atomic_idle() will
   * atomically re-enable interrupts and enter a low-power mode.
   */
#ifdef __llir__
	__asm__ volatile ("x86_sti\n\tx86_hlt\n\t");
#else
	__asm__ volatile ("sti\n\thlt\n\t");
#endif

	/* restore interrupt lockout state before returning to caller */
	if ((key & 0x200U) == 0U) {
#ifdef __llir__
		__asm__ volatile("x86_cli");
#else
		__asm__ volatile("cli");
#endif
	}
}
