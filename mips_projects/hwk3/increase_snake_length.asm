.data
direction: .byte 'D'
.align 2
state:
.byte 8  # num_rows
.byte 14  # num_cols
.byte 4  # head_row
.byte 5  # head_col
.byte 13  # length
# Game grid:
.asciiz "....................##......................#........#....#..1234..#a.........56..D.......##.7..C..........89AB."

.text
.globl main
main:
la $a0, state
lbu $a1, direction
jal increase_snake_length
# You must write your own code here to check the correctness of the function implementation.
move $t0, $v0

la $s0, state
addi $s0, $s0, 5
li $s1, 0
li $s2, 112
li $s3, 14


loop:

    lbu $t1, 0($s0)
    beqz $t1, done_loop 
    div $s1, $s3
    mfhi $t2
    beqz $t2, print_line
    
    move $a0, $t1
    li $v0, 11
    syscall
    
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    j loop

print_line:
    li $a0, '\n'
    li $v0, 11
    syscall
    move $a0, $t1
    li $v0, 11
    syscall
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    j loop

done_loop:

li $v0, 10
syscall

.include "hwk3.asm"
