# Program to print a string.
.data
	msg: .asciiz "Hello world"
.text
main:
	la $a0, msg	# Loading msg into $a0.	
	li $v0, 4	# 4 is the print string syscall.
	syscall
exit:
	li $v0, 10	# Syscall code 10 to exit.
	syscall