#  mp3-cp2a.s version 1.0
.align 4
.section .text
.globl _start
_start:
    # Cache Line 0x03 - Set 3, Tag 0
    beq x0, x0, ldr_str_test                    # x060: I-cache Miss
    nop                                         # x064
    nop                                         # x068
    nop                                         # x06c
    nop                                         # x070
    nop                                         # x074
    nop                                         # x078
    nop                                         # x07c
    # Cache Line 0x04 - Set 4, Tag 0

ldr_str_test:
    add x8, x0, x0 # addi x8, x0, %lo(DataSeg)  # x080: I-cache Miss
    nop                                         # x084
    nop                                         # x088
    nop                                         # x08c
    nop                                         # x090
    nop                                         # x094
    lw x1, W # lw x1, %lo(W)(x8)                # x098: D-cache Miss
    lw x3, Y # lw x3, %lo(Y)(x8)                # x09c: D-cache Miss
    # Cache Line 0x05 - Set 5, Tag 0
    lw x2, X # lw x2, %lo(X)(x8)                # x0a0: I-cache Miss
    lw x4, Z # lw x4, %lo(Z)(x8)                # x0a4
    nop                                         # x0a8
    sw x1, Z, x8 # sw x1, %lo(Z)(x8)            # x0ac
    sw x2, Y, x8 # sw x2, %lo(Y)(x8)            # x0b0
    sw x3, X, x8 # sw x3, %lo(X)(x8)            # x0b4
    sw x4, W, x8 # sw x4, %lo(W)(x8)            # x0b8
    nop                                         # x0bc
    # Cache Line 0x06 - Set 6, Tag 0
    lw x1, W # lw x1, %lo(W)(x8)                # x0c0
    lw x2, X # lw x2, %lo(X)(x8)                # x0c4
    lw x3, Y # lw x3, %lo(Y)(x8)                # x0c8
    lw x4, Z # lw x4, %lo(Z)(x8)                # x0cc
    beq x0, x0, fetch_stall_test                # x0d0
    nop                                         # x0d4
    nop                                         # x0d8
    nop                                         # x0dc
    # Cache Line 0x07 - Set 7, Tag 0
    nop                                         # x0e0
    nop                                         # x0e4
    nop                                         # x0e8
    nop                                         # x0ec
    nop                                         # x0f0
    nop                                         # x0f4
    nop                                         # x0f8
    nop                                         # x0fc
    # Cache Line 0x08 - Set 0, Tag 1
    nop                                         # x100
    nop                                         # x104
    nop                                         # x108
    nop                                         # x10c
    nop                                         # x110
    nop                                         # x114
    nop                                         # x118
fetch_stall_test:
    add x5, x1, x2                              # x11c
    # Cache Line 0x09 - Set 1, Tag 1
    add x6, x3, x4                              # x120
    nop                                         # x124
    nop                                         # x128
    nop                                         # x12c
    nop                                         # x130
    sw x5, VICTIM, x8                           # x134
    add x7, x5, x6                              # x138
    nop                                         # x13c
    # Cache Line 0x0a - Set 2, Tag 1
    nop                                         # x140
    nop                                         # x144
    nop                                         # x148
    sw x7, TOTAL, x8                            # x14c
    lw x1, TOTAL                                # x150
inf:
    beq x0, x0, inf                             # x154
    nop                                         # x158
    nop                                         # x15c
    # Cache Line 0x0b - Set 3, Tag 1
    
.section .rodata
# Not sure what's going on here, but '.section .rodata' seems to pad a lot of
# zeros between the program and its data; 5 cache lines worth to be exact.
.balign 256
    # Cache line 0x10 - Set 0, Tag 2
DataSeg:
    nop                                         # x200
    nop                                         # x204
    nop                                         # x208
    nop                                         # x20c
    nop                                         # x210
    nop                                         # x214
W:  .word 0x00000009                            # x218
X:  .word 0x00000002                            # x21c
   # Cache Line 0x11 - Set 1, Tag 2

Y:  .word 0x00000001                            # x220
Z:  .word 0x00000003                            # x224
    nop                                         # x228
    nop                                         # x22c
    nop                                         # x230
    nop                                         # x234
    nop                                         # x238
    nop                                         # x23c
   # Cache Line 0x12 - Set 2, Tag 2

TOTAL:  .word 0x00000000                        # x240
    nop                                         # x244
    nop                                         # x248
    nop                                         # x24c
    nop                                         # x250
    nop                                         # x254
    nop                                         # x258
    nop                                         # x25c
   # Cache Line 0x13 - Set 3, Tag 2

VICTIM: .word 0x00000000                        # x260
    nop                                         # x264
    nop                                         # x268
    nop                                         # x26c
    nop                                         # x270
    nop                                         # x274
    nop                                         # x278
    nop                                         # x27c
