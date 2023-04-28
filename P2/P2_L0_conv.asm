.data
	array1:.space 400 #10*10*4
	array2:.space 400 #10*10*4
	space:.asciiz " "
	enter:.asciiz "\n"

.macro scanf(%i)
      li $v0,5
      syscall
      move %i,$v0
.end_macro

.macro printf(%i)
      move $a0,%i
      li $v0,1
      syscall
.end_macro

.macro print_space()
	la $a0,space
	li $v0,4
	syscall
.end_macro

.macro print_enter()
	la $a0,enter
	li $v0,4
	syscall
.end_macro

.macro  getindex(%ans,%row,%col,%num)
    li %ans,0    
    mul %ans,%row,%num
    add %ans,%ans,%col
    sll %ans,%ans,2
.end_macro

.text
	scanf($s0)	#s0 is m1
	scanf($s1)	#s1 is n1
	scanf($s2)	#s2 is m2
	scanf($s3)	#s3 is n2
	
###############################
	li $t0,0	#row counter
	li $t1,0	#column counter
	loop1_start:
	beq $t0,$s0,loop1_end
	li $t1,0
	loop2_start:
		beq $t1,$s1,loop2_end
		getindex($t2,$t0,$t1,$s1)	#t2 is index
		scanf($t3)
		sw $t3,array1($t2)	
	addi $t1,$t1,1
	j loop2_start
	loop2_end:

	addi $t0,$t0,1
	j loop1_start
	loop1_end:
#######################################
	li $t0,0	#row counter
	li $t1,0	#column counter
	loop3_start:
	beq $t0,$s2,loop3_end
	li $t1,0
	loop4_start:
	beq $t1,$s3,loop4_end
		getindex($t2,$t0,$t1,$s3)	#t2 is index
		scanf($t3)
		sw $t3,array2($t2)	
	addi $t1,$t1,1
	j loop4_start
	loop4_end:

	addi $t0,$t0,1
	j loop3_start
	loop3_end:	
#####################################
	li $t0,0	#row counter
	li $t1,0	#column counter
	sub $s4,$s0,$s2
	sub $s5,$s1,$s3
	loop5_start:
	bgt $t0,$s4,loop5_end
	li $t1,0
	loop6_start:
	bgt $t1,$s5,loop6_end
	li $t9,0
	#######################################
	
	li $t2,0
	li $t3,0
	loop7_start:
	beq $t2,$s2,loop7_end
	li $t3,0
	loop8_start:
	beq $t3,$s3,loop8_end
	
	add $t4,$t0,$t2
	add $t5,$t1,$t3
	getindex($t6,$t4,$t5,$s1)
	lw $s6,array1($t6)
	
	getindex($t7,$t2,$t3,$s3)
	lw $s7,array2($t7)
	
	mul $t8,$s6,$s7
	add $t9,$t9,$t8
	addi $t3,$t3,1
	j loop8_start
	loop8_end:

	addi $t2,$t2,1
	j loop7_start
	loop7_end:
	
	########################################
	printf($t9)
	print_space()
	addi $t1,$t1,1
	j loop6_start
	loop6_end:
	print_enter()
	addi $t0,$t0,1
	j loop5_start
	loop5_end:
	li $v0, 10
	syscall	
	
	
	
	