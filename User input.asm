.data
	message:  .asciiz "I am "
	message2: .asciiz " years old"
	user_input: .asciiz "Give an integer: "
.text
main:
	li $v0, 4
	la $a0, user_input
	syscall
	li $v0, 5
	syscall
	move $a1, $v0

	la $a0, message
	li $v0, 4
	syscall
	
	li $v0, 1
	add $a0, $a1, $zero
	syscall
	
	la $a0, message2
	li $v0, 4
	syscall
	
exit:
	li $v0, 10
	syscall