# erase this line and type your first and last name here in a comment
# erase this line and type your Net ID here in a comment (e.g., jmsmith)
# erase this line and type your SBU ID number here in a comment (e.g., 111234567)

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text

init_list:
	move $t0, $a0
	sw $0, 0($t0)
	sw $0, 4($t0)
   jr $ra

append_card:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	move $s0, $a0		#card_list
	move $s1, $a1		#card_num
	li $v0, 9
	li $a0, 8
	syscall
	move $s2, $v0
	sw $s1, 0($s2)		#init new node
	sw $0, 4($s2)		#init new node
	lw $t0, 0($s0)
	bgtz $t0, updateLastNode
	li $t0, 1
	sw $t0, 0($s0)
	sw $s2, 4($s0)
	move $v0, $t0
	j doneWith2
updateLastNode:
	lw $t0, 4($s0)		#address of head node
	move $t1, $t0
loopToLastNode:
	lw $t0, 4($t0)
	beqz $t0, foundLastNode
	move $t1, $t0
	j loopToLastNode

foundLastNode:
	sw $s2, 4($t1)
	lw $t0, 0($s0)
	addi $t0, $t0, 1
	sw $t0, 0($s0)
	move $v0, $t0
doneWith2:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
   jr $ra

create_deck:
	addi $sp, $sp, -36
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	li $a0, 8
	li $v0, 9
	syscall 
	move $a0, $v0
	move $s0, $v0		#Card List
	jal init_list
	li $s1, 0x00645330
	li $s2, 80
	li $s3, 0x0064533a	#ascii value 58 bc '9' is 57
	li $s4, 0	#index
	move $s5, $s1
loopFill:
	beq $s4, $s2, deckFilled
	move $a0, $s0
	move $a1, $s1
	jal append_card
	addi $s4, $s4, 1
	addi $s1, $s1, 1
	beq $s1, $s3, resetNUM
	j loopFill
	
resetNUM:
	move $s1, $s5
	j loopFill
	
deckFilled:
	move $v0, $s0
doneWith3:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36 
   jr $ra

deal_starting_cards:
	addi $sp, $sp, -36
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	move $s0, $a0		#board[0]
	move $s1, $a1		#deck
	li $s2, 44
	li $s3, 0		#index
	move $s4, $s0		#copy of board[0]
	li $s6, 0
	li $s7, 9
	lw $t0, 4($s1)		#gets head node from deck
loopDealing:
	li $t4, 34
	beq $s3, $s2, changeHeadNode
	beq $s6, $s7, resetBoardPos
	bgt $s3, $t4, dealFaceUp
	lw $t3, 0($s0)
continueDealing:
	move $a0, $t3
	lw $t1, 0($t0)		#node.num
	lw $s5, 4($t0)		#node.nextNode
	sw $0, 4($t0)
	move $a1, $t1
	jal append_card
	lw $t2, 0($s1)
	addi $t2, $t2, -1		#size - 1 in deck
	sw $t2, 0($s1)
	addi $s3, $s3, 1
	addi $s6, $s6, 1
	addi $s0, $s0, 4
	move $t0, $s5
	j loopDealing
	
resetBoardPos:
	li $s6, 0
	move $s0, $s4
	j loopDealing
	
dealFaceUp:
	lw $t3, 0($s0)
	li $t4, 'u'
	sb $t4, 2($s5)
	j continueDealing
	
changeHeadNode:
	sw $s5, 4($s1)

doneWith4:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
   jr $ra

get_card:
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	move $s0, $a0		#card_list
	move $s1, $a1		#index to find at
	li $t1, 0		#loop index
	lw $t0, 0($s0)
	addi $t0, $t0, -1
	bgt $s1, $t0, doneWith5Failed
	lw $t0, 4($s0)		#head node
loopIndex:
	beq $t1, $s1, foundNum
	lw $t0, 4($t0)
	addi $t1, $t1, 1
	j loopIndex
	
foundNum:
	li $t2, 0x00645339
	lw $t3, 0($t0)	
	bgt $t3, $t2, cardIsUp
	li $v0, 1
	move $v1, $t3
	j doneWith5
	
cardIsUp:
	li $v0, 2
	move $v1, $t3
	j doneWith5
	
	
	
doneWith5Failed:
	li $v0, -1
	li $v1, -1
	j doneWith5
	
doneWith5:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	addi $sp, $sp, 28
	
    jr $ra

check_move:
	addi $sp, $sp, -36
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	move $s0, $a0		#board[]
	move $s1, $a1		#deck
	move $s2, $a2		#move
checkAllCases:
	srl $t0, $a2, 24
	li $t1, 0x11
	and $t0, $t0, $t1
	li $t1, 1
	beq $t1, $t0, checkOtherBytes
	bnez $t0, notValid
	j checkDonorColumn
	
checkOtherBytes:	#gets to here after seeing that the 3rd byte is 1
	li $t2, 0x11
	and $t1, $a2, $t2
	bnez $t1, notValid
	srl $t1, $a2, 8
	and $t1, $t1, $t2
	bnez $t1, notValid
	srl $t1, $a2, 16
	and $t1, $t1, $t2
	bnez $t1, notValid
	j checkIfDeckEmpty
	
checkIfDeckEmpty:
	lw $t1, 0($s1)
	beqz $t1, deckEmpty
	j legalDealMove
	
	
checkDonorColumn:
	andi $t0, $a2, 0xFF
	bltz $t0, invalidDonCol
	li $t1, 8
	bgt $t0, $t1, invalidDonCol
	j checkDonRow
	
checkDonRow:
	andi $t0, $a2, 0xFF
	li $t1, 4
	mult $t0, $t1
	mflo $t1
	add $t1, $t1, $s0
	lw $s3, 0($t1)		#size of selected column
	srl $s4, $a2, 8
	andi $s4, $s4, 0xFF
	addi $s3, $s3, -1
	bgt $s4, $s3, invalidDonRow
	bltz $s4, invalidDonRow
					#LEFT OFF HERE
	
notValid:
	li $v0, -1
	j doneWith6
	
deckEmpty:
	li $v0, -2
	j doneWith6
	
invalidDonCol:
	li $v0, -3
	j doneWith6
	
invalidDonRow:
	li $v0, -4
	j doneWith6
	
legalDealMove:
	li $v0, 1
	j doneWith6
	
doneWith6:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
    jr $ra

clear_full_straight:
    jr $ra

deal_move:
    jr $ra

move_card:
    jr $ra

load_game:
    jr $ra

simulate_game:
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
