.data
row: .byte -5
col: .byte 5
ch: .byte 'Q'
.align 2
state:
.byte 5  # num_rows
.byte 12  # num_cols
.byte 1  # head_row
.byte 5  # head_col
.byte 7  # length
# Game grid:
.asciiz ".............a.#.1..#......#.2..#......#.3..#........4567..."

.text
.globl main
main:
la $a0, state
lb $a1, row
lb $a2, col
lbu $a3, ch
jal set_slot

move $t0, $v0

# You must write your own code here to check the correctness of the function implementation.

li $v0, 10
syscall

.include "hwk3.asm"
