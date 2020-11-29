# Load game02.txt
.data
filename: .asciiz "games/game02.txt"
# Garbage values
deck: .word 49752558 84042193
# Garbage values
.data
.align 2
board:
.word card_list601262 card_list492090 card_list806140 card_list547011 card_list216912 card_list669785 card_list848653 card_list417583 card_list677543 
# column #3
.align 2
card_list547011:
.word 319918  # list's size
.word 360147 # address of list's head
# column #7
.align 2
card_list417583:
.word 330578  # list's size
.word 13158 # address of list's head
# column #1
.align 2
card_list492090:
.word 500091  # list's size
.word 278210 # address of list's head
# column #5
.align 2
card_list669785:
.word 861167  # list's size
.word 638481 # address of list's head
# column #8
.align 2
card_list677543:
.word 936317  # list's size
.word 806648 # address of list's head
# column #4
.align 2
card_list216912:
.word 840431  # list's size
.word 506422 # address of list's head
# column #0
.align 2
card_list601262:
.word 955411  # list's size
.word 451557 # address of list's head
# column #6
.align 2
card_list848653:
.word 552679  # list's size
.word 592251 # address of list's head
# column #2
.align 2
card_list806140:
.word 878537  # list's size
.word 38529 # address of list's head
# Garbage values
moves: .ascii "GWaPsfyUlNuC3gUM9VImzORemnUwBXEsP4JIkybqUbW65ORkXmxlgiTMgrh56exd6qxiqAfNqHYJ3hQIh6vsZZO3WQtC9paf1hNg7XC1y0745w8Rl05iyaAnp6aZAiZ2flIrAkX4y0te3bhYKzrKdORITm4ttMJYQvbQjts49mBnFcBe3ZZjkQdJo51eCL9mzKT03BTI8xe813nfCc8I7tSbnRcj2PHgTd1AZU4ENyvQlPQzBQRgfcnjQZPiYTQLtxGATqsA2lIH2Q7Jf27a4LMTjHWM8QMgD6PpOZ0JEbxsZWDxPVs1IWKLPYvmkcxdLgFZxWAQl5gQNeoKyiGRTgW7F7HWo4OYHFvu8MO2AY55WPrvRElpgUT1dSHTXjx7cijZPkRRzVZlXJ4pG8PlXFGQaEjrwRGOCoeBV24EzudOB3ASfuCDahcTwxuXpSJSR6JEUX0LSvQocliPCm0R1EBO1aw8P7ir97wItRewnYdhJiHaMFGAzTFeZmlwovSAVFhzewG8ygmqfShxlmf3eB0PP6C7UB8C"


.text
.globl main
main:
la $a0, filename
la $a1, board
la $a2, deck
la $a3, moves
jal load_game

la $t0, board
li $t9, 9
out_loop:
    li $a0, '\n'
    li $v0, 11
    syscall
beqz $t9, done_loop
lw $t8, 0($t0)
lw $t1, 0($t8) #size
lw $t2, 4($t8) #pointer to card 
    addi $t5, $t9, -9
    li $t6, -1
    mul $t5, $t5, $t6
    move $a0, $t5
    li $v0, 1
    syscall
    li $a0, '.'
    li $v0, 11
    syscall
addi $t0, $t0, 4
addi $t9, $t9, -1
loop:
    beqz $t1, out_loop
    lw $t3, 0($t2)
    li $a0, ' '
    li $v0, 11
    syscall
    move $a0, $t3
    li $v0, 34
    syscall
    lw $t2, 4($t2)
    addi $t1, $t1, -1
    j loop
done_loop:
li $a0, '\n'
li $v0, 11
syscall
la $t0, deck
lw $t1, 0($t0) #size
lw $t2, 4($t0) #pointer to card 
loop1:
    beqz $t1, done_loop1
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
    j loop1
done_loop1:
# Write code to check the correctness of your code!
li $v0, 10
syscall

.include "hwk5.asm"
