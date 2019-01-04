.align 4
.section .text
.globl _start
_start:

    nop
    addi x1, x1, 0x69
    nop
    nop
    nop
    nop
    nop
    li x13, 0xdddddd00 # prefix for all mem locations
    lw x1, 0x0(x13)
    nop
    nop
    nop
    nop
    lw x2, 0x1(x13)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lw x3, 0x2(x13)
    lw x4, 0x3(x13)
    lw x5, 0x4(x13)
    lw x6, 0x5(x13)
    lw x7, 0x6(x13)
    lw x8, 0x7(x13)
    lw x9, 0x8(x13)
    lw x10, 0x9(x13)
    lw x11, 0xa(x13)
    lw x12, 0xb(x13)
    add x13, x0, 13
    nop
    nop
    nop
    nop
    nop


halt:
    beq x0, x0, halt

.section .rodata
.balign 256
A:      .word 0x00000001
GOOD:   .word 0x600D600D
NOPE:   .word 0x00BADBAD
TEST:   .word 0x00000000
FULL:   .word 0xFFFFFFFF
    nop
    nop
    nop
   # cache line boundary

B:      .word 0x00000002
    nop
    nop
    nop
    nop
    nop
    nop
    nop
   # cache line boundary

C:      .word 0x00000003
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    # cache line boundary

D:      .word 0x00000004
    nop
    nop
    nop
    nop
    nop
    nop
    nop
