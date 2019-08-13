#Loading two integer and adding them together and printing the result.
.data	
	number_a: .word 4	# Variable A.			
	number_b: .word 5	# Variable B.
.text
main:
	lw   $t1, number_a	# Loading number_a into $t1.
	lw   $t2, number_b	# Loading number_b into $t2.
	add  $t0, $t1, $t2	# Adding $t1 and $t2 and storing them in $t0.
	move $a0, $t0		# Move $t0 to $a0.
	li   $v0,1		# Print.
	syscall
	
exit:
	li $v0, 10		# Syscall code 10 for exit program.
	syscall