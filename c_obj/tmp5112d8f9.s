	.align 4
	.text
.globl program
program:
	movl 4(%esp), %edx
	pushl $42
	pushl $17
	pushl %edx
	popl %eax
	popl %ecx
	andl %ecx, %eax
	pushl %eax
	popl %eax
	popl %ecx
	orl %ecx, %eax
	pushl %eax
	popl %eax
	ret
