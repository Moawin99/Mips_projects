.data
isbn: .asciiz "9780140168130"
books:
.align 2
.word 7 5 68
# Book struct start
.align 2
.ascii "9780345501330\0"
.ascii "Fairy Tail, Vol. 1 (Fair\0"
.ascii "Hiro Mashima, William Fl\0"
.word 0
# Book struct start
.align 2
.ascii "9780345419580\0"
.ascii "Moreta: Dragonlady of Pe\0"
.ascii "Anne McCaffrey\0\0\0\0\0\0\0\0\0\0\0"
.word 0
# empty or deleted entry starts here
.align 2
.byte -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 
# Book struct start
.align 2
.ascii "9780440060670\0"
.ascii "The Other Side of Midnig\0"
.ascii "Sidney Sheldon\0\0\0\0\0\0\0\0\0\0\0"
.word 0
# empty or deleted entry starts here
.align 2
.byte -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 
# Book struct start
.align 2
.ascii "9780140168130\0"
.ascii "Big Sur\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.ascii "Jack Kerouac, Aram Saroy\0"
.word 0
# Book struct start
.align 2
.ascii "9781416971700\0"
.ascii "Out of My Mind\0\0\0\0\0\0\0\0\0\0\0"
.ascii "Sharon M. Draper\0\0\0\0\0\0\0\0\0"
.word 0


.text
.globl main
main:
la $a0, books
la $a1, isbn
jal get_book

move $t0, $v0
move $t1, $v1

# Write code to check the correctness of your code!
li $v0, 10
syscall

.include "hwk4.asm"

