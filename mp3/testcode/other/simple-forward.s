.align 4
.section .text
.globl _start
_start:
	add x1, x0, 1
	add x2, x1, x1
	add x3, x2, x1
	

halt:
	beq x0, x0, halt

