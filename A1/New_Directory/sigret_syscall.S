#include "syscall.h"
#include "traps.h"

.globl execute_sigret_syscall_start;
.globl execute_sigret_syscall_end;

execute_sigret_syscall_start:
	movl $SYS_sig_ret, %eax;
	int $T_SYSCALL;
	ret
execute_sigret_syscall_end: