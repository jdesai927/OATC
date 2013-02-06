	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl $1
	pushl %edx
	popl %eax
	popl %ecx
	addl %ecx, %eax
	pushl %eax
	popl %eax
	ret
