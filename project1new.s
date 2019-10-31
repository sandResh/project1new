.data # Data section begins here.
	input: 	    	.space		11       # Input contains 10 chars plus an endline char.
    inputPrompt:    .asciiz     "Input 10 charactered alphanumeric string: "
    newLine: 		.asciiz 	"\n"


.text # Text section begins here. 
  	main:
	    # Prompt the user to input a 10 char aplhanumeric string.
	    li $v0, 4
	    la $a0, inputPrompt
	    syscall

	    # Input the string.
	    li $v0, 8
	    la $a0, input
	    li $a1, 11
	    syscall

	    jal printNewLine

	    # Store input string in $s0.
	    la $s0, input

	   	# Store the result in $s2 and offset in $s1.
	   	li $s2, 0
	   	li $s1, 0

	   	loop1:
	   		# changing byte offset.
	   		add $t0, $s0, $s1
	   		lb $t1, ($t0)

	   		beq $t1, 10, exitLoop1
	   		beq $t1, 0, exitLoop1

	   		# print the char
	   		li $v0, 11
	   		add $a0, $t1, $0
	   		syscall

	   		add $a0, $t1, $0
	   		jal getNumberFromByte

	   		li $v0, 1
	   		add $a0, $v1, $0
	   		syscall

	   		jal printNewLine

	   		add $s2, $s2, $v1

	   		# The loop hasn't completed; so go back to the start.
	   		addu $s1, $s1, 1
	   		b loop1

	   	exitLoop1:

	   	# Print the integer.
	   	li $v0, 1
	   	add $a0, $s2, $0
	   	syscall

	    # Exit the program
	    li $v0, 10
	    syscall

	getNumberFromByte:
		li $v0, 0

		blt $a0, 48, exitNFB
		bgt $a0, 116, exitNFB

		slti $t8, $a0, 58		# If the char is less than 59, the char is a number
		beq $t8, 1, numbers

		blt $a0, 65, exitNFB   # If the byte falls betweeen 59
		
		slti $t8, $a0, 85		# If the char is less than 84 ('T') and greater than 64, the char is captial letter
		beq $t8, 1, capital

		blt $a0, 97, exitNFB    # IF the char comes before 'a'.
		
		slti $t8, $a0, 117		# If the char is less than 103, and greater than 71, the char is small letter
		beq $t8, 1, small
		
		numbers:
			addi $v1, $a0, -48	# subtract 48 from the numbers to get the decimal value
			b exitNFB 
		capital:
			addi $v1, $a0, -55	# subtract 55 from the capital letters to get the decimal value
			b exitNFB 
		small:
			addi $v1, $a0, -87	# subtract 87 from the small letters to get the decimal value
		exitNFB:
			jr $ra

	printNewLine:  # Function to call newLine
		li $v0, 4
		la $a0, newLine
		syscall

		jr $ra


