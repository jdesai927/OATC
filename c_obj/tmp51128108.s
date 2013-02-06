	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl %edx
	pushl %edx
	pushl %edx
	popl %eax
	popl %ecx
	imull %ecx, %eax
	pushl %eax
	popl %eax
	popl %ecx
	imull %ecx, %eax
	pushl %eax
	popl %eax
	ret
