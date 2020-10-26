.data
str: .ascii "CSE 220 COVID-19 Edition\0"
ch: .byte 'n'
start_index: .word 5

.text
.globl main
main:
	la $a0, str
	lbu $a1, ch
	lw $a2, start_index
	jal index_of
	
	move $t0, $v0
	# You must write your own code here to check the correctness of the function implementation.

	li $v0, 10
	syscall
	
.include "hwk2.asm"
