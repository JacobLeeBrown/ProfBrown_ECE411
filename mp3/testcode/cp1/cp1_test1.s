cp1_test1.s:
.align 4
.section .text
.globl _start

    # Simple testcode to check that loads and stores are working for our
    # pipeline implementation.

_start:

    # I'm gonna put "WARNING - 2 inst" next to any single instruction that gets
    # interpretted into 2 (this could be potentially bad for a non-working
    # pipeline since there will be no nops between the 2 instructions)

    # WARNING - 2 inst
    lw      x1, data11      # X1 <- 0x11111111
    nop
    nop
    nop
    nop

    # WARNING - 2 inst
    la      x2, data12      # X2 <- [data12]
    nop
    nop
    nop
    nop
    sw      x1, 0(x2)       # M[data12] <- 0x11111111
    nop
    nop
    nop
    nop
    # WARNING - 2 inst
    lw      x2, data12      # X2 <- 0x11111111
    nop
    nop
    nop
    nop

inf:
    jal x0, inf

.section .rodata

data11:      .word 0x11111111
data12:      .word 0x00000000