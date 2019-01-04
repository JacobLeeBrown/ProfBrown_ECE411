.align 4
.section .text
.globl _start
_start:

	add		x1, x0, -2
	add		x2, x1, 1
	add 	x3, x0, 0
	add		x4, x0, 0


LOOP1:
	# Test Incorrect Predict (& Flushing)
	add		x1, x1, 1
	blt 	x1, x0, LOOP1

	add 	x3, x3, 1
	add		x4, x4, 2

	nop
	nop
	nop
	nop
	nop

	# CHECK TIME
	# x1 = 0
	# x2 = -1
	# x3 = 1
	# x4 = 2

	add		x1, x0, 0
	add		x2, x0, 5
	add 	x3, x0, 3
	add 	x4, x0, 0
	add		x5,	x0, 0

LOOP2:
	# Test Correct Predict
	add 	x4, x4, 1
	bne 	x1, x0, LOOP2

	add 	x5, x5, 15
	add		x2, x2, 1

	nop
	nop
	nop
	nop
	nop

	# CHECK TIME
	# x1 = 0
	# x2 = 6
	# x3 = 3
	# x4 = 1
	# x5 = 15

LOOP3:
	# Branches Next to Branches
	bne		x0, x0, BAD	
	beq		x0, x0, INF
	bne		x0, x0, BAD

INF:
    beq     x0, x0, INF 

BAD:
	add		x1, x0, -1

HELP:
	beq 	x0, x0, HELP
