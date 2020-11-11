.text
.globl main
main:
jal create_deck

move $t0, $v0
lw $t1, 0($t0) #size
lw $t2, 4($t0) #pointer to card 

loop:
    beqz $t1, done_loop
    lw $t3, 0($t2)
    addi $t5, $t1, -80
    li $t6, -1
    mul $t5, $t5, $t6
    move $a0, $t5
    li $v0, 1
    syscall
    li $a0, '.'
    li $v0, 11
    syscall
    li $a0, ' '
    li $v0, 11
    syscall
    move $a0, $t3
    li $v0, 34
    syscall
    li $a0, '\n'
    li $v0, 11
    syscall
    lw $t2, 4($t2)
    addi $t1, $t1, -1
    j loop
done_loop:
# Write code to check the correctness of your code!
li $v0, 10
syscall

.include "hwk5.asm"
