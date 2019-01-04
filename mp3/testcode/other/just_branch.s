.align 4
.section .text
.globl _start
_start:

	add 	x1, x0, 100

LOOP:
	add 	x1, x1, -1
	bne 	x1, x0, LOOP


INF:
    beq     x0, x0, INF     # x09c: Halt