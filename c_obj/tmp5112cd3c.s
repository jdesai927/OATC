	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl %edx
	pushl %edx
	popl %eax
	popl %ecx
	cmpl %ecx, %eax
	setNE %al
	andl $1, %eax
	pushl %eax
	popl %eax
	ret
