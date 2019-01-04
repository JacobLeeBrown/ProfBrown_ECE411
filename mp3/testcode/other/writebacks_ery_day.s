writebacks_ery_day.s:
.align 4
.section .text
.globl _start
_start:

    # This testcode is meant to stress a Victim Cache of 8 entries placed
    # between a unified L2 cache and physical memory... which means we have to 
    # induce a metric fuckton of writebacks... buckle up.

    # Comment types:
        #  Byte No. in Pmem (hex): Notes
        #  (L = Line, S = Set, T = Tag)

# (L = x03, S = 3, T = x00)
# I (S=3,T=0,W=0), L2 (S=3,T=0,W=0)
    lw      x1,     DATA        # x060: Load X1 with data that will dirty lines
# D (S=3,T=2,W=0), L2 (S=3,T=2,W=2)
    addi    x20, x0, 5          # x068: X20 <- 5, will be our loop counter
    nop                         # x06c: Nice address padding for la's

    la      x2,     t2_s0_0     # x070: Load X2  with address of tag x02, set 0
    la      x3,     t3_s0_0     # x078: Load X3  with address of tag x03, set 0
# (L = x04, S = 4, T = x00)
# I (S=4,T=0,W=0), L2 (S=4,T=0,W=0)
    la      x4,     t4_s0_0     # x080: Load X4  with address of tag x04, set 0
    la      x5,     t5_s0_0     # x088: Load X5  with address of tag x05, set 0
    la      x6,     t6_s0_0     # x090: Load X6  with address of tag x06, set 0
    la      x7,     t7_s0_0     # x098: Load X7  with address of tag x07, set 0
# (L = x05, S = 5, T = x00)
# I (S=5,T=0,W=0), L2 (S=5,T=0,W=0)
    la      x8,     t8_s0_0     # x0a0: Load X8  with address of tag x08, set 0
    la      x9,     t9_s0_0     # x0a8: Load X9  with address of tag x09, set 0
    la      x10,    ta_s0_0     # x0b0: Load X10 with address of tag x0a, set 0

HELL_LOOP:
    sw      x1,     0(x2)       # x0b8: Dirty tag x02, set 0
    sw      x1,     0(x3)       # x0bc: Dirty tag x03, set 0
# (L = x06, S = 6, T = x00)
# I (S=6,T=0,W=0), L2 (S=6,T=0,W=0)                              
    sw      x1,     0(x4)       # x0c0: Dirty tag x04, set 0
    sw      x1,     0(x5)       # x0c4: Dirty tag x05, set 0
    sw      x1,     0(x6)       # x0c8: Dirty tag x06, set 0
    sw      x1,     0(x7)       # x0cc: Dirty tag x07, set 0
    sw      x1,     0(x8)       # x0d0: Dirty tag x08, set 0
    sw      x1,     0(x9)       # x0d4: Dirty tag x09, set 0
    sw      x1,     0(x10)      # x0d8: Dirty tag x0a, set 0

# First iteration of HELL_LOOP
# D (S=0,T=2,W=0)                    , L2 (S=0,T=2,W=0)
# D (S=0,T=3,W=1)                    , L2 (S=0,T=3,W=2)
# D (S=0,T=4,W=0) EVICT (S=0,T=2,W=0), L2 (S=0,T=4,W=3)                                         (W=0 dirty)
# D (S=0,T=5,W=1) EVICT (S=0,T=3,W=1), L2 (S=0,T=5,W=1)                                         (W=2 dirty, S=0 full) 
# D (S=0,T=6,W=0) EVICT (S=0,T=4,W=0), L2 (S=0,T=6,W=0) EVICT (S=0,T=2,W=0), VC[0] = (S=0,T=2)  (W=3 dirty, W=0 clean)
# D (S=0,T=7,W=1) EVICT (S=0,T=5,W=1), L2 (S=0,T=7,W=2) EVICT (S=0,T=3,W=2), VC[1] = (S=0,T=3)  (W=1 dirty, W=2 clean)
# D (S=0,T=8,W=0) EVICT (S=0,T=6,W=0), L2 (S=0,T=8,W=3) EVICT (S=0,T=4,W=3), VC[2] = (S=0,T=4)  (W=0 dirty, W=3 clean)
# D (S=0,T=9,W=1) EVICT (S=0,T=7,W=1), L2 (S=0,T=9,W=1) EVICT (S=0,T=5,W=1), VC[3] = (S=0,T=5)  (W=2 dirty, W=1 clean)
# D (S=0,T=a,W=0) EVICT (S=0,T=8,W=0), L2 (S=0,T=a,W=0) EVICT (S=0,T=6,W=0), VC[4] = (S=0,T=6)  (W=3 dirty, W=0 clean)

    addi    x20, x20, -1        # x0dc: Decrement loop counter

# (L = x07, S = 7, T = x00)      
# I (S=7,T=0,W=0), L2 (S=7,T=0,W=0)

    addi    x1, x1, 1           # x0e0: Increment dirty value to observe change
    bne     x20, x0, HELL_LOOP  # x0e4: Let's go again boyz!

    nop                         # x0e8: Nops to push into tag 1 so balign gets
    nop                         # x0ec: to tag 2 as desired
    nop                         # x0f0:
    nop                         # x0f4:
    nop                         # x0f8:
    nop                         # x0fc:

HALT:
# (L = x08, S = 0, T = x01)
    beq     x0, x0, HALT        # x100: The deed is done...


.section .rodata
.balign 256 # Each tag is 256 *bytes*, so this aligns us to tag 2

# Start of tag 2
# (L = x10, S = 0, T = x02)
t2_s0_0: .word 0x00000000
t2_s0_1: .word 0x22222222
t2_s0_2: .word 0x22222222
t2_s0_3: .word 0x22222222
t2_s0_4: .word 0x22222222
t2_s0_5: .word 0x22222222
t2_s0_6: .word 0x22222222
t2_s0_7: .word 0x22222222

# (L = x11, S = 1, T = x02)
t2_s1_0: .word 0x00000000
t2_s1_1: .word 0x22222222
t2_s1_2: .word 0x22222222
t2_s1_3: .word 0x22222222
t2_s1_4: .word 0x22222222
t2_s1_5: .word 0x22222222
t2_s1_6: .word 0x22222222
t2_s1_7: .word 0x22222222

# (L = x12, S = 2, T = x02)
t2_s2_0: .word 0x00000000
t2_s2_1: .word 0x22222222
t2_s2_2: .word 0x22222222
t2_s2_3: .word 0x22222222
t2_s2_4: .word 0x22222222
t2_s2_5: .word 0x22222222
t2_s2_6: .word 0x22222222
t2_s2_7: .word 0x22222222

# (L = x13, S = 3, T = x02)
DATA:    .word 0x01234567

.balign 256

# Start of tag 3
# (L = x18, S = 0, T = x03)
t3_s0_0: .word 0x00000000
t3_s0_1: .word 0x33333333
t3_s0_2: .word 0x33333333
t3_s0_3: .word 0x33333333
t3_s0_4: .word 0x33333333
t3_s0_5: .word 0x33333333
t3_s0_6: .word 0x33333333
t3_s0_7: .word 0x33333333

# (L = x19, S = 1, T = x03)
t3_s1_0: .word 0x00000000
t3_s1_1: .word 0x33333333
t3_s1_2: .word 0x33333333
t3_s1_3: .word 0x33333333
t3_s1_4: .word 0x33333333
t3_s1_5: .word 0x33333333
t3_s1_6: .word 0x33333333
t3_s1_7: .word 0x33333333

# (L = x1a, S = 2, T = x03)
t3_s2_0: .word 0x00000000
t3_s2_1: .word 0x33333333
t3_s2_2: .word 0x33333333
t3_s2_3: .word 0x33333333
t3_s2_4: .word 0x33333333
t3_s2_5: .word 0x33333333
t3_s2_6: .word 0x33333333
t3_s2_7: .word 0x33333333

.balign 256

# Start of tag 4
# (L = x20, S = 0, T = x04)
t4_s0_0: .word 0x00000000
t4_s0_1: .word 0x44444444
t4_s0_2: .word 0x44444444
t4_s0_3: .word 0x44444444
t4_s0_4: .word 0x44444444
t4_s0_5: .word 0x44444444
t4_s0_6: .word 0x44444444
t4_s0_7: .word 0x44444444

# (L = x21, S = 1, T = x04)
t4_s1_0: .word 0x00000000
t4_s1_1: .word 0x44444444
t4_s1_2: .word 0x44444444
t4_s1_3: .word 0x44444444
t4_s1_4: .word 0x44444444
t4_s1_5: .word 0x44444444
t4_s1_6: .word 0x44444444
t4_s1_7: .word 0x44444444

# (L = x22, S = 2, T = x04)
t4_s2_0: .word 0x00000000
t4_s2_1: .word 0x44444444
t4_s2_2: .word 0x44444444
t4_s2_3: .word 0x44444444
t4_s2_4: .word 0x44444444
t4_s2_5: .word 0x44444444
t4_s2_6: .word 0x44444444
t4_s2_7: .word 0x44444444

.balign 256

# Start of tag 5
# (L = x28, S = 0, T = x05)
t5_s0_0: .word 0x00000000
t5_s0_1: .word 0x55555555
t5_s0_2: .word 0x55555555
t5_s0_3: .word 0x55555555
t5_s0_4: .word 0x55555555
t5_s0_5: .word 0x55555555
t5_s0_6: .word 0x55555555
t5_s0_7: .word 0x55555555

# (L = x29, S = 1, T = x05)
t5_s1_0: .word 0x00000000
t5_s1_1: .word 0x55555555
t5_s1_2: .word 0x55555555
t5_s1_3: .word 0x55555555
t5_s1_4: .word 0x55555555
t5_s1_5: .word 0x55555555
t5_s1_6: .word 0x55555555
t5_s1_7: .word 0x55555555

# (L = x2a, S = 2, T = x05)
t5_s2_0: .word 0x00000000
t5_s2_1: .word 0x55555555
t5_s2_2: .word 0x55555555
t5_s2_3: .word 0x55555555
t5_s2_4: .word 0x55555555
t5_s2_5: .word 0x55555555
t5_s2_6: .word 0x55555555
t5_s2_7: .word 0x55555555

.balign 256

# Start of tag 6
# (L = x30, S = 0, T = x06)
t6_s0_0: .word 0x00000000
t6_s0_1: .word 0x66666666
t6_s0_2: .word 0x66666666
t6_s0_3: .word 0x66666666
t6_s0_4: .word 0x66666666
t6_s0_5: .word 0x66666666
t6_s0_6: .word 0x66666666
t6_s0_7: .word 0x66666666

# (L = x31, S = 1, T = x06)
t6_s1_0: .word 0x00000000
t6_s1_1: .word 0x66666666
t6_s1_2: .word 0x66666666
t6_s1_3: .word 0x66666666
t6_s1_4: .word 0x66666666
t6_s1_5: .word 0x66666666
t6_s1_6: .word 0x66666666
t6_s1_7: .word 0x66666666

# (L = x32, S = 2, T = x06)
t6_s2_0: .word 0x00000000
t6_s2_1: .word 0x66666666
t6_s2_2: .word 0x66666666
t6_s2_3: .word 0x66666666
t6_s2_4: .word 0x66666666
t6_s2_5: .word 0x66666666
t6_s2_6: .word 0x66666666
t6_s2_7: .word 0x66666666

.balign 256

# Start of tag 7
# (L = x38, S = 0, T = x07)
t7_s0_0: .word 0x00000000
t7_s0_1: .word 0x77777777
t7_s0_2: .word 0x77777777
t7_s0_3: .word 0x77777777
t7_s0_4: .word 0x77777777
t7_s0_5: .word 0x77777777
t7_s0_6: .word 0x77777777
t7_s0_7: .word 0x77777777

# (L = x39, S = 1, T = x07)
t7_s1_0: .word 0x00000000
t7_s1_1: .word 0x77777777
t7_s1_2: .word 0x77777777
t7_s1_3: .word 0x77777777
t7_s1_4: .word 0x77777777
t7_s1_5: .word 0x77777777
t7_s1_6: .word 0x77777777
t7_s1_7: .word 0x77777777

# (L = x3a, S = 2, T = x07)
t7_s2_0: .word 0x00000000
t7_s2_1: .word 0x77777777
t7_s2_2: .word 0x77777777
t7_s2_3: .word 0x77777777
t7_s2_4: .word 0x77777777
t7_s2_5: .word 0x77777777
t7_s2_6: .word 0x77777777
t7_s2_7: .word 0x77777777

.balign 256

# Start of tag 8
# (L = x40, S = 0, T = x08)
t8_s0_0: .word 0x00000000
t8_s0_1: .word 0x88888888
t8_s0_2: .word 0x88888888
t8_s0_3: .word 0x88888888
t8_s0_4: .word 0x88888888
t8_s0_5: .word 0x88888888
t8_s0_6: .word 0x88888888
t8_s0_7: .word 0x88888888

# (L = x41, S = 1, T = x08)
t8_s1_0: .word 0x00000000
t8_s1_1: .word 0x88888888
t8_s1_2: .word 0x88888888
t8_s1_3: .word 0x88888888
t8_s1_4: .word 0x88888888
t8_s1_5: .word 0x88888888
t8_s1_6: .word 0x88888888
t8_s1_7: .word 0x88888888

# (L = x42, S = 2, T = x08)
t8_s2_0: .word 0x00000000
t8_s2_1: .word 0x88888888
t8_s2_2: .word 0x88888888
t8_s2_3: .word 0x88888888
t8_s2_4: .word 0x88888888
t8_s2_5: .word 0x88888888
t8_s2_6: .word 0x88888888
t8_s2_7: .word 0x88888888

.balign 256

# Start of tag 9
# (L = x48, S = 0, T = x09)
t9_s0_0: .word 0x00000000
t9_s0_1: .word 0x99999999
t9_s0_2: .word 0x99999999
t9_s0_3: .word 0x99999999
t9_s0_4: .word 0x99999999
t9_s0_5: .word 0x99999999
t9_s0_6: .word 0x99999999
t9_s0_7: .word 0x99999999

# (L = x49, S = 1, T = x09)
t9_s1_0: .word 0x00000000
t9_s1_1: .word 0x99999999
t9_s1_2: .word 0x99999999
t9_s1_3: .word 0x99999999
t9_s1_4: .word 0x99999999
t9_s1_5: .word 0x99999999
t9_s1_6: .word 0x99999999
t9_s1_7: .word 0x99999999

# (L = x4a, S = 2, T = x09)
t9_s2_0: .word 0x00000000
t9_s2_1: .word 0x99999999
t9_s2_2: .word 0x99999999
t9_s2_3: .word 0x99999999
t9_s2_4: .word 0x99999999
t9_s2_5: .word 0x99999999
t9_s2_6: .word 0x99999999
t9_s2_7: .word 0x99999999

.balign 256

# Start of tag a
# (L = x50, S = 0, T = x0a)
ta_s0_0: .word 0x00000000
ta_s0_1: .word 0xaaaaaaaa
ta_s0_2: .word 0xaaaaaaaa
ta_s0_3: .word 0xaaaaaaaa
ta_s0_4: .word 0xaaaaaaaa
ta_s0_5: .word 0xaaaaaaaa
ta_s0_6: .word 0xaaaaaaaa
ta_s0_7: .word 0xaaaaaaaa

# (L = x51, S = 1, T = x0a)
ta_s1_0: .word 0x00000000
ta_s1_1: .word 0xaaaaaaaa
ta_s1_2: .word 0xaaaaaaaa
ta_s1_3: .word 0xaaaaaaaa
ta_s1_4: .word 0xaaaaaaaa
ta_s1_5: .word 0xaaaaaaaa
ta_s1_6: .word 0xaaaaaaaa
ta_s1_7: .word 0xaaaaaaaa

# (L = x52, S = 2, T = x0a)
ta_s2_0: .word 0x00000000
ta_s2_1: .word 0xaaaaaaaa
ta_s2_2: .word 0xaaaaaaaa
ta_s2_3: .word 0xaaaaaaaa
ta_s2_4: .word 0xaaaaaaaa
ta_s2_5: .word 0xaaaaaaaa
ta_s2_6: .word 0xaaaaaaaa
ta_s2_7: .word 0xaaaaaaaa
