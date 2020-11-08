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
	sw $s1, 4($sp)
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
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $ra, 28($sp)
	move $s0, $a0		#Hashtable books
	move $s1, $a1		#String isbn
	lw $s2, 0($s0)		#Capacity
	lw $s3, 4($s0)		#size
	lw $s4, 8($s0)		#Element size
	move $a0, $s0
	move $a1, $s1
	jal hash_book
	move $t0, $v0
	move $s5, $v0
	mult $t0, $s4
	mflo $t1
	addi $t0, $s0, 12
	add $t0, $t0, $t1
	move $a0, $s1
	move $a1, $t0
	jal strcmp
	move $t0, $v0
	li $t1, 0
	beq $t0, $t1, foundAtHash
	li $t1, 13
	beq $t0, $t1, emptyAtHash
	li $s5, 0		#indexAt
	addi $s0, $s0, 12
findBook:
	beq $s5, $s2, doneWith5Failed
	move $a0, $s1
	move $a1, $s0
	jal strcmp
	addi $s5, $s5, 1
	move $t0, $v0
	li $t1, 0
	beq $t0, $t1, doneWith5Successful
	li $t1, 13
	beq $t0, $t1, skipBook
	addi $s6, $s6, 1		#Elements checked
	add $s0, $s0, $s4
	j findBook
	
skipBook:
	add $s0, $s0, $s4
	j findBook
	
doneWith5Failed:
	li $v0, -1
	move $v1, $s6
	j doneWith5
	
doneWith5Successful:
	move $v0, $s6
	move $v1, $s5
	j doneWith5
	
emptyAtHash:
	li $v0, -1
	li $v1, 1
	j doneWith5
	
foundAtHash:
	move $v0, $s5
	li $v1, 1
	j doneWith5
	
doneWith5:
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

add_book:
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
	move $s0, $a0		#Hashtable
	move $s1, $a1		#ISBN
	move $s2, $a2		#title
	move $s3, $a3		#author
	lw $t0, 0($s0)
	lw $t1, 4($s0)
	beq $t0, $t1, tableFull
	move $a0, $s0
	move $a1, $s1
	jal get_book
	move $t0, $v0
	li $t1, -1
	bne $t0, $t1, doneWith6
	move $a0, $s0
	move $a1, $s1
	jal hash_book
	move $s4, $v0		#index
	lw $t0, 8($s0)		#element size
	mult $s4, $t0
	mflo $t1
	addi $s5, $s0, 12	#books.elements[0]
	addi $t0, $s0, 12
	add $t0, $t0, $t1	#books.elements[hashed_value]
	lbu $t1, 0($t0)
	li $t2, '9'
	bne $t1, $t2, placeBookInTable
	li $s7, 1
	lw $t1, 0($s0)		#capacity
	addi $t1, $t1, -1
	lw $t2, 8($s0)		#element size
	sub $t3, $t1, $s4
	add $t0, $t0, $t2	#books.elements[hashed + 1]
findSlot:
	beq $s4, $t1, wrapAround
	lb $t5, 0($t0)
	addi $s4, $s4, 1
	addi $s7, $s7, 1
	li $t4, '9'
	bne $t4, $t5, placeBookInTable
	add $t0, $t0, $t2
	j findSlot
	
wrapAround:
	li $s4, 0
findSlotAfterWrap:
	lb $t5, 0($s5)
	addi $s4, $s4, 1
	addi $s7, $s7, 1
	li $t4, '9'
	bne $t4, $t5, placeBookInTable
	add $t0, $t0, $t2
	j findSlotAfterWrap
	
	
placeBookInTable:
	move $a0, $t0
	move $s6, $t0
	move $a1, $s1
	li $a2, 14
	jal memcpy		#might not work due to null term not being there
	move $t0, $s6
	addi $t0, $t0, 14	#book.title
	#addi $s7, $s7, 1		#number of elements checked
	li $t1, 24
	li $t2, 0
	li $t3, 0
	move $t6, $t0
writeInZerosTitle:
	beq $t1, $t2, writeInTitle
	sb $t3, 0($t0)
	addi $t0, $t0, 1
	addi $t2, $t2, 1
	j writeInZerosTitle	
writeInTitle:
	move $a0, $t6
	move $a1, $s2
	li $a2, 24
	jal memcpy
	move $t0, $t6
	addi $t0, $t0, 25	#book.author
	li $t1, 24
	li $t2, 0
	li $t3, 0
	move $t6, $t0
writeInZerosAuthor:
	beq $t1, $t2, writeInAuthor
	sb $t3, 0($t0)
	addi $t0, $t0, 1
	addi $t2, $t2, 1
	j writeInZerosAuthor
writeInAuthor:
	move $a0, $t6
	move $a1, $s3
	li $a2, 24
	jal memcpy
	move $t0, $t6
	addi $t0, $t0, 25	#book.times_sold
	li $t1, 0
	sw $t1, 0($t0)
	j doneWith6Successful

doneWith6Successful:
	move $v0, $s4
	move $v1, $s7
	j doneWith6
		
tableFull:
	li $v0, -1
	li $v1, -1
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

delete_book:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	move $s0, $a0		#Hashtable
	move $s1, $a1		#ISBN
	jal get_book
	move $t0, $v0
	move $s2, $v0
	move $s3, $s0
	li $t1, -1
	beq $t0, $t1, doneWith7Failed
	lw $t1, 8($s0)		#element size
	lw $s4, 4($s0)		
	mult $t0, $t1
	mflo $t0
	addi $s0, $s0, 12
	add $s0, $s0, $t0	#books.elements[hashed_value]
	li $t2, 0		#index
	li $t3, -1
fillNeg1s:
	beq $t2, $t1, decrementSize
	sb $t3, 0($s0)
	addi $s0, $s0, 1
	addi $t2, $t2, 1
	j fillNeg1s
	
decrementSize:
	addi $s4, $s4, -1
	sw $s4, 4($s3)
	move $v0, $s2
	j doneWith7

doneWith7Failed:
	li $v0, -1
	j doneWith7
	
doneWith7:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
    jr $ra

hash_booksale:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	move $s0, $a0		#hashTable
	move $s1, $a1		#ISBN
	move $s2, $a2		#ID
	li $t0, 0		#Total sum
	lw $t1, 0($s0)		#capacity
loopISBNValues:
	lbu $t2, 0($s1)
	beqz $t2, countCustID
	add $t0, $t0, $t2
	addi $s1, $s1, 1
	j loopISBNValues
	
countCustID:
	li $t2, 10
loopCustID:
	div $s2, $t2
	mflo $s2	
	mfhi $t3	#remainder
	add $t0, $t0, $t3
	beqz $s2, getHashValue
	j loopCustID
	
getHashValue:
	div $t0, $t1
	mfhi $v0
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
    jr $ra

is_leap_year:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	move $s0, $a0		#year
	li $t0, 1582
	bgt $t0, $s0, doneWith9Failed
	li $t0, 4
	li $t1, 400
	li $t2, 100
	li $t3, 0
checkLeapYear:
	div $s0, $t2
	mfhi $t4
	beqz $t4, checkCentury
	div $s0, $t0
	mfhi $t4
	beqz $t4, checkIfValid
	addi $t3, $t3, 1
	addi $s0, $s0, 1
	j checkLeapYear

checkCentury:
	div $s0, $t1
	mfhi $t4
	beqz $t4, checkIfValid
	addi $t3, $t3, 1
	addi $s0, $s0, 1
	j checkLeapYear
	
checkIfValid:
	bgtz $t3, negResult
	li $v0, 1
	j doneWith9

negResult:
	li $t0, -1
	mult $t3, $t0
	mflo $v0
	j doneWith9
	
doneWith9Failed:
	li $v0, 0
	
doneWith9:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
    jr $ra

datestring_to_num_days:
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
	move $s0, $a0		#Date 1
	move $s1, $a1		#Date 2
	addi $sp, $sp, -48	#creating room on the stack for days past according to month
	move $fp, $sp
	li $t0, 0
	sw $t0, 0($sp)		#jan
	li $t0, 31
	sw $t0, 4($sp)		#feb
	li $t0, 59
	sw $t0, 8($sp)		#mar
	li $t0, 90
	sw $t0, 12($sp)		#april
	li $t0, 120
	sw $t0, 16($sp)		#may
	li $t0, 151
	sw $t0, 20($sp)		#june
	li $t0, 181
	sw $t0, 24($sp)		#july
	li $t0, 212
	sw $t0, 28($sp)		#aug
	li $t0, 243
	sw $t0, 32($sp)		#sept
	li $t0, 273
	sw $t0, 36($sp)		#oct
	li $t0, 304
	sw $t0, 40($sp)		#nov
	li $t0, 334
	sw $t0, 44($sp)		#dec
convertYearToNumberDate1:
	li $t0, 1000
	lbu $t1, 0($s0)		
	addi $t1, $t1, -48
	mult $t0, $t1
	mflo $s2		#placing thousands place into s2	s2 holds year for date 1
	li $t0, 100
	lbu $t1, 1($s0)
	addi $t1, $t1, -48
	mult $t0, $t1
	mflo $t1
	add $s2, $s2, $t1	#adding 100's place onto s2
	li $t0, 10
	lbu $t1, 2($s0)
	addi $t1, $t1, -48
	mult $t0, $t1
	mflo $t1
	add $s2, $s2, $t1	#adding 10's place into s2
	lbu $t1, 3($s0)
	addi $t1, $t1, -48
	add $s2, $s2, $t1	#adding 1's place into s2 
convertMonthToNumberDate1:
	li $t0, 10
	lbu $t1, 5($s0)
	addi $t1, $t1, -48
	mult $t0, $t1
	mflo $s3
	lbu $t1, 6($s0)
	addi $t1, $t1, -48
	add $s3, $s3, $t1	#adding 1's place into s3
convertDayToNumverDate1:
	li $t0, 10
	lbu $t1, 8($s0)
	addi $t1, $t1, -48
	mult $t0, $t1
	mflo $s4
	lbu $t1, 9($s0)
	addi $t1, $t1, -48
	add $s4, $s4, $t1	#adding 1's place into s4
	li $s5, 1600
	li $s6, 0
daysFromFirstDateYear:
	bgt $s5, $s2, daysFromFirstDateMonth
	move $a0, $s5
	jal is_leap_year
	move $t0, $v0
	li $t1, 1
	beq $t0, $t1, addLeapYear 
	addi $s6, $s6, 365
	addi $s5, $s5, 1
	j daysFromFirstDateYear
	
addLeapYear:
	addi $s6, $s6, 366
	addi $s5, $s5, 1
	j daysFromFirstDateYear

daysFromFirstDateMonth:
	move $t0, $fp
	li $t3, 4
	addi $s3, $s3, -1
	mult $t3, $s3
	mflo $s3
	add $t0, $t0, $s3
	lw $t1, 0($t0)
	add $s6, $s6, $t1
	li $t0, 1
daysFromFirstDateDays:
	beq $t0, $s4, daysFromFirstDate
	addi $s6, $s6, 1
	addi $t0, $t0, 1
	j daysFromFirstDateDays
	
daysFromFirstDate:
	move $s2, $s6

convertYearToNumberDate2:
	li $t0, 1000
	lbu $t1, 0($s1)		
	addi $t1, $t1, -48
	mult $t0, $t1
	mflo $s3		#placing thousands place into s3	s2 holds year for date 2
	li $t0, 100
	lbu $t1, 1($s1)
	addi $t1, $t1, -48
	mult $t0, $t1
	mflo $t1
	add $s3, $s3, $t1	#adding 100's place onto s3
	li $t0, 10
	lbu $t1, 2($s1)
	addi $t1, $t1, -48
	mult $t0, $t1
	mflo $t1
	add $s3, $s3, $t1	#adding 10's place into s3
	lbu $t1, 3($s1)
	addi $t1, $t1, -48
	add $s3, $s3, $t1	#adding 1's place into s3
convertMonthToNumberDate2:
	li $t0, 10
	lbu $t1, 5($s1)
	addi $t1, $t1, -48
	mult $t0, $t1
	mflo $s4
	lbu $t1, 6($s1)
	addi $t1, $t1, -48
	add $s4, $s4, $t1	#adding 1's place into s4
convertDayToNumverDate2:
	li $t0, 10
	lbu $t1, 8($s1)
	addi $t1, $t1, -48
	mult $t0, $t1
	mflo $s5
	lbu $t1, 9($s1)
	addi $t1, $t1, -48
	add $s5, $s5, $t1	#adding 1's place into s5
	li $s6, 1600
	li $s7, 0
daysFromSecondDateYear:
	bgt $s6, $s3, daysFromSecondDateMonth
	move $a0, $s6
	jal is_leap_year
	move $t0, $v0
	li $t1, 1
	beq $t0, $t1, addLeapYear2
	addi $s7, $s7, 365
	addi $s6, $s6, 1
	j daysFromSecondDateYear
	
addLeapYear2:
	addi $s7, $s7, 366
	addi $s6, $s6, 1
	j daysFromSecondDateYear

daysFromSecondDateMonth:
	move $t0, $fp
	li $t3, 4
	addi $s4, $s4, -1
	mult $t3, $s4
	mflo $s4
	add $t0, $t0, $s4
	lw $t1, 0($t0)
	add $s7, $s7, $t1
	li $t0, 1
daysFromSecondDateDays:
	beq $t0, $s5, daysFromSecondDate
	addi $s7, $s7, 1
	addi $t0, $t0, 1
	j daysFromSecondDateDays
	
daysFromSecondDate:
	move $s3, $s7

finalCalculation:
	bgt $s2, $s3, doneWith10Failed
	sub $v0, $s3, $s2
	j doneWith10
	
doneWith10Failed:
	li $v0, -1
	
doneWith10:
	addi $sp, $sp, 48
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

sell_book:
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
	sw $ra, 32($sp)
	move $s0, $a0		#Sales Hashtable
	move $s1, $a1		#Books Hashtable
	move $s2, $a2		#ISBN
	move $s3, $a3		#cust ID
	move $s4, $t0		#sale_date
	move $s5, $t1		#sale_price
	lw $t0, 0($s0)
	lw $t1, 4($s0)
	beq $t0, $t1, doneWith11Full
	addi $sp, $sp, -4
	li $t0, '1'
	sb $t0, 0($sp)
	addi $t0, $t0, 1
	li $t0, '6'
	sb $t0, 0($sp)
	addi $t0, $t0, 1
	li $t0, '6'
	sb $t0, 0($sp)
	addi $t0, $t0, 1
	li $t0, '6'
	sb $t0, 0($sp)
	addi $t0, $t0, 1
	li $t0, '6'
	sb $t0, 0($sp)
	addi $t0, $t0, 1
	li $t0, '6'
	sb $t0, 0($sp)
	addi $t0, $t0, 1
	li $t0, '6'
	sb $t0, 0($sp)
	addi $t0, $t0, 1
	li $t0, '6'
	sb $t0, 0($sp)
	addi $t0, $t0, 1
	li $t0, '6'
	sb $t0, 0($sp)
	addi $t0, $t0, 1
	li $t0, '6'
	sb $t0, 0($sp)
	addi $t0, $t0, 1
	li $t0, '\0'
	sb $t0, 0($sp)
	#li $t0, "1600-01-01"
	move $a0, $sp
	move $a1, $s4
	jal datestring_to_num_days
	move $s4, $v0
updateTimes_sold:
	move $a0, $s1
	move $a1, $s2
	jal get_book
	move $t0, $v0
	li $t1, -1
	beq $t0, $t1, doneWith11BookDNE
	addi $t1, $s1, 12
	lw $t2, 8($s1)		#element size for books
	mult $t0, $t2
	mflo $t2
	add $t1, $t1, $t2
	addi $t1, $t1, 64
	lw $t0, 0($t1)
	addi $t0, $t0, 1
	sw $t0, 0($t1)
getHashedBookSale:
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	jal hash_booksale
	move $s6, $v0		#index
	lw $t1, 8($s0)		#element size for booksale
	addi $t2, $s0, 12	#sales.elements[0]
	mult $s6, $t1
	mflo $t3
	add $t2, $t2, $t3	#sales.elements[hashed_value]
	lbu $t3, 0($t2)
	li $t4, '9'
	li $s7, 1		#number of elements checked
	beq $t3, $t4, beginProbing
	move $a0, $t2
	move $a1, $s2
	li $a2, 14
	jal memcpy
	addi $t2, $t2, 16	#sales.elements[hashed_value].custID
	sw $s3, 0($t2)
	addi $t2, $t2, 4
	sw $s4, 0($t2)
	addi $t2, $t2, 4
	sw $s5, 0($t2)
	j getResult
	
beginProbing:
	lw $t4, 0($s0)		#capacity
probingBookSale:
	add $t2, $t2, $t1
	addi $s6, $s6, 1
	beq $s6, $t4, wrapBookSale
	addi $s7, $s7, 1		#MIGHT BE A PROBLEM HERE
	lbu $t3, 0($t2)
	li $t5, '9'
	bne $t3, $t5, placeSale
	j probingBookSale
	
wrapBookSale:
	li $s6, 0
	move $t2, $s0
	addi $t2, $t2, 12
continueProbingSale:
	lbu $t3, 0($t2)
	li $t5, '9'
	addi $s7, $s7, 1
	bne $t3, $t5, placeSale
	add $t2, $t2, $t1
	addi $s6, $s6, 1
	j continueProbingSale
	
placeSale:
	move $a0, $t2
	move $a1, $s2
	li $a2, 14
	jal memcpy
	addi $t2, $t2, 16	#sales.elements[hashed_value].custID
	sw $s3, 0($t2)
	addi $t2, $t2, 4
	sw $s4, 0($t2)
	addi $t2, $t2, 4
	sw $s5, 0($t2)
	
getResult:
	move $v0, $s6
	move $v1, $s7
	j doneWith11

doneWith11BookDNE:
	li $v0, -2
	li $v1, -2
	j doneWith11
	
doneWith11Full:
	li $v0, -1
	li $v1, -1
	j doneWith11
	
doneWith11:
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

compute_scenario_revenue:
    jr $ra

maximize_revenue:
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
