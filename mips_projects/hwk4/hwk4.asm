# Mark Moawad
# msmoawad
# 112198934

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text
memcpy:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	move $s0, $a0	#dest[]
	move $s1, $a1	#src[]
	move $s2, $a2	#int n
	blez $s2, doneWith1Failed
	li $t0, 0
loopCopy:
	beq $t0, $s2, doneWith1Successful
	lbu $t1, 0($s1)
	sb $t1, 0($s0)
	addi $t0, $t0, 1
	addi $s1, $s1, 1
	addi $s0, $s0, 1
	j loopCopy
	
doneWith1Successful:
	move $v0, $s2
	j doneWith1
	
doneWith1Failed:
	li $v0, -1
	
doneWith1:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
    jr $ra

strcmp:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s0, 4($sp)
	move $s0, $a0	#Str1
	move $s1, $a1	#Str2
	lbu $t0, 0($s0)
	lbu $t1, 0($s1)
	beqz $t0, string1Empty
	li $t2, 0
	beqz $t1, countStr1
compareStrings:
	lbu $t0, 0($s0)
	lbu $t1, 0($s1)
	bne $t0, $t1, getDifference
	beqz $t1, return0
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j compareStrings
	
getDifference:
	sub $v0, $t0, $t1
	j doneWith2
	
countStr1:
	lbu $t0, 0($s0)
	beqz $t0, returnStr1Length
	addi $s0, $s0, 1
	addi $t2, $t2, 1
	j countStr1
	
string1Empty:
	beqz $t1, return0
	li $t2, 0
	j countStr2
	
countStr2:
	lbu $t1, 0($s1)
	beqz $t1, invertStr2
	addi $s1, $s1, 1
	addi $t2, $t2, 1
	j countStr2
	
invertStr2:
	li $t0, -1
	mult $t0, $t2
	mflo $v0
	j doneWith2
	
returnStr1Length:
	move $v0, $t2
	j doneWith2
	
return0:
	li $v0, 0
	
doneWith2:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	
    jr $ra

initialize_hashtable:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	move $s0, $a0	#hashtable
	move $s1, $a1	#capacity
	move $s2 $a2	#element_size
	li $t0, 1
	blt $s1, $t0, doneWith3Failed
	blt $s2, $t0, doneWith3Failed
	li $t0, 0
	sw $s1, 0($s0)
	sw $t0, 4($s0)
	sw $s2, 8($s0)
	addi $s0, $s0, 12
	mult $s1, $s2
	mflo $t0
	li $t1, 0
	li $t2, 0	#index
	
initHashtable:
	beq $t0, $t2, doneWith3Successful
	sb $t1, 0($s0)
	addi $s0, $s0, 1
	addi $t2, $t2, 1
	j initHashtable
	
doneWith3Successful:
	li $v0, 0
	j doneWith3
	
doneWith3Failed:
	li $v0, -1
	
doneWith3:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	
    jr $ra

hash_book:
	addi $sp, $sp, -8
	sw $s0 0($sp)
	sw $s1, 4($sp)
	move $s0, $a0	#hashtable
	move $s1, $a1	#isbn
	li $t0, 0	#total ascii value
loopISBN:	
	lbu $t1, 0($s1)
	beqz $t1, getHash
	add $t0, $t0, $t1
	addi $s1, $s1, 1
	j loopISBN
	
getHash:
	lw $t1, 0($s0)
	div $t0, $t1
	mfhi $v0
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8

    jr $ra

get_book:
    jr $ra

add_book:
    jr $ra

delete_book:
    jr $ra

hash_booksale:
    jr $ra

is_leap_year:
    jr $ra

datestring_to_num_days:
    jr $ra

sell_book:
    jr $ra

compute_scenario_revenue:
    jr $ra

maximize_revenue:
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
