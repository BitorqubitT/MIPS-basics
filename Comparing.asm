# Comparing two numbers and see which one is bigger. Then we print out a message.
.data
	number_a: .word 48 
	number_b: .word	48
	message:  .asciiz "b > a"
	equal:    .asciiz "a and b are equal"
.text
main:
	lw $t1, number_a	# Load number_a into $t1.
	lw $t2, number_b	# Load number_b into $t2.
	bgt $t1, $t2, A_wins	# If $t1 > $t2 jump to A_wins.
	bgt $t2, $t1, B_wins	# If $t2 > $t1 jump to B_wins.
	j same			# If a = b jump to same.
      
A_wins:
	move $a0, $t1		# Move number_a into $a0.
	li   $v0,1		# Print the number.
	syscall
	j exit			# Jump to exit.
	
B_wins:
	la $a0, message		# Load message into $a0.   	
	li $v0, 4		# Print $a0.
	syscall
	j exit			# Jump to exit.
	
same:
	la $a0, equal		# Load equal into $a0.
	li $v0, 4		# Print $a0.
	syscall
	j exit			# Jump to exit.

exit:
	li $v0, 10		# Code 10 to exit program.
	syscall