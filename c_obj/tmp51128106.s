	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl %edx
	pushl $341
	popl %eax
	popl %ecx
	shrl %cl, %eax
	pushl %eax
	popl %eax
	ret
