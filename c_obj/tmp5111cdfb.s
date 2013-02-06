	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl $341
	popl %eax
	ret
