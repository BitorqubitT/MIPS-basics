.globl main
.data
	File: .asciiz "c:\\check.txt" 		#Filename for input
	Buffer: .space 2048 			#Space used as buffer
	Winnermsg: .asciiz "You have won!!!!!!!!!!!" #Winner message.
	Exitmsg: .asciiz "You have quit the game"	  #Quit game message.
.text	
########################################################################################
	li $t1, 0x000000ff       		#Loading blue in register.
	li $t2, 0x00000000       		#Loading black in register
	li $t3, 0x00ffff00      		#Loading yellow in register.
	li $t4, 0x0000ff00     			#Loading green in register
	li $s1, 0          			#Current player row counter.
	li $s2, 0           			#Current player column counter.
	li $s3, 0				#This will be used to pick a character from the string.
	li $s6, 0				#New player row counter.
	li $s7, 0				#New player column counter.
	li $t0, -4          			#Current iteration.
	li $v1, 0				#Current player row. (Will be returned)
MazeCreater:	
						#Open a file.
	li $v0, 13				#System call for open file.
	la $a0, File 				#Output file name.
	li $a1, 0 				#Open for writing.
	li $a2, 0 				#Mode is ignored.
	syscall 				#Open a file (file descriptor returned in $v0)
	move $s6, $v0 		 		#Put file descriptor content in s6.
						#Read from file to buffer
	li $v0, 14 				#System call for write to file.
	move $a0, $s6 			
	la $a1, Buffer  			#Put content of buffer in a1.
	li $a2, 2048				#Max characters.
	syscall 				#Write to file. 				
 	la $a0, Buffer        			#Load buffer in a0 to print.	
 					
	add $a0, $a0, $s3 			#Add s3 to a0 this allows us to choose which character we want.
	lb $a0, 0($a0)				#Load 0(a0) in a0 this gives us a single character.	
	move $s0, $a0				#Move character to s0.
					
						#Here we check the different cases that might occur for the different inputs.
	beq $s0, 119, L0			#When s0 = w go to L0					
	beq $s0, 112, L1 			#When s0 = p go to L1	
	beq $s0, 115, L2			#When s0 = s go to L2	
	beq $s0, 117, L3 			#When s0 = u go to L3	
	beq $s0, 10, L4 			#When s0 = u go to L4(s0 is an enter).
	beq $s3, 88, Exit			#This is an end condition, however this could be more dynamic.
	back:
	addi $t0, $t0, 1        		#Incrementing current location to next pixel.
	add $s3, $s3, 1				#Go to next character.	
	add $s2, $s2, 1				#s0+1 (Add to Colomn).
	j MazeCreater				#Jump to makeRedLoop.		
		
						 
#Case for the different inputs. #When a color is read from the text file. Later we will also add enemy and candy here.
	L0: 					#Set a0 equal to blue.
	addi $gp, $gp, 4        		#Go to next pixel in display
	sw $t1, -4($gp)        			#Change current pixel to blue			
	j back					#Jump to back. 
	
	L1: 					#Set a0 equal to black.
	addi $gp, $gp, 4        		#Go to next pixel in display
	sw $t2, -4($gp)         		#Change current pixel to black	
	j back					#Jump to back.  
	
	L2: 					#Set a0 equal to yellow.
	addi $gp, $gp, 4        		#Go to next pixel in display
	sw $t3, -4($gp)         		#Change current pixel to yellow   
	move $v1, $s1				#Save player position column.
	move $s7, $s2				#Save the player position and print to check.								
	j back					#Jump to back.  
	
	L3: 					#Set a0 equal to green.
	addi $gp, $gp, 4        		#Go to next pixel in display
	sw $t4, -4($gp)         		#Change current pixel to green	
	j back		  			#Jump to back.  
	
	L4:
	add $s3, $s3, 1				#Add 1 to s3.
	add $s1, $s1, 1				#Add 1 to the row counter.
	li $s2, 0				#Reset Column	
	j MazeCreater				#Jump to rowLoop
	
Exit:	
	
	move $v0, $s7				#Move s7 to v0, rhis is the return value player row.
	li $v0, 16 				#Close file system call.
	move $a3, $s6 				#Move s6 to a3.
	syscall 				#Close file.
	jr $ra		
								
########################################################################################
#######################################################################################
ProcessInput:
	Input:		
	move $s6, $s1 				#Copy current row position to new.
	move $s7, $s2				#Copy current column position to new.	 		
	beq $a0, 122, L00			#Check if a0 = z if so jump to case L0.	
	beq $a0, 115, L01			#Check if a0 = s if so jump to case L1.
	beq $a0, 113, L02			#Check if a0 = q if so jump to case L2.
	beq $a0, 100, L03			#Check if a0 = 100 if so jump to case L3.
	beq $a0, 120, ExitEnd			#Check if a0 = 120 if so jump to exit.
	j Input   				#Start again.

	Table:	
	L00: add $s7, $s7, 1			#Move 1 position up.	
	j AssessMove
	L01: add $s7, $s7, -1			#Move 1 position down.
	j AssessMove
	L02: add $s6, $s6, 1			#Move 1 position to the right.
	j AssessMove
	L03: add $s6, $s6, -1			#Move 1 position to the left. 
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
	ExitEnd:
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
input:
	.eqv RCR 0xffff0000     	#Receiver Control Register (Ready Bit).
        .eqv RDR 0xffff0004     	#Receiver Data Register (Key Pressed - ASCII).
        .eqv TCR 0xffff0008     	#Transmitter Control Register (Ready Bit).
        .eqv TDR 0xffff000c     	#Transmitter Data Register (Key Displayed- ASCII).	
		 
	lw $t0, RCR			#Load Ready bit in t0.
        andi $t0, $t0, 1		#Check if t0 and t0 = 1. (same bit)
        beq $t0, $zero, sleep      	#If t0 is empty then go to sleep (This is always true because this is loaded before you input a key).

display:    
	lw $t1, TCR			#Load ready bit into t1.
        andi $t1, $t1, 1		#Check if t0 and t0 = 1. (same bit)
        beq $t1, $zero, display		#If t1 is empty then start over again.
        sb $a0, TDR			#Store the value from TDR in a0.
        sb $zero, RDR			#Empty RDR adress.
        li $v0, 11 			#Load Value into v0	
        syscall 	
        j input   			#Jump to keywait
	
sleep: 
	li $v0, 32			
	li $a0, 60			#Sleep for 60ms.
	syscall				#System Call.
	lbu $a0, RDR			#Set a0 to value of RDR (pressed key).
	bge $a0, 1, display	        #If a0(input value) is bigger than 1 (this is always true if a key has been pressed).
	j sleep				#Otherwise go to print.
		
printLoop:
	lw	$t1,8($t0)		#Read control bit.
	andi	$t1,$t1,0x0001  	#Get ready bit. 
	beq	$t1,$0,printLoop	#When t1 = 0 start this loop over.
	sw	$a0, 0xc($t0)		#Write the string.
	jr	$ra			#Jump back.
########################################################################################	
	
	
	
#Starting Point	

main:	
		
	jal MazeCreater				#This fuction can give back v0,v1 (Current player row and column.)
	move $t1, $v0				#Get procedure result
	move $t2, $v1				#Get procedure result
	move $a0, $t0				#Put procedure arguments.
	move $s1, $t1				#Put procedure arguments.
	move $s2, $t2				#Put procedure arguments
	jal ProcessInput			#This fuction takes 3 arguments which is inputkey, player position:row,column.
	move $t1, $v0				#Get procedure result
	move $t2, $v1				#Get procedure result
	#This should be a loop.
	
exit:
	li $v0, 10				#System call code for exit = 10
	syscall					#Call operating sys