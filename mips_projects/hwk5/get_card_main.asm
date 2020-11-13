.data
index: .word 7
.align 2
card_list:
.word 8  # list's size
.word node85405 # address of list's head
node930524:
.word 6574898
.word node968934
node265857:
.word 7689011
.word node930524
node45000:
.word 6572086
.word node38905
node870030:
.word 6572083
.word 0
node579585:
.word 7685168
.word node45000
node85405:
.word 6574898
.word node579585
node38905:
.word 7684917
.word node265857
node968934:
.word 7684912
.word node870030

.text
.globl main
main:
la $a0, card_list
lw $a1, index
jal get_card

move $t0, $v0
move $t1, $v1

# Write code to check the correctness of your code!
li $v0, 10
syscall

.include "hwk5.asm"
