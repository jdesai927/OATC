	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl %edx
	pushl $27
	popl %eax
	popl %ecx
	imull %ecx, %eax
	pushl %eax
	popl %eax
	ret
