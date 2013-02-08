	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl $4
	pushl %edx
	popl %eax
	popl %ecx
	cmpl %ecx, %eax
	setGE %al
	andl $1, %eax
	pushl %eax
	popl %eax
	ret
