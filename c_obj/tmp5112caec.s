	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl %edx
	popl %eax
	notl %eax
	pushl %eax
	popl %eax
	ret
