.data
	array: .space 4000

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
########initialize########
	li $t0,0
	li $t1,1000
	li $t3,1
	start:
	beq $t0,$t1,end
	sll $t2,$t0,2
	sw $t3,array($t2)
	addi $t0,$t0,1
	j start
	end:
#########################

	scanf($s0)	#$s0 is n
	li $s1,1	#s1 is c
	li $t0,1	#$t0 is i
	
	loop1_start:
	bgt $t0,$s0,loop1_end
	li $s2,0 	#s2 is up 进位
	
	li $t1,0	#t1 is j
	loop2_start:
	beq $t1,$s1,loop2_end
	sll $t2,$t1,2
	lw $t3,array($t2)	#a[j]--array($t2)
	mul $t3,$t3,$t0
	add $t3,$t3,$s2		#t3 is s
	
	li $t4,10
	div $t3,$t4
	mfhi $t5
	sw $t5,array($t2)
	mflo $s2
	
	addi $t1,$t1,1
	j loop2_start
	loop2_end:
	
	loop3_start:
	beq $s2,$zero,loop3_end
	sll $t3,$s1,2
	li $t1,10
	div $s2,$t1
	
	mfhi $t2
	sw $t2,array($t3)
	addi $s1,$s1,1
	mflo $s2
	j loop3_start
	loop3_end:
	
	addi $t0,$t0,1
	j loop1_start
	loop1_end:

	##输出
	addi $t0,$s1,-1
	loop4_start:
	blt $t0,$zero,loop4_end
	sll $t1,$t0,2
	lw $t1,array($t1)
	printf($t1)
	
	addi $t0,$t0,-1
	j loop4_start
	loop4_end:
	
	li $v0,10
	syscall
	
	
