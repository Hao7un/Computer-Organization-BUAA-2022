.data
	array: .space 80 #20*4

.macro scanf_int(%i)
      li $v0,5
      syscall
      move %i,$v0
.end_macro

.macro scanf_char(%i)
      li $v0,12
      syscall
      move %i,$v0
.end_macro

.text
	scanf_int($t0)  #t0 is n
	li $s0,0	#$s0 is counter
	
	loop1_start:
	beq $s0, $t0, loop1_end
	scanf_char($t1)	#t1 is character
	sll $s1,$s0,2
	sw $t1,array($s1)
	addi $s0,$s0,1
	j loop1_start
	
	loop1_end:
	li $s1,0			#left
	move $s2,$t0	
	addi $s2,$s2,-1		#right
	
	loop2_start:
	bge $s1,$s2,loop2_end
	sll $t1,$s1,2
	sll $t2,$s2,2
	
	lw $t3,array($t1)
	lw $t4,array($t2)
	
	seq $t5,$t3,$t4 	#ok---t5=1
	beq $t5,$0,output
	addi $s1,$s1,1
	addi $s2,$s2,-1
	j loop2_start
	loop2_end:
	li $a0,1
	li $v0,1
	syscall	
	li $v0,10
	syscall
	
	output:
	li $a0,0
	li $v0,1
	syscall
	li $v0,10
	syscall
