	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl $17
	popl %eax
	negl %eax
	pushl %eax
	popl %eax
	ret
