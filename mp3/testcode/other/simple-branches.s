.align 4
.section .text
.globl _start
_start:

    # Cache Line 3: Set 3, Tag 0
    add     x1, x0, 1       # x060:
    add     x2, x1, x1      # x064:
    add     x3, x2, x1      # x068:

    add     x4, x0, 4       # x06c: Counter for 4 iterations
LOOP1:
    add     x2, x0, 0       # x070: X2 <- 0
    add     x3, x0, x0      # x074: X3 <- 0
    add     x2, x0, 2       # x078: X2 <- 2
    add     x3, x2, 1       # x07c: X3 <- 3
    # Cache Line 4: Set 4, Tag 0
    add     x4, x4, -1      # x080: X4--  
    bne     x4, x0, LOOP1   # x084: Loop if X4 > 0

    add     x5, x0, 1       # x088: X5 <- 1
    add     x6, x0, 1       # x08c: X6 <- 1
    add     x6, x0, 6       # x090: X6 <- 6
    beq     x5, x6, BAD     # x094: Tests that EX/MEM gets forwarded over MEM/WB

    add     x1, x0, 10      # x098: X1 <- 10 (Indicator code works)

INF:
    beq     x0, x0, INF     # x09c: Halt

BAD:
    # Cache Line 5: Set 5, Tag 0
    add     x1, x0, -1      # x0a0: X1 <- -1 (Indicator forwarding is broke)
    beq     x0, x0, INF     # x0a4:
