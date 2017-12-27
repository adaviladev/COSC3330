	.data
prompt:	.asciiz "Enter a number (0 to quit): "
res1:	.asciiz "Current sum: "
val:	.asciiz "Value Entered: "
newLine:.asciiz "\n"

	.text
	.globl main
main:	# main function is obvious; call functions and then print the sums of each array.
	add $s0, $zero, $zero #running sum
	readInput:
		li $v0, 4
		la $a0, res1
		syscall
		li $v0, 1
		la $a0, ($s0)
		syscall
		jal printNewLine
		li $v0, 4
		la $a0, prompt		# print prompt to enter a number
		syscall
		li $v0, 5		# read number
		syscall
		move $t0, $v0
		beq $t0, $zero, dumpAndDie
			add $s0, $s0, $t0
			jal printNewLine
			j readInput
			
dumpAndDie:
		
	jal printNewLine
	
	li $v0, 4
	la $a0, res1
	syscall
	li $v0, 1
	la $a0, ($s0)
	syscall
	
	jal printNewLine
	
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
	
printNewLine:
	li $v0, 4
	la $a0, newLine
	syscall
	jr $ra

