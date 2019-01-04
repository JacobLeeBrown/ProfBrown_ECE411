cp1_test1.s:
.align 4
.section .text
.globl _start

    # This test code is for checking that all instructions required for mp3 cp1
    # are functioning appropriately.
    # NOTE: For this test to work, cp1_test1.s needs to be working (loads and
    # stores).

_start:

    # I'm gonna put "WARNING - 2 inst" next to any single instruction that gets
    # interpretted into 2 (this could be potentially bad for a non-working
    # pipeline since there will be no nops between the 2 instructions)

    lui     x1, 0x01        # x060: X1 <- 0x00001000
    nop                     # x064
    nop                     # x068
    nop                     # x06C
    nop                     # x070

    auipc   x2, 0x02        # x074: X2 <- 0x00002078
    nop                     # x078
    nop                     # x07C
    nop                     # x080
    nop                     # x084

    # WARNING - 2 inst
    lw      x3, const1      # x088: X3 <- 1
    nop                     # x08C
    nop                     # x090
    nop                     # x094
    nop                     # x098
    addi    x3, x3, 2       # x09C: X3 <- X3 + 2 = 3 = 0x00000003
    nop                     # x0A0
    nop                     # x0A4
    nop                     # x0A8
    nop                     # x0AC

    # WARNING - 2 inst
    lw      x4, const3      # x0B0: X4 <- 3
    nop                     # x0B4
    nop                     # x0B8
    nop                     # x0BC
    nop                     # x0C0
    xori    x4, x4, 7       # x0C4: X4 <- X4 XOR 7 = 0x00000004 
    nop                     # x0C8
    nop                     # x0CC
    nop                     # x0D0
    nop                     # x0D4

    # WARNING - 2 inst
    lw      x5, const4      # x0D8: X5 <- 4
    nop                     # x0DC
    nop                     # x0E0
    nop                     # x0E4
    nop                     # x0E8
    ori     x5, x5, 1       # x0EC: X5 <- X5 OR 1 = 0x00000005
    nop                     # x0F0
    nop                     # x0F4
    nop                     # x0F8
    nop                     # x0FC

    # WARNING - 2 inst
    lw      x6, const7      # x100: X6 <- 7
    nop                     # x104
    nop                     # x108
    nop                     # x10C
    nop                     # x110
    andi    x6, x6, 14      # x114: X6 <- X6 AND 14 = 0x00000006 
    nop                     # x118
    nop                     # x11C
    nop                     # x120
    nop                     # x124


inf:
    jal x0, inf

.section .rodata

data1:      .word 0x11111111
data2:      .word 0x22222222
data3:      .word 0x33333333
data4:      .word 0x44444444

const1:     .word 0x00000001
const2:     .word 0x00000002
const3:     .word 0x00000003
const4:     .word 0x00000004
const5:     .word 0x00000005
const6:     .word 0x00000006
const7:     .word 0x00000007
const8:     .word 0x00000008
