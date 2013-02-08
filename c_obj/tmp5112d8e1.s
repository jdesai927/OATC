	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl %edx
	pushl $17
	popl %eax
	popl %ecx
	andl %ecx, %eax
	pushl %eax
	popl %eax
	ret
