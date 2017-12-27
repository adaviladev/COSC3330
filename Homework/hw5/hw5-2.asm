	.data
arr1:	.space 12
arr2:	.space 12
size1:	.word 3
size2:	.word 3
prompt:	.asciiz "Enter a number: "
res1:	.asciiz "Sum of largest two entries in the array: "
newLine:.asciiz "\n"

	.text
	.globl main
main:	# main function is obvious; call functions and then print the sums of each array.
	# process arr1
	la $a0, arr1
	lw $a1, size1
	jal load_array
	la $a0, arr1
	lw $a1, size1
	jal sort_array
	la $a0, arr1
	jal print_array
	la $a0, arr1
	#lw $a1, size1
	li $a1, 2
	jal add_elements
	# end processing of arr1
	move $s2, $v0
		
	li $v0, 4
	la $a0, newLine
	syscall
	
	li $v0, 4
	la $a0, res1
	syscall
	li $v0, 1
	la $a0, ($s2)
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
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
	
sort_array:
	move $t0, $a1		# number of elements
	decrement:
	li $t1, 0		# incrementer
	la $s0, ($a0)		# load address of arr[0]
	la $s1, ($a0)
	addi $s1, $s1, 4	# address of next element
	addi $t0 $t0, -1	# decrement number of elements by one to stay within bounds for first iteration and as the array go sorted at the end
	
		startSort:
			bge $t1, $t0, endSort
			lw $t3, ($s0)	# current element
			lw $t4, ($s1)	# next element
			
			blt $t3, $t4, swap	# swap if cur is greater than next
				j endSwap	# else jump to endSwap to increment values
			swap:
				la $t5, ($t3)	# load address of cur to $t5
				la $t3, ($t4)	# load address of next to cur
				move $t4, $t5	# move cur to next from $t5
				sw $t3, ($s0)	# store value into cur
				sw $t4, ($s1)	# store value into next
			endSwap:
			addi $s0, $s0, 4	# increment cur index to next index
			addi $s1, $s1, 4	# increment next index to next-next index
			addi $t1, $t1, 1	# increment counter
			j startSort		# loop back to sort
	
		endSort:
	bgt $t0, $zero, decrement	# if index decrementer is greater than zero, jump to decrement to sort again
	jr $ra

print_array:
	li $t1, 0			# set counter to 0
	la $s0, ($a0)			# load address of array to $s0
	move $t0, $a1			# set $t0 to number of elements
	
	startPrint:
		bge $t1, $t0, endPrint	# check if all elements have been printed
		li $v0, 1		# set to print int
		lw $a0, ($s0)		# load word into $a0
		syscall			# print int
		
		li $v0, 4		# print new line
		la $a0, newLine
		syscall
		
		addi $s0, $s0, 4	# increment to next index
		addi $t1, $t1, 1	# increment counter
		j startPrint		# loop back
	endPrint:
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
