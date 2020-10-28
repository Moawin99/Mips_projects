.data
str1: .asciiz "StonyBrook"
str2: .asciiz "Stony"

.text
.globl main
main:
la $a0,  str1
la $a1,  str2
jal strcmp

move $t0, $v0

# Write code to check the correctness of your code!
li $v0, 10
syscall

.include "hwk4.asm"
