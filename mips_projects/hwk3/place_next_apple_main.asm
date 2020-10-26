.data
apples: .byte 2 5 3 5 -1 -1 -1 -1 4 1 4 3 2 9
apples_length: .word 7
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
la $a1, apples
lw $a2, apples_length
jal place_next_apple

move $t0, $v0
move $t1, $v1
# You must write your own code here to check the correctness of the function implementation.

li $v0, 10
syscall

.include "hwk3.asm"
