.globl main
.data
	File: .asciiz "c:\\check.txt" 		#Filename for input
	buffer: .space 2048 			#Space used as buffer

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
	la $a1, buffer  			#Put content of buffer in a1.
	li $a2, 2048				#Max characters.
	syscall 				#Write to file. 				
 	la $a0, buffer        			#Load buffer in a0 to print.	
 					
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
#Starting Point	

main:	
		
	jal MazeCreater				#This fuction can give back v0,v1 (Current player row and column.)
	
exit:
	li $v0, 10				#System call code for exit = 10
	syscall					#Call operating sys
		
	

