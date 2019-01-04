arith_test.s:
.align 4
.section .text
.globl _start
_start:

    addi        x11, x0, 5
    addi        x12, x0, 3
    sub         x1, x11, x12        # X1 <- X11 - X12 = 5 - 3 = 2

    addi        x11, x0, -5
    addi        x12, x0, 5
    slt         x2, x11, x12        # X2 <- X11 < x12 = True = 1
    sltu        x3, x11, x12        # X3 <- signed(X11 < X12) = False = 0

    lw          x11, data
    addi        x12, x0, 2
    srl         x4, x11, x12        # X4 <- (Logical) X11 >> X12 = 0x20002000
    sra         x5, x11, x12        # X5 <- (Arithmetic) X11 >> X12 = 0xE0002000

goodend:
    j           goodend

.section .rodata

bad:        .word 0xdeadbeef
data:       .word 0x80008000
good:       .word 0x600d600d
