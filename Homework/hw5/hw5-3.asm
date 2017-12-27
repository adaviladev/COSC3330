	.data
zeroNum:	.asciiz 0
oneNum:		.asciiz 1
twoNum:		.asciiz 2
threeNum:	.asciiz 3
fourNum:	.asciiz 4
fiveNum:	.asciiz 5
sixNum:		.asciiz 6
sevenNum:	.asciiz 7
eightNum:	.asciiz 8
nineNum:	.asciiz 9

prompt:		.asciiz "Enter a non-negative number: "
valStr:		.asciiz "Value Entered: "
zeroStr:	.asciiz "zero"
oneStr:		.asciiz "one"
twoStr:		.asciiz "two"
threeStr:	.asciiz "three"
fourStr:	.asciiz "four"
fiveStr:	.asciiz "five"
sixStr:		.asciiz "six"
sevenStr:	.asciiz "seven"
eightStr:	.asciiz "eight"
nineStr:	.asciiz "nine"
newLine:	.asciiz "\n"

	.text
	.globl main
main:	# main function is obvious; call functions and then print the sums of each array.
	jal printLine
	la $a0, prompt		# print prompt to enter a number
	syscall
	li $v0, 5		# read number
	syscall
	move $t0, $v0
	li $t1, 0		# incrementer
	li $t2, 10		# divisor
	getRem:
		beq $t0, $t1, dumpAndDie
			div $v0, $t2
			mfhi $t3
			mflo $t0
			jal printLine
			
			j getRem
			
dumpAndDie:
	la $a0, newLine
	jal printLine
	
	li $v0, 4
	la $a0, res1
	syscall
	li $v0, 1
	la $a0, ($s0)
	syscall
	
	la $a0, newLine
	jal printLine
	
end:
	li $v0, 10
	syscall

load_array:
	li $t1, 0			# set counter to 0
	la $s0, ($a0)			# copy address to $s0 for iteration
	move $t0, $a1			# copy number of variables to $t0
	build:		
		bge $t1, $t0, endBuild	# loop n times
		li $v0, 4
		la $a0, prompt		# print prompt to enter a number
		syscall
		
		li $v0, 5		# read number
		syscall
		sw $v0, ($s0)		# store number at current index of array
		
		addi $s0, $s0, 4	# increment to next index
		addi $t1, $t1, 1	# increment counter
		
		j build
	endBuild:
	jr $ra
	
add_elements:
	move $t0, $a1		# number of elements
	li $t1, 0		# loop counter
	li $t2, 0 		# sum
	la $s0, ($a0)		# array address
	
	startAdd:
		bge $t1, $t0, endAdd
		lw $t3, ($s0)		# put contents of current element address into $t3
		add $t2, $t2, $t3	# add $t3 to current sum
		
		addi $s0, $s0, 4	# increment to next index
		addi $t1, $t1, 1	# increment counter
		j startAdd
	endAdd:
	move $v0, $t2		# return sum in $v0 
	jr $ra
	
printLine:
	li $v0, 4
	syscall
	jr $ra
	
printNum:
	li $v0, 1
	syscall
	jr $ra

