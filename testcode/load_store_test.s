load_store_test.s:
.align 4
.section .text
.globl _start
_start:

    lb      x1, data        # X1 <- xFFFFFF80
    lh      x2, data        # X2 <- xFFFF8080
    lw      x3, data        # X3 <- x80008080
    lbu     x4, data        # X4 <- x00000080
    lhu     x5, data        # X5 <- x00008080

    la      x10, SBVAL      # X10 <- [SBVAL]
    sb      x3, 0(x10)      # [SBVAL + 0] <- x00000080
    sh      x3, 4(x10)      # [SBVAL + 4] <- x00008080
    sw      x3, 8(x10)      # [SBVAL + 8] <- x80008080

    lw      x7, SBVAL       # X7 <- x00000080
    lw      x8, SHVAL       # X8 <- x00008080
    lw      x9, SWVAL       # X9 <- x80008080

goodend:
    j    goodend

.section .rodata

data:       .word 0x80008080
SBVAL:      .word 0x00000000
SHVAL:      .word 0x00000000
SWVAL:      .word 0x00000000
