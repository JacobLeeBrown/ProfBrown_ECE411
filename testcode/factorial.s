factorial.s:
.align 4
.section .text
.globl _start
    # This program calculates the factorial of the value given via .word at the
    # bottom of this file.

    # -- Registers
    # X1 = Stores factorial value
    # X2 = Current sum for multiply loop (loop2)
    #    = **Will hold result of program upon completion**
    # X3 = Current multiply count 
    #    = How many times loop2 occurs for current loop1
    # X4 = Multiply loop counter
    # X5 = Current increment amount
    #    = The value being multiplied in loop2
    #
    # In other words, say we're trying to compute A! for some input A. Firstly,
    # that value would have to be stored at the `value` label for this program
    # to properly execute.
    #
    # Loop2 is performing the operation B*C=D, where B is the current increment
    # value (X5), C is the number of times we need to multiply that value, 
    # i.e. the multiply count, X3, and D is the result, which gets put into X2. 
    # X4 is simply the counter that will be decremented C times until it 
    # contains the value 0, at which point the program checks if C = A.
    #
    # If so, the last iteration of multiplication occurred, so the program 
    # halts. If not, then the program resets the necessary values so the next
    # multiplication loop can execute. This is done by updating B to D (X5 <= 
    # X2), incrementing C (X3 <= X3 + 1), and resetting the counter to the new
    # multiply count (X4 <= X3).

_start:

    lw      x1, value       # X1 <= x05 (factorial value)
    lw      x2, zero        # X2 <= 0 (clear)
    lw      x3, one         # X3 <= 1
    lw      x4, zero        # X4 <= 0 (clear)
    lw      x5, one         # X5 <= 1
    beq     x1, x3, fact1   # If input is 1, special case
    addi    x3, x3, 1       # X3 <= X3 + 1

loop1:                      # Setup for next multiply loop

    addi    x4, x3, 0       # X4 <= X3
    lw      x2, zero        # X2 <= 0 (clear)

loop2:                      # Multiply loop

    add     x2, x2, x5      # X2 <= X2 + X5
    addi    x4, x4, -1      # X4 <= X4 - 1, decrement multiply loop counter
    bne     x4, x0, loop2   # If the multiply counter is not 0, keep multiplying

    beq     x1, x3, halt    # If the current multiply count equals the
                            # factorial value, then we're done!

    addi    x5, x2, 0       # X5 <= X2, update increment amount
    addi    x3, x3, 1       # X3 <= X3 + 1, update multiply count
    beq     x0, x0, loop1   # Setup for the next multiply loop

fact1:                      # Result is simply 1 in this case
    lw      x2, one         # X2 <= 1

halt:                       # Infinite loop to keep the processor
    beq     x0, x0, halt    # from trying to execute the data below.

value:      .word 0x00000005
zero:       .word 0x00000000
one:        .word 0x00000001
