# Mark Moawad
# msmoawad
# 112198934

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
addr_arg5: .word 0
addr_arg6: .word 0
addr_arg7: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Output messages
big_bobtail_str: .asciiz "BIG_BOBTAIL\n"
full_house_str: .asciiz "FULL_HOUSE\n"
five_and_dime_str: .asciiz "FIVE_AND_DIME\n"
skeet_str: .asciiz "SKEET\n"
blaze_str: .asciiz "BLAZE\n"
high_card_str: .asciiz "HIGH_CARD\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Put your additional .data declarations here, if any.


# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
    li $t0, 2
    beq $a0, $t0, two_args
    li $t0, 3
    beq $a0, $t0, three_args
    li $t0, 4
    beq $a0, $t0, four_args
    li $t0, 5
    beq $a0, $t0, five_args
    li $t0, 6
    beq $a0, $t0, six_args
seven_args:
    lw $t0, 24($a1)
    sw $t0, addr_arg6
six_args:
    lw $t0, 20($a1)
    sw $t0, addr_arg5
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here

zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
    lw $s0, addr_arg0	#Loading word into s0
    addi $t0, $s0, 1	#s0 at index 1
    lbu $t1, 0($t0)
    bnez $t1, invalidOperation
    lbu $t0, 0($s0)	#addr_args at index 0
    addi $t1, $0, 0x31	
    beq $t0, $t1, case12S	#case 1
    addi $t1, $0, 0x32	
    beq $t0, $t1, case12S	#case 2
    addi $t1, $0, 0x53
    beq $t0, $t1, case12S	#case S
    addi $t1, $0, 0x46
    beq $t0, $t1, caseF	#case F
    addi $t1, $0, 0x52
    beq $t0, $t1, caseR	#case R
    addi $t1, $0, 0x50
    beq $t0, $t1, caseP	#case P
    j invalidOperation
    
case12S:
	addi $t0, $0, 3
	lw $t1, num_args
	bne $t0, $t1, invalidArgs
	lw $s0, addr_arg1	#loading 2nd arg into s0
	addi $t6, $0, 0		#index
	addi $t5, $0, 4		#number of loops
	li $s1, 0		#clearing S registers for garbage Data
	li $s2, 0
	li $s3, 0
	
stringToHex09:
	beq $t6, $t5, HexToBinary		#branch once number is fully converted from string to hex
	lbu $t0, 0($s0)
	addi $t1, $0, 0x30
	blt $t0, $t1, invalidArgs	#checking if first bit is less than char 0 on ascii table
	addi $t1, $0, 0x39
	bgt $t0, $t1, stringToHexAF	#branch if ascii value is greater than 39 or 9
	addi $t1, $0, 48
	sub $s1, $t0, $t1	#s1 is a digit from addr_arg1 converted from string to hex
	addi $t0, $0, 15
	bgt $s1, $t0, invalidArgs	#checking if digit is greater than 15 if so it's invalid
	add $s2, $s2, $s1
	addi $t2, $0, 3
	bne $t2, $t6, shiftLeft		#last digit doesn't get shifted so it branches on the first 3 cases
	addi $t6, $t6, 1
	addi $s0, $s0, 1
	j stringToHex09
	
shiftLeft:
	sll $s2, $s2, 4		#after the number is converted shift it to the left
	addi $t6, $t6, 1	#only does this 3 times so the last one is placed in the last 4 bits
	addi $s0, $s0, 1
	j stringToHex09
	
stringToHexAF:			#if ascii value is greater than 39 
	addi $t1, $0, 55	
	sub $s1, $t0, $t1
	addi $t0, $0, 15		
	bgt $s1, $t0, invalidArgs
	add $s2, $s2, $s1
	addi $t2, $0, 3
	bne $t6, $t2, shiftLeft
	addi $t6, $t6, 1
	addi $s0, $s0, 1
	j stringToHex09
	

HexToBinary:		#convert arg2 to an int
	lw $t0, addr_arg2
	addi $t1, $0, 48
	lbu $t2, 0($t0)
	sub $t3, $t2, $t1
	addi $t1, $0, 10
	mult $t3, $t1
	mflo $t3
	addi $t0, $t0, 1
	lbu $t2, 0($t0)
	addi $t1, $0, 48
	sub $t0, $t2, $t1
	add $t3, $t3, $t0
	addi $t1, $0, 16
	blt $t3, $t1, invalidArgs
	addi $t1, $0, 32
	bgt $t3, $t1, invalidArgs
	addi $t6, $0, 0		#index
	li $t2, 32
	addi $t4, $0, 16	#sign extend
	sll $s2, $s2, 16
	sra $s2, $s2, 16
	lw $t1, addr_arg0
	lbu $t1, 0($t1)		
	li $t0, 49
	beq $t1, $t0, onesCompNeg	#branch to convert to 1's comp
	li $t0, 50
	beq $t1, $t0, twosComp		#branch to convert to 2's comp
	j signedNeg			##branch to convert to signed
	
onesCompNeg:
	li $t0, 8
	srl $s3, $s2, 12	
	blt $s3, $t0, onesCompPos	#branch if positive
	addi $s2, $s2, 1	#add one if neg
	addi $t0, $0, 32
	j printEmpty		#branch to decrement counter until you reach arg2
	
	
onesCompPos:
	addi $t0, $0, 32	#index
	j printEmpty		#branch to decrement counter until you reach arg2

twosComp:
	addi $t0, $0, 32
	j printEmpty		#branch to decrement counter until you reach arg2
signedNeg:
	li $t0, 8
	srl $s3, $s2, 12
	blt $s3, $t0, signedPos		#branch to pos Signed
	li $t0, 0x7FFF		
	xor $s2, $t0, $s2		#flip bits 
	addi $s2, $s2, 1		#add one
	addi $t0, $0, 32
	j printEmpty			#branch to decrement counter until you reach arg2
	
signedPos:
	addi $t0, $0, 32
	j printEmpty			#branch to decrement counter until you reach arg2
	
printEmpty:				#Loop that decrements until you reach the 
	beq $t0, $t3, printLoop
	rol $s2, $s2, 1
	addi $t0, $t0, -1
	j printEmpty
	
printLoop:				#loop that gets the left most bit, masks it, and prints it
	beq $t6, $t3, finishQuestion
	addi $t0, $0, 0x1
	rol $s2, $s2, 1
	and $t5, $s2, $t0
	addi $t5, $t5, 48
	move $a0, $t5
	li $v0, 11
	syscall
	addi $t6, $t6, 1
	j printLoop

caseF:
	addi $t0, $0, 2
	lw $t1, num_args
	bne $t0, $t1, invalidArgs
	lw $s0, addr_arg1
	lbu $t0, 0($s0)
	li $t1, 48
	sub $t0, $t0, $t1
	li $t1, 100
	mult $t0, $t1
	mflo $s1
	addi $s0, $s0, 1
	lbu $t0, 0($s0)
	li $t1, 48
	sub $t0, $t0, $t1
	li $t1, 10
	mult $t0, $t1
	mflo $t0
	add $s1, $s1, $t0
	addi $s0, $s0, 1
	lbu $t0, 0($s0)
	li $t1, 48
	sub $t0, $t0, $t1
	add $s1, $s1, $t0	#whole number converted and placed in register $s1
	addi $s0, $s0, 2	#add 2 to skip over the decimal point
	li $t4, 10000		#shift amount
	li $s2, 0
	
convertFraction:
	lbu $t0, 0($s0)
	sub $t0, $t0, $t1
	mult $t4, $t0
	mflo $t0
	add $s2, $s2, $t0
	addi $s0, $s0, 1
	li $t4, 1000
	lbu $t0, 0($s0)
	sub $t0, $t0, $t1
	mult $t4, $t0
	mflo $t0
	add $s2, $s2, $t0
	addi $s0, $s0, 1
	li $t4, 100
	lbu $t0, 0($s0)
	sub $t0, $t0, $t1
	mult $t4, $t0
	mflo $t0
	add $s2, $s2, $t0
	addi $s0, $s0, 1
	li $t4, 10
	lbu $t0, 0($s0)
	sub $t0, $t0, $t1
	mult $t4, $t0
	mflo $t0
	add $s2, $s2, $t0
	addi $s0, $s0, 1
	lbu $t0, 0($s0)
	sub $t0, $t0, $t1
	add $s2, $s2, $t0	#fraction part stored in $s2 as a whole number
	li $t0, 0x1
	li $t1, 32
	add $s3, $0, $s1
	beqz $s1, print0

emptyLoop:
	rol $s3, $s3, 1
	and $t2, $s3, $t0
	addi $t1, $t1, -1
	beq $t2, $t0, preparePrint
	j emptyLoop
	
print0:
	li $a0, 48
	li $v0, 11
	syscall
	j printRadix


preparePrint:
	ror $s3, $s3, 1
	addi $t1, $t1, 1

printDecToBinary:
	beqz $t1, printRadix
	rol $s3, $s3, 1
	and $a0, $s3, $t0
	li $v0, 1
	syscall
	addi $t1, $t1, -1
	j printDecToBinary
	
	
printRadix:
	li $a0, 46
	li $v0, 11
	syscall
	li $t0, 48	#0 ascii
	li $t1, 49	#1 ascii
	

printFraction1:
	li $t4, 50000
	sub $s3, $s2, $t4
	bltz $s3, print1st0
	move $s2, $s3
	move $a0, $t1
	syscall
printFraction2:
	li $t4, 25000
	sub $s3, $s2, $t4
	bltz $s3, print2nd0
	move $s2, $s3
	move $a0, $t1
	syscall
printFraction3:
	li $t4, 12500
	sub $s3, $s2, $t4
	bltz $s3, print3rd0
	move $s2, $s3
	move $a0, $t1
	syscall
printFraction4:
	li $t4, 6250
	sub $s3, $s2, $t4
	bltz $s3, print4th0
	move $s2, $s3
	move $a0, $t1
	syscall
printFraction5:
	li $t4, 3125
	sub $s3, $s2, $t4
	bltz $s3, print5th0
	move $s2, $s3
	move $a0, $t1
	syscall
	j finishQuestion


print1st0:
	move $a0, $t0
	syscall
	j printFraction2
	
print2nd0:
	move $a0, $t0
	syscall
	j printFraction3
	
print3rd0:
	move $a0, $t0
	syscall
	j printFraction4

print4th0:
	move $a0, $t0
	syscall
	j printFraction5

print5th0:
	move $a0, $t0
	syscall
	j finishQuestion
		
caseR:
	addi $t0, $0, 7
	lw $t1, num_args
	bne $t0, $t1, invalidArgs
	lw $s0, addr_arg1
	lw $s1, addr_arg2
	lw $s2, addr_arg3
	lw $s3, addr_arg4
	lw $s4, addr_arg5
	lw $s5, addr_arg6
	li $t0, 48
	li $t1, 10
	li $t6, 32
	lbu $t2, 0($s0)		#string to decimal arg1 
	sub $t2, $t2, $t0
	mult $t2, $t1
	mflo $t3
	addi $s0, $s0, 1
	lbu $t2, 0($s0)
	sub $t2, $t2, $t0
	add $s0, $t3, $t2	#end arg1
	lbu $t2, 0($s1)		#string to decimal arg2
	sub $t2, $t2, $t0
	mult $t2, $t1
	mflo $t3
	addi $s1, $s1, 1
	lbu $t2, 0($s1)
	sub $t2, $t2, $t0
	add $s1, $t3, $t2	
	bltz $s1, invalidArgs
	bgt $s1, $t6, invalidArgs	#end arg2
	lbu $t2, 0($s2)		#string to decimal arg3
	sub $t2, $t2, $t0
	mult $t2, $t1
	mflo $t3
	addi $s2, $s2, 1
	lbu $t2, 0($s2)
	sub $t2, $t2, $t0
	add $s2, $t3, $t2	
	bltz $s2, invalidArgs
	bgt $s2, $t6, invalidArgs	#end arg3
	lbu $t2, 0($s3)		#string to decimal arg4
	sub $t2, $t2, $t0
	mult $t2, $t1
	mflo $t3
	addi $s3, $s3, 1
	lbu $t2, 0($s3)
	sub $t2, $t2, $t0
	add $s3, $t3, $t2	
	bltz $s3, invalidArgs
	bgt $s3, $t6, invalidArgs	#end arg4
	lbu $t2, 0($s4)		#string to decimal arg5
	sub $t2, $t2, $t0
	mult $t2, $t1
	mflo $t3
	addi $s4, $s4, 1
	lbu $t2, 0($s4)
	sub $t2, $t2, $t0
	add $s4, $t3, $t2	
	bltz $s4, invalidArgs
	bgt $s4, $t6, invalidArgs	#end arg5
	lbu $t2, 0($s5)		#string to decimal arg6
	sub $t2, $t2, $t0
	mult $t2, $t1
	mflo $t3
	addi $s5, $s5, 1
	lbu $t2, 0($s5)
	sub $t2, $t2, $t0
	add $s5, $t3, $t2	
	bltz $s5, invalidArgs
	li $t6, 63
	bgt $s5, $t6, invalidArgs	#end arg6
	li $t0, 0xFFFFFFFF
	sll $s1, $s1, 21
	and $s0, $s1, $t0
	sll $s2, $s2, 16
	or $s0, $s0, $s2
	sll $s3, $s3, 11
	or $s0, $s0, $s3
	sll $s4, $s4, 6
	or $s0, $s0, $s4
	or $s0, $s0, $s5
	move $a0, $s0
	li $v0, 34
	syscall
	j finishQuestion
	
caseP:
	addi $t0, $0, 2
	lw $t1, num_args
	bne $t0, $t1, invalidArgs
	lw $t0, addr_arg1
	li $t1, -1	#index outer loop
	li $t2, 0	# index inner loop
	li $t3, 4
bubbleSortOuterLoop:
	beq $t1, $t3, bobtailCheck1
	addi $t1, $t1, 1
	li $t2, 0
	lw $t0, addr_arg1
bubbleSortInnerLoop:
	beq $t2, $t3, bubbleSortOuterLoop
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	blt $s0, $s1, increment
	sb $s0, 1($t0)
	sb $s1, 0($t0)
	addi $t2, $t2, 1
	addi $t0, $t0, 1
	j bubbleSortInnerLoop
increment:
	addi $t2, $t2, 1
	addi $t0, $t0, 1
	j bubbleSortInnerLoop

bobtailCheck1:
	lw $t0, addr_arg1
	li $t1, 0
	li $t2, 3
check1Loop:
	beq $t1, $t2, printBobtail
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	addi $s0, $s0, 1
	bne $s0, $s1, bobtailCheck2
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	j check1Loop
	
bobtailCheck2:
	lw $t0, addr_arg1
	addi $t0, $t0, 1
	li $t1, 0
	li $t2, 3
check2Loop:
	beq $t1, $t2, printBobtail
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	addi $s0, $s0, 1
	bne $s0, $s1, sortByRank
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	j check2Loop
	
sortByRank:
	lw $t0, addr_arg1
	li $t1, -1	#outerLoop index
	li $t2, 0	#innerLoop index
	li $t3, 4	#bounds
	li $t4, 16
bubblesortByRankOuterLoop:
	beq $t1, $t3, fullhouseCheck
	addi $t1, $t1, 1
	li $t2, 0
	lw $t0, addr_arg1
bubblesortByRankInnerLoop:
	beq $t2, $t3, bubblesortByRankOuterLoop
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	div $s0, $t4
	mfhi $s0,
	div $s1, $t4
	mfhi $s1
	blt $s0, $s1, incrementRankSort
	sb $s0, 1($t0)
	sb $s1, 0($t0)
	addi $t2, $t2, 1
	addi $t0, $t0, 1
	j bubblesortByRankInnerLoop
	
incrementRankSort:
	addi $t2, $t2, 1
	addi $t0, $t0, 1
	j bubblesortByRankInnerLoop
	
fullhouseCheck:
	lw $t0, addr_arg1
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	bne $s0, $s1, fiveAndDimeCheck
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	bne $s0, $s1, back3
	addi $t0, $t0, 2
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	bne $s0, $s1, fiveAndDimeCheck
	j printFullhouse
back3:
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	bne $s0, $s1, fiveAndDimeCheck
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	bne $s0, $s1, fiveAndDimeCheck
	j printFullhouse
	
fiveAndDimeCheck:
	lw $t0, addr_arg1
	li $t1, 5
	li $t2, 10
	lbu $s0, 0($t0)
	lbu $s1, 4($t0)
	bne $s0, $t1, skeetCheck
	bne $s1, $t2, checkIfGreaterThan10
	lbu $s1, 1($t0)
	beq $s0, $s1, skeetCheck
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	beq $s0, $s1, skeetCheck
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	beq $s0, $s1, skeetCheck
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	beq $s0, $s1, skeetCheck
	j printFiveAndDime	
	
checkIfGreaterThan10:
	li $t2, 9
	bgt $s1, $t2, blazeCheck
	j exit

skeetCheck:
	lw $t0, addr_arg1
	li $t1, 9
	lbu $s0, 4($t0)
	bne $s0, $t1, checkIfLessThanJack
	li $t1, 1
	lbu $s0, 0($t0)
	beq $s0, $t1, skeetCheckWith1
	li $t1, 2
	bne $s0, $t1, blazeCheck
	li $t1, 5
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	beq $s0, $t1, found5
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	beq $s0, $t1, found5
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	beq $s0, $t1, found5
	j blazeCheck

skeetCheckWith1:
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	li $t1, 2
	bne $s0, $t1, blazeCheck
	li $t1, 5
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	beq $s0, $t1, found5
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	beq $s0, $t1, found5
	j blazeCheck

found5:	
	lw $t0, addr_arg1
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	beq $s0, $s1, blazeCheck
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	beq $s0, $s1, blazeCheck
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	beq $s0, $s1, blazeCheck
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	lbu $s1, 1($t0)
	beq $s0, $s1, blazeCheck
	j printSkeet

checkIfLessThanJack:
	li $t1, 11
	blt $s0, $t1, printHighCard
	j blazeCheck
	

blazeCheck:
	lw $t0, addr_arg1
	li $t1, 11
	lbu $s0, 0($t0)
	blt $s0, $t1, printHighCard
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	blt $s0, $t1, printHighCard
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	blt $s0, $t1, printHighCard
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	blt $s0, $t1, printHighCard
	addi $t0, $t0, 1
	lbu $s0, 0($t0)
	blt $s0, $t1, printHighCard
	j printBlaze

printHighCard:
	la $a0, high_card_str
	li $v0, 4
	syscall 
	j exit
	
printBlaze:
	la $a0, blaze_str
	li $v0, 4
	syscall
	j exit

printSkeet:
	la $a0, skeet_str
	li $v0, 4
	syscall
	j exit

printFiveAndDime:
	la $a0, five_and_dime_str
	li $v0, 4
	syscall
	j exit

printFullhouse:
	la $a0, full_house_str
	li $v0, 4
	syscall
	j exit
	
printBobtail:
	la $a0, big_bobtail_str
	li $v0, 4
	syscall
	j exit
    
invalidOperation:
	la $a0, invalid_operation_error
	li $v0, 4
	syscall
	j exit

invalidArgs:
	la $a0, invalid_args_error
	li $v0, 4
	syscall
	j exit
	
finishQuestion:
	li $a0, '\n'
	li $v0, 11
	syscall
	j exit
exit:
    li $v0, 10
    syscall
