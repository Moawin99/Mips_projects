# Mark Moawad
# msmoawad
# 112198934

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

############################## Do not .include any files! #############################

.text

strlen:
	move $t0, $a0
	li $t2, 0	#count
loopToFindLength:
	lbu $t1, 0($t0)		#Load string[i] into t1
	beq $t1, $0, returnStringLen	#branch if end of string
	addi $t0, $t0, 1	#add one to base address
	addi $t2, $t2,  1	#add one to counter
	j loopToFindLength

returnStringLen:
	move $v0, $t2
    jr $ra

index_of:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal strlen
	move $t3, $v0
	move $t0, $a0	#string
	move $t1, $a1	#char
	move $t2, $a2	#starting index
	li $t4, 0	#index
loopToStartingIndex:
	beq $t4, $t2, compareChars
	addi $t0, $t0, 1
	addi $t4, $t4, 1
	j loopToStartingIndex
compareChars:
	beq $t4, $t3, returnNeg1
	lbu $t2, 0($t0)
	beq $t2, $t1, returnCharIndex
	addi $t0, $t0, 1
	addi $t4, $t4, 1
	j compareChars

returnNeg1:
	li $v0, -1
	j done
returnCharIndex:
	move $v0, $t4
	j done
done:	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
    jr $ra

to_lowercase:
	move $t0, $a0
	li $t1, 0	#case Counter
	li $t2, 65
	li $t3, 90
loopLowercase:
	lbu $t4, 0($t0)
	beqz $t4, doneLowercase
	blt $t4, $t2, skipChar
	bgt $t4, $t3, skipChar
	addi $t4, $t4, 32
	sb $t4, 0($t0)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j loopLowercase

skipChar:
	addi $t0, $t0, 1
	j loopLowercase
doneLowercase:
	move $v0, $t1
    jr $ra

generate_ciphertext_alphabet:
	move $t0, $a0	#cipher
	move $t1, $a1	#keyphrase
	li $t2, 0	#index
	li $t3, 63	#range
	li $t4, 0	#value stored
	addi $sp, $sp, -62
	move $t7, $sp
initHashMap:
	beq $t2, $t3, setupKeyphrase
	sb $t4, 0($t7)
	addi $t7, $t7, 1
	addi $t2, $t2, 1
	j initHashMap
	
setupKeyphrase:
	li $t2, 0 #index
	li $t3, 0 #number of unique characters/digits from keyphrase
	move $t7, $sp
readKeyphrase:
	lbu $t4, 0($t1)
	beqz $t4, next
	li $t5, 48
	blt $t4, $t5, checkDigit
	li $t5, 57
	bgt $t4, $t5, character
	li $t5, 4
	add $t6, $t4, $t5
	add $t7, $t7, $t6
	lbu $t5, 0($t7)
	bnez $t5, alreadyOnStack
	sb $t4, 0($t7)
	sb $t4, 0($t0)
	addi $t0, $t0, 1	#cipher++
	addi $t1, $t1, 1	#keyphrase++
	addi $t3, $t3, 1	#unique++
	move $t7, $sp
	j readKeyphrase
	
	
checkDigit:
	li $t5, 48
	blt $t4, $t5, alreadyOnStack
	addi $t6, $t4, 52
	add $t7, $t7, $t6
	lbu $t5, 0($t7)
	bnez $t5, alreadyOnStack
	sb $t4, 0($t7)
	sb $t4, 0($t0)
	addi $t0, $t0, 1	#cipher++
	addi $t1, $t1, 1	#keyphrase++
	addi $t3, $t3, 1	#unique++
	move $t7, $sp
	j readKeyphrase
	
character:
	li $t5, 65
	blt $t4, $t5, alreadyOnStack
	li $t5, 90
	bgt $t4, $t5, lowerCaseCharacter
	li $t5, -39
	add $t6, $t4, $t5
	add $t7, $t7, $t6
	lbu $t5, 0($t7)
	bnez $t5, alreadyOnStack
	sb $t4, 0($t7)
	sb $t4, 0($t0)
	addi $t0, $t0, 1	#cipher++
	addi $t1, $t1, 1	#keyphrase++
	addi $t3, $t3, 1	#unique++
	move $t7, $sp
	j readKeyphrase
	
lowerCaseCharacter:
	li $t5, 97
	blt $t4, $t5, alreadyOnStack
	li $t5, -97
	add $t6, $t4, $t5	#offset to store on stack
	add $t7, $t7, $t6	#index for stack
	lbu $t5, 0($t7)		#load value from stack before storing		
	bnez $t5, alreadyOnStack
	sb $t4, 0($t7)		#store value onto stack
	sb $t4, 0($t0)		#store character into cipher
	addi $t0, $t0, 1	#cipher++
	addi $t1, $t1, 1	#keyphrase++
	addi $t3, $t3, 1	#unique++
	move $t7, $sp
	j readKeyphrase
	
alreadyOnStack:
	addi $t1, $t1, 1	#keyphrase++
	move $t7, $sp
	j readKeyphrase
	
next:
	move $t0, $a0
	move $t8, $t3
	move $t7, $sp
	move $t2, $t3 	#Over all index
	add $t0, $t0, $t3	#cipher index
	li $t1, 62
	addi $t7, $t7, 0	#stack index
	li $t3, 97
	li $t4, 0	#index for lowercase
	li $t5, 26
	
cipherLowercase:
	beq $t4, $t5, prepareCipherUppercase
	lbu $t6, 0($t7)
	bnez $t6, skipLowercase
	sb $t3, 0($t0)
	addi $t0, $t0, 1
	addi $t3, $t3, 1
	addi $t7, $t7, 1
	addi $t4, $t4, 1
	addi $t2, $t2, 1
	j cipherLowercase
	
skipLowercase:
	addi $t3, $t3, 1
	addi $t7, $t7, 1
	addi $t4, $t4, 1
	j cipherLowercase
	
prepareCipherUppercase:
	move $t7, $sp
	li $t3, 65
	li $t4, 0
	addi $t7, $t7, 26
cipherUppercase:
	beq $t4, $t5, prepareCipherDigits
	lbu $t6, 0($t7)
	bnez $t6, skipUppercase
	sb $t3, 0($t0)
	addi $t0, $t0, 1
	addi $t3, $t3, 1
	addi $t7, $t7, 1
	addi $t4, $t4, 1
	addi $t2, $t2, 1
	j cipherUppercase
	
skipUppercase:
	addi $t3, $t3, 1
	addi $t7, $t7, 1
	addi $t4, $t4, 1
	j cipherUppercase
	
prepareCipherDigits:
	move $t7, $sp
	li $t3, 48
	addi $t7, $t7, 52
	
cipherDigits:
	beq $t2, $t1, doneWithCipher
	lbu $t6, 0($t7)
	bnez $t6, skipDigit
	sb $t3, 0($t0)
	addi $t0, $t0, 1
	addi $t3, $t3, 1
	addi $t7, $t7, 1
	addi $t2, $t2, 1
	j cipherDigits
	
skipDigit:
	addi $t3, $t3, 1
	addi $t7, $t7, 1
	j cipherDigits
	
doneWithCipher:
	li $t2, 0
	sb $t2, 0($t0)
	addi $sp, $sp, 62
	move $t0, $a0
printcipher:
	lbu $t2, 0($t0)
	beqz $t2, done4
	addi $t0, $t0, 1
	move $a0, $t2
	li $v0, 11
	syscall
	j printcipher

done4:
	move $v0, $t8
    jr $ra

count_lowercase_letters:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	move $s0, $a0 		#count
	move $s1, $a1		#message
	move $t0, $a0		#second copy of count
	li $t1, 26		
	li $t2, 0
	li $t3, 0		

initZeros:
	beq $t2, $t1, prepCountLoop
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	addi $t2, $t2, 1
	j initZeros
	
prepCountLoop:
	li $t1, 97
	li $t2, 122
	li $t3, 0		#total lowercase
	move $t0, $s0
	li $t5, 4
	
countLowercaseLoop:
	lbu $t4, 0($s1)
	beqz $t4, returnLowercaseCount
	blt $t4, $t1, skipCharacter
	bgt $t4, $t2, skipCharacter
	sub $t4, $t4, $t1
	mult $t4, $t5
	mflo $t4
	add $t0, $t0, $t4
	lw $t6, 0($t0)
	addi $t6, $t6, 1
	sw $t6, 0($t0)
	move $t0, $s0
	addi $t3, $t3, 1
	addi $s1, $s1, 1
	j countLowercaseLoop
	
skipCharacter:
	addi $s1, $s1, 1
	j countLowercaseLoop
	
	
returnLowercaseCount:
	move $v0, $t3
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
    jr $ra

sort_alphabet_by_count:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	move $s0, $a0	#alphabet
	move $s1, $a1	#counts
	li $t0, 0
	li $t1, 26
	li $t2, 97
initAlphabet:
	beq $t0, $t1, doneInit
	sb $t2, 0($s0)
	addi $s0, $s0, 1
	addi $t0, $t0, 1
	addi $t2, $t2, 1
	j initAlphabet

doneInit:
	li $t3, 0
	sb $t3, 0($s0)
	move $s0, $a0
	li $t0, -1	#outer loop index
	li $t2, 25
bubblesortOuterLoop:
	beq $t0, $t2, doneSortingAlphabet
	addi $t0, $t0, 1
	li $t1, 0 	#inner loop index
	move $s0, $a0
	move $s1, $a1
bubblesortInnerLoop:
	beq $t1, $t2, bubblesortOuterLoop
	lw $t3, 0($s1)
	lw $t4, 4($s1)
	bgt $t3, $t4, skipSwap
	sw $t3, 4($s1)
	sw $t4, 0($s1)
	lbu $t3, 0($s0)
	lbu $t4, 1($s0)
	sb $t3, 1($s0)
	sb $t4, 0($s0)
	addi $s1, $s1, 4
	addi $s0, $s0, 1
	addi $t1, $t1, 1
	j bubblesortInnerLoop
	
skipSwap:
	addi $s1, $s1, 4
	addi $s0, $s0, 1
	addi $t1, $t1, 1
	j bubblesortInnerLoop
	
doneSortingAlphabet:
	move $s0, $a0
donePrint:
	lbu $t0, 0($s0)
	beqz $t0, printed
	move $a0, $t0
	li $v0, 11
	syscall
	addi $s0, $s0, 1
	j donePrint
	
printed:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
    jr $ra

generate_plaintext_alphabet:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	move $s0, $a0	#plaintext
	move $s1, $a1	#sorted
	li $t0, 96
	li $t5, 123
	li $t2, 9
printSortedAlpha:
	addi $t0, $t0, 1
	move $s1, $a1
	beq $t0, $t5, doneWritingPlain
	lbu $t1, 0($s1)
	beq $t0, $t1, findIndex
	addi $s1, $s1, 1
	lbu $t1, 0($s1)
	beq $t0, $t1, findIndex
	addi $s1, $s1, 1
	lbu $t1, 0($s1)
	beq $t0, $t1, findIndex
	addi $s1, $s1, 1
	lbu $t1, 0($s1)
	beq $t0, $t1, findIndex
	addi $s1, $s1, 1
	lbu $t1, 0($s1)
	beq $t0, $t1, findIndex
	addi $s1, $s1, 1
	lbu $t1, 0($s1)
	beq $t0, $t1, findIndex
	addi $s1, $s1, 1
	lbu $t1, 0($s1)
	beq $t0, $t1, findIndex
	addi $s1, $s1, 1
	lbu $t1, 0($s1)
	beq $t0, $t1, findIndex
	j writeToPlain
	
findIndex:
	sub $t3, $s1, $a1
	sub $t3, $t2, $t3
	move $s1, $a1
	li $t4, 0
loopPlain:
	beq $t3, $t4, printSortedAlpha
	sb $t0, 0($s0)
	addi $s0, $s0, 1
	addi $t4, $t4, 1
	j loopPlain
writeToPlain:
	sb $t0, 0($s0)
	addi $s0, $s0, 1
	j printSortedAlpha
	
doneWritingPlain:
	li $t0, 0
	sb $t0, 0($s0)
	move $s0, $a0
printPlainAlpha:
	lbu $t1, 0($s0)
	beqz $t1, doneQus7
	move $a0, $t1
	li $v0, 11
	syscall
	addi $s0, $s0, 1
	j printPlainAlpha
	
doneQus7:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
    jr $ra

encrypt_letter:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	move $s0, $a0		#lowercase letter
	move $s1, $a1		#non-neg int
	move $t0, $a2		#plaintext
	move $t1, $a3		#cipher
findLetterInPlaintext:
	lbu $t2, 0($t0)
	beq $s0, $t2, foundLetter
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j findLetterInPlaintext

foundLetter:
	li $t3, 0
loopTilNotLetter:
	lbu $t2, 0($t0)
	bne $t2, $s0, findModValue
	addi $t0, $t0, 1
	addi $t3, $t3, 1
	j loopTilNotLetter
	
findModValue:
	div $s1, $t3
	mfhi $t3
	add $t1, $t1, $t3
	lbu $t4, 0($t1)
	move $v0, $t4
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
    jr $ra

encrypt:
	addi $sp, $sp, -36
	sw $s0, 0($sp)		#cipher
	sw $s1, 4($sp)		#plaintext
	sw $s2, 8($sp)		#keyphrase
	sw $s3, 12($sp)		#corpus
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	move $a0, $s1
	jal to_lowercase
	move $a0, $s3
	jal to_lowercase
	addi $sp, $sp, -104
	move $a0, $sp
	move $a1, $s3
	jal count_lowercase_letters
	move $a1, $sp
	addi $sp, $sp, -28
	move $a0, $sp
	jal sort_alphabet_by_count
	move $a1, $sp
	addi $sp, $sp, -64
	move $s4, $sp	#plainTextAlpha
	move $a0, $sp
	jal generate_plaintext_alphabet
	move $a1, $s2
	addi $sp, $sp, -64
	move $s5, $sp	#cipherTextAlpha
	move $a0, $sp
	jal generate_ciphertext_alphabet
	move $a2, $s4
	move $a3, $s5
	li $s6, 0	#lowercase letters encrypted count
	li $s7, 0	#letters not encrypted
	li $a1, 0
loopEncrypt:
	lbu $a0, 0($s1)
	beqz $a0, doneEncrypting
	li $t0, 97
	blt $a0, $t0, skipEncryption
	li $t0, 122
	bgt $a0, $t0, skipEncryption
	jal encrypt_letter
	sb $v0, 0($s0)
	addi $s1, $s1, 1
	addi $s0, $s0, 1
	addi $s6, $s6, 1
	addi $a1, $a1, 1
	j loopEncrypt
	
skipEncryption:
	sb $a0, 0($s0)
	addi $s1, $s1, 1
	addi $s0, $s0, 1
	addi $s7, $s7, 1
	addi $a1, $a1, 1
	j loopEncrypt
	
doneEncrypting:
	li $t0, 0
	sb $t0, 0($s0)
	addi $sp, $sp, 104
	addi $sp, $sp, 28
	addi $sp, $sp, 64
	addi $sp, $sp, 64
	move $v0, $s6
	move $v1, $s7
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

decrypt:
	addi $sp, $sp, -36
	sw $s0, 0($sp)		#plaintext
	sw $s1, 4($sp)		#cipher
	sw $s2, 8($sp)		#keyphrase
	sw $s3, 12($sp)		#corpus
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	move $a0, $s3
	jal to_lowercase
	addi $sp, $sp, -104
	move $s4, $sp
	move $a0, $sp
	move $a1, $s3
	jal count_lowercase_letters
	addi $sp, $sp, -28
	move $a0, $sp
	move $a1, $s4
	jal sort_alphabet_by_count
	move $a1, $sp
	addi $sp, $sp, -64
	move $a0, $sp
	jal generate_plaintext_alphabet
	move $s4, $sp	#plaintextALPHA
	addi $sp, $sp, -64
	move $a0, $sp
	move $a1, $s2
	jal generate_plaintext_alphabet
	move $s5, $sp		#ciphertextALPHA
	li $s6, 0
	li $s7, 0
	li $a2, 0
	move $a0, $s5
loopDecrypt:
	lbu $a1, 0($s1)
	beqz $a1, donehw2
	li $t1, 48
	blt $a0, $t1, skipDecrypt
	li $t1, 57
	bgt $a0, $t1, checkLetters
	jal index_of
	move $t0, $v0
	move $a0, $s4
	jal index_of
	move $t0, $v0
	add $t4, $s4, $t0
	lbu $t5, 0($t4)
	sb $t5, 0($s0)
	addi $s7, $s7, 1
	addi $s1, $s1, 1
	addi $s0, $s0, 1
	j loopDecrypt

checkLetters:
	li $t1, 65
	blt $a0, $t1, skipDecrypt
	li $t1, 90
	bgt $a0, $t1, checkMoreLetters
	jal index_of
	move $t0, $v0
	move $a0, $s4
	jal index_of
	move $t0, $v0
	add $t4, $s4, $t0
	lbu $t5, 0($t4)
	sb $t5, 0($s0)
	addi $s6, $s6, 1
	addi $s1, $s1, 1
	addi $s0, $s0, 1
	j loopDecrypt
	
checkMoreLetters:
	li $t1, 97
	blt $a0, $t1, skipDecrypt
	li $t1, 122
	bgt $a0, $t1, skipDecrypt
	jal index_of
	move $t0, $v0
	move $a0, $s4
	jal index_of
	move $t0, $v0
	add $t4, $s4, $t0
	lbu $t5, 0($t4)
	sb $t5, 0($s0)
	addi $s6, $s6, 1
	addi $s1, $s1, 1
	addi $s0, $s0, 1
	j loopDecrypt

skipDecrypt:
	sb $a0, 0($s0)
	addi $s7, $s7, 1
	addi $s1, $s1, 1
	addi $s0, $s0, 1
	j loopDecrypt

donehw2:
	move $v0, $s6
	move $v1, $s7
	addi $sp, $sp, 104
	addi $sp, $sp, 28
	addi $sp, $sp, 64
	addi $sp, $sp, 64
	lw $s0, 0($sp)		#plaintext
	lw $s1, 4($sp)		#cipher
	lw $s2, 8($sp)		#keyphrase
	lw $s3, 12($sp)		#corpus
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
    jr $ra

############################## Do not .include any files! #############################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
