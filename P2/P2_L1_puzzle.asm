.data
	array:.space 400 #10*10*4
	flag:.space 400 #10*10*4
	
.macro  getindex(%ans,%row,%col)
    li %ans,0    
    mul %ans,%row,$s1
    add %ans,%ans,%col
    sll %ans,%ans,2
.end_macro

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

.text
	scanf($s0)	#s0 is n
	scanf($s1)	#s1 is m
###################################
	li $t0,0	#row counter
	li $t1,0	#column counter

	loop1_start:
	beq $t0,$s0,loop1_end
	li $t1,0
	loop2_start:
		beq $t1,$s1,loop2_end
		scanf($t3)
		getindex($t4,$t0,$t1)
		sw $t3,array($t4)
			
	addi $t1,$t1,1
	j loop2_start
	loop2_end:
	addi $t0,$t0,1
	j loop1_start
	loop1_end:
###############################
	scanf($s3)
	subi $s3,$s3,1
	scanf($s2)
	subi $s2,$s2,1
	
	scanf($s5)
	subi $s5,$s5,1
	scanf($s4)
	subi $s4,$s4,1
	
	jal DFS
	printf($s7)
	li $v0,10
	syscall	
###################################
	
	DFS:
	#if is destination
	#jump back cnt+1
	seq $t0,$s2,$s4
	seq $t1,$s3,$s5
	and $t0,$t0,$t1
	beq $t0,$zero,start
	addi $s7,$s7,1	#find a way!
	jr $ra
	
	start:
	getindex($t0,$s3,$s2)	
	li $t1,1
	sw $t1,flag($t0)	#flag=1--visited
	
	
	up:
	move $t2,$s2		#up_X
	addi $t3,$s3,-1		#y
	sge $t0,$t3,$zero	#判断是否再矩阵内
	beq $t0,$zero,right
	
	getindex($t4,$t3,$t2)
	lw $t5,flag($t4)
	bne $t5,$zero,right
	
	lw $t5,array($t4)
	bne $t5,$zero,right

	subi $sp,$sp,12
	sw $s2,0($sp)		#store current position
	sw $s3,4($sp)
	sw $ra,8($sp)	

	addi $s3,$s3,-1 #满足条件
	jal DFS
	lw $s2,0($sp)	
	lw $s3,4($sp)
	lw $ra,8($sp)	
	addi $sp,$sp,12
	
	#right
	right:
	addi $t2,$s2,1		#right x
	move $t3,$s3		#y
	slt $t0,$t2,$s1
	beq $t0,$zero,down
	getindex($t4,$t3,$t2)
	lw $t5,flag($t4)
	bne $t5,$zero,down

	lw $t5,array($t4)
	bne $t5,$zero,down

	subi $sp,$sp,12
	sw $s2,0($sp)		#store current position
	sw $s3,4($sp)
	sw $ra,8($sp)	

	addi $s2,$s2,1 #满足条件
	jal DFS
	lw $s2,0($sp)	
	lw $s3,4($sp)
	lw $ra,8($sp)	
	addi $sp,$sp,12	
	
	#down
	down:
	move $t2,$s2		#down x
	addi $t3,$s3,1		#y
	slt $t0,$t3,$s0
	beq $t0,$zero,left
	getindex($t4,$t3,$t2)
	lw $t5,flag($t4)
	bne $t5,$zero,left

	lw $t5,array($t4)
	bne $t5,$zero,left

	subi $sp,$sp,12
	sw $s2,0($sp)		#store current position
	sw $s3,4($sp)
	sw $ra,8($sp)	

	addi $s3,$s3,1 #满足条件
	jal DFS
	lw $s2,0($sp)	
	lw $s3,4($sp)
	lw $ra,8($sp)	
	addi $sp,$sp,12		
	
	#left
	left:
	addi $t2,$s2,-1		#left x
	move $t3,$s3		#y
	sge $t0,$t2,$zero
	beq $t0,$zero,end
	getindex($t4,$t3,$t2)
	lw $t5,flag($t4)
	bne $t5,$zero,end

	lw $t5,array($t4)
	bne $t5,$zero,end

	subi $sp,$sp,12
	sw $s2,0($sp)		#store current position
	sw $s3,4($sp)
	sw $ra,8($sp)	

	addi $s2,$s2,-1 #满足条件
	jal DFS
	lw $s2,0($sp)	
	lw $s3,4($sp)
	lw $ra,8($sp)	
	addi $sp,$sp,12	
	
	#end
	end:	#已经访问完全，撤回到上一步
	getindex($t0,$s3,$s2)	
	sw $zero,flag($t0)
	jr $ra
	
	
			
	
