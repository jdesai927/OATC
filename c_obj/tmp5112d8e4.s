	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl %edx
	popl %eax
	cmpl $0, %eax
	setE %al
	andl $1, %eax
	pushl %eax
	pushl $17
	popl %eax
	popl %ecx
	orl %ecx, %eax
	pushl %eax
	popl %eax
	ret
