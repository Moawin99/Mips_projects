.data
year: .word 3997

.text
.globl main
main:
lw $a0, year
jal is_leap_year

move $t0, $v0
# Write code to check the correctness of your code!
li $v0, 10
syscall

.include "hwk4.asm"
