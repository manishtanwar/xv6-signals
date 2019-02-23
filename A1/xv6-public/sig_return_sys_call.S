#include "syscall.h"
#include "traps.h"

.globl sig_return_sys_call_start;
.globl sig_return_sys_call_end;

sig_return_sys_call_start:
	movl $SYS_sig_ret, %eax;
	int $T_SYSCALL;
	ret
sig_return_sys_call_end: