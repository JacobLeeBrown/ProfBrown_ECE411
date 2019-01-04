.align 4
.section .text
.globl _start
_start:

    # Start of line x03
    # Set = 011, Tag = 24'h000000 -> Should see line x03 in set 3, way 0
        #  Byte No. in Pmem (hex): Notes
    la      x1, line1       # x60: 2 Instructions (8 Bytes)
    la      x2, line2       # x68: 2 Instructions (8 Bytes)
    la      x3, line3       # x70: 2 Instructions (8 Bytes)
    nop                     # x78: nop = x0000 0013
    nop                     # x7C: nop = x0000 0013
    # Start of line x04
    # Set = 010, Tag = 24'h000000 -> Should see line x04 in set 4, way 0
    lw      x4, 0(x1)       # x80: Needs line x0B (Set = 011, Tag = 24'h000001)
                            #    : Should see line x0B in set 3, way 1
    lw      x5, 0(x2)       # x84: Needs line x13 (Set = 011, Tag = 24'h000002)
                            #    : Should see line x13 in set 3, way 0 (LRU)
    lw      x6, 0(x1)       # x88: Needs line x0B (Set = 011, Tag = 24'h000001)
                            #    : Should see line x0B still in set 3, way 1
    lw      x7, 0(x3)       # x8C: Needs line x1B (Set = 011, Tag = 24'h000003)
                            #    : Should see line x1B in set 3, way 0 (LRU)
    lw      x8, 0(x1)       # x90: Needs line x0B (Set = 011, Tag = 24'h000001)
                            #    : Should see line x0B still in set 3, way 1
    lw      x1, 0(x3)       # x94: Needs line x1B (Set = 011, Tag = 24'h000003)
                            #    : Should see line x1B still in set 3, way 0
    lw      x2, 0(x2)       # x98: Needs line x13 (Set = 011, Tag = 24'h000001)
                            #    : Should see line x13 in set 3, way 1 (LRU)

inf:
    jal x0, inf             # x9C
    # Start of line x05
	
.section .rodata
.balign 256
.zero 96 
# We see line1 starts in line x0B, meaning .zero 96 fills 6 tags worth of memory
# with 0's.
# .zero 96 = 6*32B = 192 B -> .zero 1 fills 2B with zeros (16 bits)
# Start of line x0B
line1:      .word 0x11111111
line11:	    .word 0x00000000
line12:     .word 0x00000000
line13:	    .word 0x00000000
line14:	    .word 0x00000000
line15:	    .word 0x00000000
line16:	    .word 0x00000000
line17:	    .word 0x00000000
# Start of line x0C
line18:	    .word 0x00000000
line19:	    .word 0x00000000
line1a:	    .word 0x00000000
line1b:	    .word 0x00000000
line1c:	    .word 0x00000000
line1d:	    .word 0x00000000
line1e:	    .word 0x00000000
line1f:	    .word 0x00000000
# Start of line x0D
.balign 256
.zero 96
# Start of line x13
line2:      .word 0x22222222
line21:	    .word 0x00000000
line22:	    .word 0x00000000
line23:	    .word 0x00000000
line24:	    .word 0x00000000
line25:	    .word 0x00000000
line26:	    .word 0x00000000
line27:	    .word 0x00000000
# Start of line x14
line28:	    .word 0x00000000
line29:	    .word 0x00000000
line2a:	    .word 0x00000000
line2b:	    .word 0x00000000
line2c:	    .word 0x00000000
line2d:	    .word 0x00000000
line2e:	    .word 0x00000000
line2f:	    .word 0x00000000
# Start of line x15
.balign 256
.zero 96
# Start of line x1B
line3:	    .word 0x33333333
line31:	    .word 0x00000000
line32:	    .word 0x00000000
line33:	    .word 0x00000000
line34:	    .word 0x00000000
line35:	    .word 0x00000000
line36:	    .word 0x00000000
line37:	    .word 0x00000000
# Start of line x1C
line38:	    .word 0x00000000
line39:	    .word 0x00000000
line3a:	    .word 0x00000000
line3b:	    .word 0x00000000
line3c:	    .word 0x00000000
line3d:	    .word 0x00000000
line3e:	    .word 0x00000000
line3f:	    .word 0x00000000
# Start of line x1D

# Spike output for final register values:
# X0  = x00000000
# X1  = x33333333
# X2  = x22222222
# X3  = x80000360
# X4  = x11111111
# X5  = x22222222
# X6  = x11111111
# X7  = x33333333
# X8  = x11111111
# X9  = x00000000
# X10 = x00000000
# X11 = x00001020
