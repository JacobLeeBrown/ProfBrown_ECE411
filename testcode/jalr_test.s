jalr_test.s:
.align 4
.section .text
.globl _start
_start:

    jal     x7, test1       # x60: X7 <- PC + 4, PC <- [test1]
    jal     x7, test2       # x64: X7 <- PC + 4, PC <- [test2]
    jal     x7, test3       # x68: X7 <- PC + 4, PC <- [test3]

    lw      x6, bad         # x6C: Should get skipped
    beq     x0, x0, badend  # x70: Should get skipped

    jal     x7, test4       # x74: X7 <- PC + 4, PC <- [test4]

test1:
    addi x1, x0, 1          # x78: X1 <- 1
    jalr x8, x7, 0          # x7C: X8 <- PC + 4, PC <- X7 + 0

test2:
    addi x2, x0, 2          # x80: X2 <- 2
    jalr x9, x7, 1          # x84: X9 <- PC + 4, PC <- X7 + 1
                                # X7 + 1 should get masked out to be just X7
                                # If this works, we should go back correctly
                                # If not, program should break since PC will
                                # point to an address that is not 4B alligned

test3:
    addi x3, x0, 3          # x88: X3 <- 3
    jalr x10, x7, 12         # x8C: X10 <- PC + 4, PC <- X7 + 12
                                # We're gonna try to skip 2 instructions here
                                # It's 12 and not 8 because this assembly gets
                                # expanded. In particular, the two instructions
                                # I try to skip get expanded to 3 total... lame.
   
test4:
    addi x4, x0, 4          # x90: X4 <- 4
    lw      x6, good        # x94: X6 <- x600d600d
    beq     x0, x0, goodend # x98: Unconditional branch to goodend

badend:
    j    badend             # x9C

goodend:
    j    goodend            # xA0

.section .rodata

bad:        .word 0xdeadbeef
good:       .word 0x600d600d
