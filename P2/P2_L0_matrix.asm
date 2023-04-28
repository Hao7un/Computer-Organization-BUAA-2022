.data
	array1:.space 256 #8*8*4
	array2:.space 256 #8*8*4
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

.macro  getindex(%ans,%row,%col)
    li %ans,0    
    mul %ans,%row,$t0
    add %ans,%ans,%col
    sll %ans,%ans,2
.end_macro

.text
	#初始化
	scanf($t0)  	#t0 is n
	li $s1,0		#s1 is row counter
	li $s2,0		#s2 is column counter
	#########################################
	loop1_start:
	beq $s1,$t0,loop1_end
	li $s2,0
	loop2_start:
	beq $s2,$t0,loop2_end
	getindex($s3,$s1,$s2) #s3 is index
	scanf($t1)
	sw $t1,array1($s3)
	addi $s2,$s2,1
	j loop2_start
	loop2_end:

	addi $s1,$s1,1
	j loop1_start
	loop1_end:
	###########################################
	li $s1,0		#s1 is row counter
	li $s2,0		#s2 is column counter
	
	loop3_start:
	beq $s1,$t0,loop3_end
	li $s2,0
	loop4_start:
	beq $s2,$t0,loop4_end
	getindex($s3,$s1,$s2) #s3 is index
	scanf($t1)
	sw $t1,array2($s3)
	addi $s2,$s2,1
	j loop4_start
	loop4_end:
	addi $s1,$s1,1
	j loop3_start
	loop3_end:
########################################
	li $s1,0		#s1 is row counter
	li $s2,0		#s2 is column counter
	
	loop5_start:
	beq $s1,$t0,loop5_end
	li $s2,0
	loop6_start:
	beq $s2,$t0,loop6_end

	#####
	li $s3,0				#s3 is a counter
	li $s4,0				#s4 is ans
	loop7_start:	
	beq $s3,$t0,loop7_end
		getindex($t1,$s1,$s3)
		getindex($t2,$s3,$s2)
		lw $t3,array1($t1)
		lw $t4,array2($t2)
		mul $t5,$t3,$t4
		add $s4,$s4,$t5
	addi $s3,$s3,1
	j loop7_start
	loop7_end:	
	####

	printf($s4)	
	print_space()
	addi $s2,$s2,1
	j loop6_start

	loop6_end:
	print_enter()
	addi $s1,$s1,1
	j loop5_start
	
	loop5_end:
	li $v0,10
	syscall