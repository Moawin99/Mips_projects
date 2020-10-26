# Mark Moawad
# msmoawad
# 112198934

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text
load_game:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	move $s0, $a0		#GameState state
	move $s1, $a1		#filename
	move $fp, $sp		
	#Open File
	li $v0, 13
	move $a0, $s1
	li $a1, 0
	li $a2, 0
	syscall			#open file, (fileName, read, 0)
	li $t0, -1
	beq $v0, $t0, dne
	move $t0, $v0
	#Read File
	li $v0, 14
	move $a0, $t0
	addi $sp, $sp, -1
	move $a1, $sp
	li $a2, 1
	syscall
	#write File
	lbu $t0, 0($sp)
	addi $t0, $t0, -48
	li $t1, '\n'
	li $t2, '\r'
	li $v0, 14
	syscall
	lbu $t3, 0($sp)
	beq $t3, $t1, storeNumRows1
	beq $t3, $t2, storeNumRows2
	li $t1, 10
	mult $t0, $t1
	mflo $t0
	addi $t3, $t3, -48
	add $t0, $t0, $t3
	sb $t0, 0($s0)
	j readCol
	
storeNumRows1:
	sb $t0, 0($s0)
	j readCol
	
storeNumRows2:
	sb $t0, 0($s0)
	li $v0, 14
	syscall

readCol:
	li $v0, 14
	syscall
	lbu $t0, 0($sp)
	addi $t0, $t0, -48
	li $t1, '\n'
	li $t2, '\r'
	li $v0, 14
	syscall
	lbu $t3, 0($sp)
	beq $t3, $t1, storeNumCol1
	beq $t3, $t2, storeNumCol2
	li $t1, 10
	mult $t0, $t1
	mflo $t0
	addi $t3, $t3, -48
	add $t0, $t0, $t3
	sb $t0, 1($s0)
	j readGrid
	
storeNumCol1:
	sb $t0, 1($s0)
	j readGrid
	
storeNumCol2:
	sb $t0, 1($s0)
	li $v0, 14
	syscall
	
readGrid:
	li $v0, 14
	syscall
	lbu $t1, 0($sp)
	li $t2, '\n'
	beq $t1, $t2, moveOn
	li $v0, 14
	syscall
moveOn:
	lbu $t1, 0($s0)
	lbu $t2, 1($s0)
	mult $t1, $t2
	mflo $t8		#range
	move $t0, $s0
	addi $t0, $t0, 5
	li $t1, 0		#boolean apple
	li $t2, 0		#walls found
	li $t3, 0		#snake length
	li $t4, 0		#current Row
	li $t7, 0		#current Col
	li $t9, 0		#counter
	
loopGrid:
	li $v0, 14
	syscall 
	lbu $t5, 0($sp)
	beq $t8, $t9, doneGrid
	li $t6, '\r'
	beq $t5, $t6, skipTwice
	li $t6, '\n'
	beq $t5, $t6, skip
	li $t6, 'a'
	beq $t5, $t6, foundApple
	li $t6, '#'
	beq $t5, $t6, countWall
	li $t6, '1'
	beq $t5, $t6, storeHeadInfo
	li $t6, '.'
	bne $t5, $t6, addToLength
	sb $t5, 0($t0)
	addi $t0, $t0, 1
	addi $t7, $t7, 1
	addi $t9, $t9, 1
	j loopGrid
	
skipTwice:
	li $v0, 14
	syscall
	addi $t4, $t4, 1
	li $t7, 0
	j loopGrid
	
skip:
	addi $t4, $t4, 1
	li $t7, 0
	j loopGrid
	
foundApple:
	li $t1, 1
	sb $t5, 0($t0)
	addi $t0, $t0, 1
	addi $t7, $t7, 1
	addi $t9, $t9, 1
	j loopGrid

countWall:
	addi $t2, $t2, 1
	sb $t5, 0($t0)
	addi $t0, $t0, 1
	addi $t7, $t7, 1
	addi $t9, $t9, 1
	j loopGrid

storeHeadInfo:
	sb $t4, 2($s0)
	sb $t7, 3($s0)
	sb $t5, 0($t0)
	addi $t0, $t0, 1
	addi $t7, $t7, 1
	addi $t3, $t3, 1
	addi $t9, $t9, 1
	j loopGrid
	
addToLength:
	addi $t3, $t3, 1
	addi $t7, $t7, 1
	sb $t5, 0($t0)
	addi $t0, $t0, 1
	addi $t9, $t9, 1
	j loopGrid

doneGrid:
	sb $t3, 4($s0)
	j finish1
	
dne:
	li $v0, -1
	li $v1, -1

finish1:
	#Close File
	li $v0, 16
	syscall
	move $v0, $t1
	move $v1, $t2
	move $sp, $fp
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
    jr $ra

get_slot:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	move $s0, $a0
	move $s1, $a1		#row
	move $s2, $a2		#col
	lbu $t0, 0($s0)		#num of rows
	lbu $t1, 1($s0)		#num of cols
	bge $s1, $t0, noneValidInput
	bge $s2, $t1, noneValidInput
	bltz $s1, noneValidInput
	bltz $s2, noneValidInput
	mult $s1, $t1
	mflo $t0
	add $t0, $t0, $s2
	addi $s0, $s0, 5
	add $s0, $s0, $t0
	lbu $t0 0($s0)
	move $v0, $t0
	j doneWith2
	
noneValidInput:
	li $v0, -1
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	j done2
	
doneWith2:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
done2:
    jr $ra

set_slot:
	addi $sp, $sp, -16
	sw $s0, 0($sp)		#gameState
	sw $s1, 4($sp)		#row
	sw $s2, 8($sp)		#col
	sw $s3, 12($sp)		#ch
	move $s0, $a0	
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	lbu $t0, 0($s0)
	lbu $t1, 1($s0)
	bgt $s1, $t0, invalidInput
	bgt $s2, $t1, invalidInput
	bltz $s1, invalidInput
	bltz $s2, invalidInput
	mult $s1, $t1
	mflo $t0
	add $t0, $t0, $s2
	addi $s0, $s0, 5
	add $s0, $s0, $t0
	sb $s3, 0($s0)
	move $v0, $s3
	j doneWith3
	
invalidInput:
	li $v0, -1
	j doneWith3

doneWith3:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
    jr $ra

place_next_apple:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	move $s0, $a0		#gamestate
	move $s1, $a1		#apples[]
	move $s2, $a2		#apples.length
	li $s3, '.'
	li $s4, 'a'
placeAppleLoop:
	lb $a1, 0($s1)
	lb $a2, 1($s1)
	jal get_slot
	beq $v0, $s3, setApple
	addi $s1, $s1, 2
	j placeAppleLoop
	
setApple:
	li $t0, -1
	sb $t0, 0($s1)
	sb $t0, 1($s1)
	move $a3, $s4
	jal set_slot
	move $v0, $a1
	move $v1, $a2
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	
    jr $ra

find_next_body_part:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	move $s0, $a0		#Game State
	move $s1, $a1		#Row
	move $s2, $a2		#Col
	move $s3, $a3		#target ascii value
	move $s4, $a0		#COPY of GameState
	lbu $t0, 0($s0)		#num_Rows
	lbu $t1, 1($s0)		#num_Cols
	bgt $s1, $t0, notOnGrid
	bgt $s2, $t1, notOnGrid
	bltz $s1, notOnGrid
	bltz $s2, notOnGrid
	addi $s0, $s0, 5
	mult $s1, $t1
	mflo $t2
	add $t2, $t2, $s2
	add $t2, $t2, $s0	#coordinates
checkLeft:
	addi $t3, $t2, -1
	addi $t5, $s2, -1
	bltz $t5, checkRight
	lbu $t4, 0($t3)
	beq $t4, $s3, foundValueLeft
	j checkRight
		
foundValueLeft:
	move $a0, $s4
	move $a1, $s1
	move $a2, $t5
	jal get_slot
	move $v0, $a1
	move $v1, $a2
	j doneWith5

checkRight:
	addi $t3, $t2, 1
	addi $t5, $s2, 1
	bge $t5, $t1, checkUp
	lbu $t4, 0($t3)
	beq $t4, $s3, foundValueRight
	j checkUp
	
foundValueRight:
	move $a0, $s4
	move $a1, $s1
	move $a2, $t5
	jal get_slot
	move $v0, $a1
	move $v1, $a2
	j doneWith5	

checkUp:
	sub $t3, $t2, $t1
	addi $t5, $s1, -1
	bltz $t5, checkDown
	lbu $t4, 0($t3)
	beq $t4, $s3, foundValueUp
	j checkDown
	
foundValueUp:
	move $a0, $s4
	move $a1, $t5
	move $a2, $s2
	jal get_slot
	move $v0, $a1
	move $v1, $a2
	j doneWith5	
	
checkDown:
	add $t3, $t2, $t1
	addi $t5, $s1, 1
	bge $t5, $s2, notOnGrid
	lbu $t4, 0($t3)
	beq $t4, $s3, foundValueDown
	j notOnGrid
	
foundValueDown:
	move $a0, $s4
	move $a1, $t5
	move $a2, $s2
	jal get_slot
	move $v0, $a1
	move $v1, $a2
	j doneWith5	
	
notOnGrid:
	li $v0, -1
	li $v1, -1
	
doneWith5:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
    jr $ra

slide_body:
	lw $t0, 0($sp)
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $ra, 28($sp)
	move $s0, $a0		#GameState
	move $s1, $a1		#Delta row
	move $s2, $a2		#Delta Col
	move $s3, $a3		#apples[]
	move $s4, $a0		#COPY of GameState
	move $s5, $t0		#apples.length
	lbu $t0, 2($s0)		#head Row
	lbu $t1, 3($s0)		#head col
	move $t2, $t0		#temp Row
	move $t3, $t1		#temp Col
	add $t2, $t2, $s1	#new row
	add $t3, $t3, $s2	#new col
	move $a0, $s0
	move $a1, $t2
	move $a2, $t3
	
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal get_slot
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	
	move $t4, $v0
	li $t5, '.'
	beq $t5, $t4, move1Space
	li $t5, 'a'
	beq $t5, $t4, placeAppleFirst
	j couldNotMove
	
move1Space:
	li $s6, 0
	li $t5, '1'
	move $a3, $t5
	sb $t2, 2($s0)
	sb $t3, 3($s0)
	
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal set_slot
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	
	addi $t5, $t5, 1
	addi $a3, $a3, 1
	move $a1, $t0
	move $a2, $t1
	j slideRestOfSnake
	
placeAppleFirst:
	li $s6, 1
	move $a1, $s3
	move $a2, $s5
	
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal place_next_apple
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	
	li $t5, '1'
	move $a1, $t2
	move $a2, $t3
	move $a3, $t5
	sb $t2, 2($s0)
	sb $t3, 3($s0)
	
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal set_slot
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	
	addi $a3, $a3, 1
	addi $t5, $t5, 1
	move $a1, $t0
	move $a2, $t1
	j slideRestOfSnake
	
couldNotMove:
	li $v0, -1
	j doneWith6
	
slideRestOfSnake:
	li $t7, 57
	bgt $t5, $t7, updateAscii
	
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t5, 8($sp)
	jal find_next_body_part
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t5, 8($sp)
	addi $sp, $sp, 12
	
	move $t2, $v0
	move $t3, $v1
	li $t6, -1
	beq $t2, $t6, doneWith6Successful
	move $a1, $t0
	move $a2, $t1
	move $a3, $t5
	
	addi $sp, $sp, -12
	sw $t2, 0($sp)
	sw $t3, 4($sp)
	sw $t5, 8($sp)
	jal set_slot
	lw $t2, 0($sp)
	lw $t3, 4($sp)
	lw $t5, 8($sp)
	addi $sp, $sp, 12
	
	move $t0, $t2
	move $t1, $t3
	addi $t5, $t5, 1
	move $a1, $t0
	move $a2, $t1
	move $a3, $t5
	j slideRestOfSnake
	
updateAscii:
	li $t5, 65
	move $a3, $t5
slideRestOfSnakeAlpha:
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t5, 8($sp)
	jal find_next_body_part
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t5, 8($sp)
	addi $sp, $sp, 12
	
	move $t2, $v0
	move $t3, $v1
	li $t6, -1
	beq $t2, $t6, doneWith6Successful
	move $a1, $t0
	move $a2, $t1
	move $a3, $t5
	
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t5, 8($sp)
	jal set_slot
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t5, 8($sp)
	addi $sp, $sp, 12
	
	move $t0, $t2
	move $t1, $t3
	addi $t5, $t5, 1
	move $a1, $t0
	move $a2, $t1
	move $a3, $t5
	j slideRestOfSnakeAlpha
	
doneWith6Successful:
	li $a3, '.'
	jal set_slot
	move $v0, $s6
doneWith6:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32
	
    jr $ra

add_tail_segment:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	move $s0, $a0		#GameState
	move $s1, $a1		#Direction
	move $s2, $a2		#row
	move $s3, $a3		#col
	li $t0, 'U'
	beq $t0, $s1, addUp
	li $t0, 'D'
	beq $t0, $s1, addDown
	li $t0, 'L'
	beq $t0, $s1, addLeft
	li $t0, 'R'
	beq $t0, $s1, addRight
	j invalidDirection
	
addUp:
	addi $s2, $s2, -1	#row - 1
	bltz $s2, invalidDirection	#check if still on grid
	lbu $t0, 4($s0)
	li $t1, 35
	bge $t0, $t1, invalidDirection
	move $a1, $s2
	move $a2, $s3
	jal get_slot
	move $t0, $v0
	li $t1, '.'
	bne $t0, $t1, invalidDirection
	lbu $t0, 4($s0)
	li $t1, 9
	bgt $t0, $t1, addLetter
	li $t1, '1'
	add $t1, $t1, $t0
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $t1
	jal set_slot
	j doneWith7Successful
	
addDown:
	addi $s2, $s2, 1	#row + 1
	lbu $t0, 0($s0)
	bgt $s2, $t0, invalidDirection	#check if still on grid
	lbu $t0, 4($s0)		
	li $t1, 35
	bge $t0, $t1, invalidDirection
	move $a1, $s2
	move $a2, $s3
	jal get_slot
	move $t0, $v0
	li $t1, '.'
	bne $t0, $t1, invalidDirection
	lbu $t0, 4($s0)
	li $t1, 9
	bgt $t0, $t1, addLetter
	li $t1, '1'
	add $t1, $t1, $t0
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $t1
	jal set_slot
	j doneWith7Successful
	
addLeft:
	addi $s3, $s3, -1	#col - 1
	bltz $s3, invalidDirection	#check if still on grid
	lbu $t0, 4($s0)
	li $t1, 35
	bge $t0, $t1, invalidDirection
	move $a1, $s2
	move $a2, $s3
	jal get_slot
	move $t0, $v0
	li $t1, '.'
	bne $t0, $t1, invalidDirection
	lbu $t0, 4($s0)
	li $t1, 9
	bgt $t0, $t1, addLetter
	li $t1, '1'
	add $t1, $t1, $t0
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $t1
	jal set_slot
	j doneWith7Successful
	
addRight:
	addi $s3, $s3, 1	#col + 1
	lbu $t0, 1($s0)
	bgt $s3, $t0, invalidDirection	#check if still on grid
	lbu $t0, 4($s0)
	li $t1, 35
	bge $t0, $t1, invalidDirection
	move $a1, $s2
	move $a2, $s3
	jal get_slot
	move $t0, $v0
	li $t1, '.'
	bne $t0, $t1, invalidDirection
	lbu $t0, 4($s0)
	li $t1, 9
	bgt $t0, $t1, addLetter
	li $t1, '1'
	add $t1, $t1, $t0
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $t1
	jal set_slot
	j doneWith7Successful
	
addLetter:
	li $t1, 'A'
	addi $t0, $t0, -9
	add $t1, $t1, $t0
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $t1
	jal set_slot
	j doneWith7Successful
	
	
invalidDirection:
	li $v0, -1
	j doneWith7
	
doneWith7Successful:
	lbu $t0, 4($s0)
	addi $t0, $t0, 1
	sb $t0, 4($s0)
	move $v0, $t0
	
doneWith7:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	
    jr $ra

increase_snake_length:
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $ra, 28($sp)
	move $s0, $a0		#GameState
	move $s1, $a1		#Direction
	li $t0, 'U'
	beq $s1, $t0, invertUp
	j checkInvertDown
invertUp:
	li $s1, 'D'
	j continue7
checkInvertDown:
	li $t0, 'D'
	beq $s1, $t0, invertDown
	j checkInvertLeft
invertDown:
	li $s1, 'U'
	j continue7
checkInvertLeft:
	li $t0, 'L'
	beq $s1, $t0, invertLeft
	j invertRight
invertLeft:
	li $s1, 'R'
	j continue7
invertRight:
	li $s1, 'L'
	
continue7:
	lbu $s2, 2($s0)		#head_row
	lbu $s3, 3($s0)		#head_col
	li $s4, '2'
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $s4
	
loopToEndOfSnake:
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal find_next_body_part
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	move $s2, $v0		#coordinates of next_body_part
	move $s3, $v1		#coordinates of next_body_part
	li $t2, -1
	beq $s2, $t2, foundLastBodyPart
	move $t0, $s2		#COPY corrdinates
	move $t1, $s3		#COPY corrdinates
	addi $s4, $s4, 1
	li $t2, '9'
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $s4
	bgt $s4, $t2, loadBigA
	j loopToEndOfSnake
	
loadBigA:
	li $s4, 'A'
	move $a3, $s4
	
loopToEndOfSnakeAlpha:
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	jal find_next_body_part
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	addi $s4, $s4, 1
	move $s2, $v0		#coordinates of next_body_part
	move $s3, $v1		#coordinates of next_body_part
	li $t2, -1
	beq $s2, $t2, foundLastBodyPart
	move $t0, $s2		#COPY corrdinates
	move $t1, $s3		#COPY corrdinates
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $s4
	j loopToEndOfSnakeAlpha
	
foundLastBodyPart:
	move $a0, $s0
	move $a1, $s1
	move $a2, $t0
	move $a3, $t1
	move $s2, $t0	#holding coordinates incase it fails to place tail
	move $s3, $t1	#holding coordinates incase it fails to place tail
	jal add_tail_segment
	li $t0, -1
	move $t1, $v0
	bne $t0, $t1, doneWith8Successful
	li $s5, 0	#counter for counter clockwise operations
	li $s6, 3
	li $t0, 'U'
	beq $t0, $s1, tryLeft
	li $t0, 'L'
	beq $t0, $s1, tryDown
	li $t0, 'D'
	beq $t0, $s1, tryRight
	li $t0, 'R'
	beq $t0, $s1, tryUp
	j doneWith8Failed
	
tryLeft:
	beq $s5, $s6, doneWith8Failed
	move $a0, $s0
	li $a1, 'L'
	move $a2, $s2
	move $a3, $s3
	addi $sp, $sp, -8
	sw $s5, 0($sp)
	sw $s6, 4($sp)
	jal add_tail_segment
	lw $s5, 0($sp)
	lw $s6, 4($sp)
	addi $sp, $sp, 8
	li $t0, -1
	move $t1, $v0
	bne $t0, $t1, doneWith8Successful
	addi $s5, $s5, 1
	j tryDown
	
tryDown:
	beq $s5, $s6, doneWith8Failed
	move $a0, $s0
	li $a1, 'D'
	move $a2, $s2
	move $a3, $s3
	addi $sp, $sp, -8
	sw $s5, 0($sp)
	sw $s6, 4($sp)
	jal add_tail_segment
	lw $s5, 0($sp)
	lw $s6, 4($sp)
	addi $sp, $sp, 8
	li $t0, -1
	move $t1, $v0
	bne $t0, $t1, doneWith8Successful
	addi $s5, $s5, 1
	j tryRight
	
tryRight:
	beq $s5, $s6, doneWith8Failed
	move $a0, $s0
	li $a1, 'R'
	move $a2, $s2
	move $a3, $s3
	addi $sp, $sp, -8
	sw $s5, 0($sp)
	sw $s6, 4($sp)
	jal add_tail_segment
	lw $s5, 0($sp)
	lw $s6, 4($sp)
	addi $sp, $sp, 8
	li $t0, -1
	move $t1, $v0
	bne $t0, $t1, doneWith8Successful
	addi $s5, $s5, 1
	j tryUp
	
tryUp:
	beq $s5, $s6, doneWith8Failed
	move $a0, $s0
	li $a1, 'U'
	move $a2, $s2
	move $a3, $s3
	addi $sp, $sp, -8
	sw $s5, 0($sp)
	sw $s6, 4($sp)
	jal add_tail_segment
	lw $s5, 0($sp)
	lw $s6, 4($sp)
	addi $sp, $sp, 8
	li $t0, -1
	move $t1, $v0
	bne $t0, $t1, doneWith8Successful
	addi $s5, $s5, 1
	j tryLeft
	
	
doneWith8Successful:
	lbu $v0, 4($s0)
	j doneWith8
	
doneWith8Failed:
	li $v0, -1
	
doneWith8:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32
    jr $ra

move_snake:
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	move $s0, $a0		#GameStates
	move $s1, $a1		#Direction
	move $s2, $a2		#apples[]
	move $s3, $a3		#apples.length
	li $t0, 'U'
	beq $t0, $s1, loadUpCoordinates
	li $t0, 'L'
	beq $t0, $s1, loadLeftCoordinates
	li $t0, 'D'
	beq $t0, $s1, loadDownCoordinates
	li $t0, 'R'
	beq $t0, $s1, loadRightCoordinates
	j doneWith9Failed

loadUpCoordinates:
	li $s4, -1
	li $s5, 0
	j continue9

loadDownCoordinates:
	li $s4, 1
	li $s5, 0
	j continue9

loadLeftCoordinates:
	li $s4, 0
	li $s5, -1
	j continue9

loadRightCoordinates:
	li $s4, 0
	li $s5, 1
	j continue9
	
continue9:
	move $a0, $s0
	move $a1, $s4
	move $a2, $s5
	move $a3, $s2
	addi $sp, $sp, -4
	sw $s3, 0($sp)
	jal slide_body
	addi $sp, $sp, 4
	move $t0, $v0
	li $t1, -1
	beq $t0, $t1, doneWith9Failed
	li $t1, 0
	beq $t0, $t1, movedOverNothing
	li $t1, 1
	beq $t0, $t1, ateAnApple
	j doneWith9Failed
	
ateAnApple:
	move $a0, $s0
	move $a1, $s1
	jal increase_snake_length
	move $t0, $v0
	li $t1, -1
	beq $t0, $t1, doneWith9Failed
	li $v0, 100
	li $v1, 1
	j doneWith9
	
movedOverNothing:
	li $v0, 0
	li $v1, 1
	j doneWith9
	
doneWith9Failed:
	li $v0, 0
	li $v1, -1
	j doneWith9
	
doneWith9:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28

    jr $ra

simulate_game:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, -36
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra 32($sp)
	move $s0, $a0		#GameState
	move $s1, $a1		#Filename
	move $s2, $a2		#String directions
	move $s3, $a3		#num of moves to execute
	move $s4, $t0 		#apples[]
	move $s5, $t1		#apples.length
	
	move $a0, $s0
	move $a1, $s1
	jal load_game
	move $t0, $v0
	li $s6, 0	#score
	li $s7, 0	#moves made
	li $t1, -1
	beq $t0, $t1, doneWith10Failed
	li $t1, 0
	beq $t0, $t1, placeAppleOnGrid
	j continue10
	
placeAppleOnGrid:
	move $a0, $s0
	move $a1, $s4
	move $a2, $s5
	jal place_next_apple

continue10:
	lbu $t0, 0($s2)		#direction
	beqz $t0, returnScore
	beqz $s3, returnScore
	lbu $t1, 4($s0)
	li $t2, 35
	beq $t2, $t1, returnScore
	move $a0, $s0
	move $a1, $t0
	move $a2, $s4
	move $a3, $s5
	jal move_snake
	move $t0, $v0
	move $t1, $v1
	li $t2, 100
	beq $t2, $t0, add100ToScore
	li $t2, 1
	bne $t1, $t2, returnScore
	addi $s2, $s2, 1
	addi $s3, $s3, 1
	addi $s7, $s7, 1
	j continue10
	
add100ToScore:
	li $t0, 100
	lbu $t1, 4($s0)
	addi $t1, $t1, -1
	mult $t1, $t0
	mflo $t0
	add $s6, $s6, $t0
	addi $s2, $s2, 1
	addi $s3, $s3, -1
	addi $s7, $s7, 1
	j continue10
	
	
returnScore:
	move $v0, $s7
	move $v1, $s6
	j doneWith10
	
doneWith10Failed:
	li $v0, -1
	li $v1, -1
	j doneWith10

doneWith10:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
