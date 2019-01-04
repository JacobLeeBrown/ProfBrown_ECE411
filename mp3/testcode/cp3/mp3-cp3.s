#  mp3-cp3.s version 1.0
.align 4
.section .text
.globl _start
_start:

# From the MP3 doc:
#   By checkpoint 3, your pipeline should be able to do hazard detection and forwarding.
#   Note that you should not stall or forward for dependencies on register x0 or when an
#   instruction does not use one of the source registers (such as rs2 for immediate instructions). 
#   Furthermore, your L2 cache should be completed and integrated into your cache hierarchy.

# Mispredict taken branch flushing tests
taken_branches:
    beq     x0, x0, forward_br      # x060: Goes to x074
    lw      x7, BAD                 # Shouldn't execute

backward_br:
    beq     x0, x0, not_taken_branches # 0x06c: Goes to x080
    beq     x0, x0, oof             # Also, test back-to-back branches

forward_br:
    beq     x0, x0, backward_br     # x074: Goes to x06c
    lw      x7, BAD                 # Shouldn't execute

# Mispredict not-taken branch flushing tests
not_taken_branches:
    add     x1, x0, 1               # Also, test branching on forwarded value :)
                                    # x080: X1 <- 1
    beq     x0, x1, oof             # x084: Don't take

    beq     x0, x0, backward_br_nt  # x088: Take - Goes to 0x13c


forwarding_tests:
    # Forwarding x0 test
    add     x3, x3, 1               # x08c: X3 <- X3 + 1? Could be garbage
    add     x0, x1, 0               # x090: Nop - But x0 dependency with x094
    add     x2, x0, 0               # x094: X2 <- 0

    beq     x2, x3, oof             # x098

    # Forwarding sr2 imm test
    add     x2, x1, 0               # x09c
    add     x3, x1, 2               # x0a0: 2 immediate makes sr2 bits point to x2
    add     x4, x0, 3               # x0a4
    
    # Test branching on 2 forwarded values :)
    bne x3, x4, oof                 # x0a8 

    # MEM -> EX forwarding with stall
    lw x1, NOPE                     # x0ac: 2 Instructions
    lw x1, A                        # x0b4: 2 Instructions
    add x5, x1, x0                  # Necessary forwarding stall

    bne x5, x1, oof

    # WB -> MEM forwarding test
    add x3, x1, 1 #2
    la x8, TEST
    sw  x3, 0(x8)
    lw  x4, TEST

    bne x4, x3, oof


    # Half word forwarding test
    lh  x2, FULL
    add x3, x0, -1

    bne x3, x2, oof

    # Cache miss control test
    add x4, x0, 3
    lw  x2, B       # Cache miss
    add x3, x2, 1   # Try to forward from cache miss load

    bne x4, x3, oof

    # Forwarding contention test
    add x2, x0, 1
    add x2, x0, 2
    add x3, x2, 1

    beq x3, x2, oof

    lw x7, GOOD

halt:
    beq x0, x0, halt
    lw x7, BAD

oof:
    lw x7, BAD                      # x128: 2 Instructions
    lw x2, PAY_RESPECTS             # x130: 2 Instructions
    beq x0, x0, halt                # x138: Goes to x11c

backward_br_nt:
    beq x0, x1, oof                 # x13c: Don't take

    beq x0, x0, forwarding_tests    # x140: Take - Goes to x08c



.section .rodata
.balign 256
DataSeg:
    nop
    nop
    nop
    nop
    nop
    nop
BAD:            .word 0x00BADBAD
PAY_RESPECTS:   .word 0xFFFFFFFF
   # cache line boundary - this cache line should never be loaded

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
