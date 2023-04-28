.data
	symbol:.space 28 #7*4
	array:.space 28 #7*4
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

.text
	scanf($s0) 	#s0 is n
	li $s1,0	#s1 is index
	jal FullArray
	
	li $v0,10
	syscall
	
	FullArray:	#$ra,index and i  sp-12

	li $t0,0
	blt $s1,$s0,loop2_start
	
	loop1_start:
		beq $t0,$s0,loop1_end
		sll $t1,$t0,2
		lw $t1,array($t1)
		printf($t1)
		print_space
		add $t0,$t0,1
		j loop1_start
	
	loop1_end:
	print_enter()
	jr $ra

	
	loop2_start:
	beq $t0,$s0,loop2_end # t0 is i
		sll $t1,$t0,2
		lw $t5,symbol($t1)
		bne $t5,$zero,next
		
		sll $t2,$s1,2
		addi $t3,$t0,1	#i+1
		sw $t3,array($t2)	#array[index]=i+1
		li $t4,1
		sw $t4,symbol($t1)	#symbol[i]=1
		
		subi $sp,$sp,12
		sw $ra,0($sp)	#ra
		sw $s1,4($sp)	#index
		sw $t0,8($sp)	#i
	
		addi $s1,$s1,1 #index+1
		jal FullArray
		
		lw $ra,0($sp)	#ra
		lw $s1,4($sp)	#index
		lw $t0,8($sp)	#i
		add $sp,$sp,12
	
		sll $t1,$t0,2
		sw $0,symbol($t1)	#symbol[i]=0
	next:
	add $t0,$t0,1
	j loop2_start

	loop2_end:
		jr $ra
