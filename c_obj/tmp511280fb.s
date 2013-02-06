	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl $27
	pushl %edx
	popl %eax
	popl %ecx
	imull %ecx, %eax
	pushl %eax
	popl %eax
	ret
