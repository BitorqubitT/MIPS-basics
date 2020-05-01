.globl main
.data
	Winnermsg: .asciiz "You have won!!!!!!!!!!!" #Winner message.
	Exitmsg: .asciiz "You have quit the game"	  #Quit game message.

.text  		

li $s1, 0          				#Current player row counter.
li $s2, 0           				#Current player column counter.
li $s6, 0					#New player row counter.
li $s7, 0					#New player column counter.
#######################################################################################
ProcessInput:
	Input:		
	move $s6, $s1 				#Copy current row position to new.
	move $s7, $s2				#Copy current column position to new.	 		
	beq $a0, 122, L0			#Check if a0 = z if so jump to case L0.	
	beq $a0, 115, L1			#Check if a0 = s if so jump to case L1.
	beq $a0, 113, L2			#Check if a0 = q if so jump to case L2.
	beq $a0, 100, L3			#Check if a0 = 100 if so jump to case L3.
	beq $a0, 120, Exit			#Check if a0 = 120 if so jump to exit.
	j Input   				#Start again.

	Table:	
	L0: add $s7, $s7, 1			#Move 1 position up.	
	j AssessMove
	L1: add $s7, $s7, -1			#Move 1 position down.
	j AssessMove
	L2: add $s6, $s6, 1			#Move 1 position to the right.
	j AssessMove
	L3: add $s6, $s6, -1			#Move 1 position to the left. 
	j AssessMove
#########################################################################################
AssessMove:		
	sub $gp, $gp, $t0			#Subtract total iterations (*4) from GP to go back to the first pixel.
	li $t0, -4				#Reset t0.
	li $s4, 0				#Reset s4
	li $s5, 0				#Reset s5

	rowLoop:
	beq $s4, $s1, finalColumnLoop		#Run this loop untill we get to the right number on the Y-axes.
	li $t9, 0				#Reset t9 so it can be used in the next loop..
	addi $s4, $s4, 1        		#s1=s1+1
	j columnLoop				#Go to loop.
	
	columnLoop:
	beq $t9, 7, rowLoop			#The number 8 will later be represented by a variabel from MazeCreator.
	addi $gp, $gp, 4        		#Go to next pixel in display.
	addi $t0, $t0, 4  	      		#Incrementing current location to next pixel
	addi $t9, $t9, 1       	 		#s1=s1+1
	j columnLoop
	
	finalColumnLoop:
	beq $s5, $s2, check			#Run this loop untill we get to the right number on the x-axes.
	addi $gp, $gp, 4        		#Go to next pixel in display.
	addi $t0, $t0, 4  	      		#Incrementing current location to next pixel
	addi $s5, $s5, 1			#s1=s1+1
	j finalColumnLoop			#Go to loop.
 	
	check:	
	la $t6, ($gp)				#Put address of gp into t6.#check de kleur van dit adress
	lw $t5, -4($gp)
	beq $t5, 0x000000ff, Input		#Its a wall go back to user input.
	beq $t5, 0x00000000, ProcessMove	#Move.
	beq $t5, 0x0000ff00, Winner		#Exit game.
	syscall 
##########################################################################################
ProcessMove:	
	ChangePosition:      			#The new position is valid so within this loop we do two things: 1. Change the old position to a passage. And we change the new position to yellow.
	#set this position to yellow
	#set old position to yellow. 	`	
	sw $t3, -4($gp)				#Set new player position to Yellow.
	sub $gp, $gp, $t0			#Subtract total iterations (*4) from GP to go back to the first pixel.
	li $t0, -4				#Reset t0.	
	li $s4, 0
	li $s5, 0
	rowLoop2:
	beq $s4, $s6, finalcolumnLoop2		#Run this loop untill we get to the right number on the Y-axes.
	li $t9, 0				#Reset t9 so it can be used in the next loop.
	addi $s4, $s4, 1       			#s1=s1+1
	j columnLoop2				#Go to columnLoop2.
	
	columnLoop2:
	beq $t9, 7, rowLoop2			#Run this loop untill we have reached the max width of the Maze.(This variabele is given by the drawmaze function).It spots the max width.
	addi $gp, $gp, 4        		#Go to next pixel in display.
	addi $t0, $t0, 4  	      		#Incrementing current location to next pixel
	addi $t9, $t9, 1        		#s1=s1+1
	j columnLoop2				#Go to columnLoop2
	
	finalcolumnLoop2:
	beq $s5, $s7, oldPosition		#Run this loop untill we get to the right number on the x-axes.
	addi $gp, $gp, 4       			#Go to next pixel in display.
	addi $t0, $t0, 4  	      		#Incrementing current location to next pixel
	addi $s5, $s5, 1			#s1=s1+1
	j finalcolumnLoop2			#Go to finalcolumnLoop2.	 
		
	oldPosition:			
	sw $t2, -4($gp)				#Color the old player position black.
	move $s1, $s6 				#Copy new row position to current position.
	move $s2, $s7				#Copy new column position to current position.
	j Winner				#Go back to ProcessInput to process new input.
########################################################################################
EndConditions:
	Exit:
	li $v0, 16 				#Close file system call.
	move $a3, $s6 				#Move s6 to a0.
	syscall 				#Close file.
	li $v0, 4				#4 is print string sysall.
	la $a0, Exitmsg				#Move space(next line)to a0 and print a0.
	syscall
	jr $ra	
	
	Winner:
	li $v0, 4				#4 is print string sysall.
	la $a0, Winnermsg				#Move space(next line)to a0 and print a0.
	syscall
	li $v0, 10				#System call code for exit = 10
	syscall					#Call operating sys
	
########################################################################################


main:	
	li $t0, 5				#Load an input for example 122, this means q which is up.
	li $t1, 8				#Current player row counter
	li $t2, 1				#Current player column counter.
	move $a0, $t0				#Put procedure arguments.
	move $s1, $t1				#Put procedure arguments.
	move $s2, $t2				#Put procedure arguments.
	jal ProcessInput			#This fuction takes one argument which is an input.
	
exit:
	li $v0, 10				#System call code for exit = 10
	syscall					#Call operating sys
		














