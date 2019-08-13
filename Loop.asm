.data
	space: .asciiz "\n"
.text
main:
	addi $t0, $zero, 1  #t0 +1

counter:
	bgt $t0, 10, exit	#If t0> 10, then exit the program.
	jal printNumber		#Print the number.
	
	addi $t0, $t0, 1        #i++

j counter			#Jump back to the beginning of the loop.
	
printNumber:
	li $v0, 1		#Print word syscall.
	add $a0, $t0, $zero	#Write t0 to a0 and print a0.
	syscall
	
	li $v0, 4		#Print string syscall.
	la $a0, space		#Move space into a0 and print it. (Jump to the next line.)
	syscall
	jr $ra 			#Go back to the loop.(counter)

exit:
	li $v0, 10	#Exit program.
	syscall