la_test.s:
.align 4
.section .text
.globl _start
_start:

        la x1, msg

.section .rodata
msg:
        .string "Hello World\n"