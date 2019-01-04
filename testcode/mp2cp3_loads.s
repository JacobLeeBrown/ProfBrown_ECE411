mp2cp3_loads.s:
.align 4
.section .text
.globl _start
_start:

    # This file is meant to test *only* that all types of loads work as expected
    # with the implementation of a 2-way associative cache, not that the
    # expected lines are stored within the cache.

    # Comment Style =   Register <- Expected Value
    #    Note: This program is designed such that all regs used are assigned
    #          once and only once (thus the assigned values should be final).

    # Loading the base addresses
    la      x1, d00         # X1 <- [d00]
    la      x2, d10         # X2 <- [d10]
    la      x3, d20         # X3 <- [d20]

    # Testing 4B aligned 4B accesses
    lw      x4, 16(x1)      # X4 <- x44444444
    lw      x5, 20(x1)      # X5 <- x55555555

    # Testing 2B aligned 2B accesses
    lh      x6,  12(x2)     # X6  <- x00006666
    lh      x7,  14(x2)     # X7  <- x00007777
    lh      x8,  16(x2)     # X8  <- xffff8888
    lh      x9,  18(x2)     # X9  <- xffff9999
    lhu     x10, 16(x2)     # X10 <- x00008888
    lhu     x11, 18(x2)     # X11 <- x00009999

    # Testing 1B aligned 1B accesses
    lb      x12, 0(x3)      # X12 <- x00000010
    lb      x13, 1(x3)      # X13 <- x00000032
    lb      x14, 2(x3)      # X14 <- x00000054
    lb      x15, 3(x3)      # X15 <- x00000076
    lb      x16, 4(x3)      # X16 <- xffffff98
    lb      x17, 5(x3)      # X17 <- xffffffba
    lb      x18, 6(x3)      # X18 <- xffffffdc
    lb      x19, 7(x3)      # X19 <- xfffffffe
    lbu     x20, 4(x3)      # X20 <- x00000098
    lbu     x21, 5(x3)      # X21 <- x000000ba
    lbu     x22, 6(x3)      # X22 <- x000000dc
    lbu     x23, 7(x3)      # X23 <- x000000fe

goodend:
    j    goodend

.section .rodata
.balign 256
.zero 96

d00: .word 0x00000000
d01: .word 0x11111111
d02: .word 0x22222222
d03: .word 0x33333333
d04: .word 0x44444444
d05: .word 0x55555555
d06: .word 0x66666666
d07: .word 0x77777777

d10: .word 0x11110000
d11: .word 0x33332222
d12: .word 0x55554444
d13: .word 0x77776666
d14: .word 0x99998888
d15: .word 0xbbbbaaaa
d16: .word 0xddddcccc
d17: .word 0xffffeeee

d20: .word 0x76543210
d21: .word 0xfedcba98
d22: .word 0x76543210
d23: .word 0xfedcba98
d24: .word 0x76543210
d25: .word 0xfedcba98
d26: .word 0x76543210
d27: .word 0xfedcba98
