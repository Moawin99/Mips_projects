.data
card_num: .word 6570802
.align 2
card_list:
.word 5  # list's size
.word node537691 # address of list's head
node299116:
.word 7689011
.word 0
node411020:
.word 6572086
.word node171407
node537691:
.word 6574898
.word node253109
node171407:
.word 7684917
.word node299116
node253109:
.word 7685168
.word node411020

.text
.globl main
main:
la $a0, card_list
lw $a1, card_num
jal append_card

move $t0, $v0
move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $t0, card_list
lw $t1, 0($t0) #size
lw $t2, 4($t0) #pointer to card 

loop:
    beqz $t1, done_loop
    lw $t3, 0($t2)
    move $a0, $t3
    li $v0, 1
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
