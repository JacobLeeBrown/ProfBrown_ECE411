mp1_cp.s:
.align 4
.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    # Note that the comments in this file should not be taken as
    # an example of good commenting style!!  They are merely provided
    # in an effort to help you understand the assembly style.

    # Note that one/two/eight are data labels
    lw      x1, LVAL1       # X1  <- x20
    lw      x2, LVAL2       # X2  <- xD5
    lw      x3, LVAL3       # X3  <- x0F

    add     x4, x1, x3      # X4  <- X1 + X3 = x2F
    addi    x6, x0, 4       # X6  <- X0 + 4 = x04
    add     x3, x4, x6      # X3  <- X4 + X6 = x33
    la      x10, SVAL1      # X10 <- [SVAL1]
    sw      x3, 0(x10)      # [SVAL1 + 0] <- X3 = x33

    addi    x6, x0, -10     # X6  <- -10
    add     x4, x4, x6      # X4  <- x2F - 10 = x25
    la      x10, SVAL2      # X10 <- [SVAL2]
    sw      x4, 0(x10)      # [SVAL2 + 0] <- X4 = x25

    addi    x6, x0, -13     # X6  <- -13
    and     x5, x2, x6      # X5  <- X2 AND X6 = xD5 AND -13 = xD1
    la      x10, SVAL3      # X10 <- [SVAL3]
    sw      x5, 0(x10)      # [SVAL3 + 0] <- X5 = xD1

    addi    x6, x0, 12      # X6  <- 12
    and     x6, x2, x6      # X6  <- X2 AND X6 = xD5 AND 12 = x04
    or      x6, x6, x0      # X6  <- X6 OR X0 = x04
    la      x10, SVAL4      # X10 <- [SVAL4]
    sw      x6, 0(x10)      # [SVAL4 + 0] <- X6 = x04

    lw      x8, LVAL4       # X8  <- xF0F
    lw      x9, LVAL5       # X9  <- x0FF
    lw      x10, LVAL6      # X10 <- x004
    xor     x11, x8, x9     # X11 <- X8 XOR X9 = xF0F XOR x0FF = xFF0
    la      x12, SVAL5      # X12 <- [SVAL5]
    sw      x11, 0(x12)     # [SVAL5 + 0] <- X11 = xFF0

    sll     x11, x9, x10    # X11 <- X9 << X10 = X9 << 4 = xFF0
    la      x12, SVAL6      # X12 <- [SVAL6]
    sw      x11, 0(x12)     # [SVAL6 + 0] <- X11 = xFF0

    srl     x11, x9, x10    # X11 <- X9 >> X10 = X9 >> 4 = x00F
    la      x12, SVAL7      # X12 <- [SVAL7]
    sw      x11, 0(x12)     # [SVAL7 + 0] <- X11 = x00F

    addi    x6, x0, 12      # X6  <- 12
    or      x6, x2, x6      # X6  <- X2 OR X6 = xD5 OR 12 = xDD
    la      x10, SVAL8      # X10 <- [SVAL8]
    sw      x6, 0(x10)      # [SVAL8 + 0] <- X6 = xDD
    
    lw      x1, SVAL1       # X1  <- x33
    lw      x2, SVAL2       # X2  <- x25
    lw      x3, SVAL3       # X3  <- xD1
    lw      x4, SVAL4       # X4  <- x04
    lw      x8, SVAL5       # X8  <- xFF0
    lw      x9, SVAL6       # X9  <- xFF0
    lw      x10, SVAL7      # X10 <- x00F
    lw      x11, SVAL8      # X11 <- xDD

    jal     x7, there       # X7 <- PC + 4 (return address)
                            # PC <- [there]
goodend:
    j    goodend            # X0 <- PC + 4 (X0 is read-only, this is nop)
                            # PC <- goodend --> Infinite Loop 

there:	
    lw   x6, good           # X6 <- x600d600d
    jalr x0, x7, 0          # X0 <- PC + 4 (X0 is read-only, this is nop)
                            # PC <- X7 + 0 = goodend
    lw   x6, bad            # X6 <- xdeadbeef
    
badend:
    j    badend

.section .rodata

bad:        .word 0xdeadbeef
LVAL1:	    .word 0x00000020
LVAL2:	    .word 0x000000D5
LVAL3:	    .word 0x0000000F
LVAL4:	    .word 0x00000F0F
LVAL5:	    .word 0x000000FF
LVAL6:	    .word 0x00000004
SVAL1:	    .word 0x00000000
SVAL2:	    .word 0x00000000
SVAL3:	    .word 0x00000000
SVAL4:	    .word 0x00000000
SVAL5:	    .word 0x00000000
SVAL6:	    .word 0x00000000
SVAL7:	    .word 0x00000000
SVAL8:      .word 0x00000000
good:       .word 0x600d600d
