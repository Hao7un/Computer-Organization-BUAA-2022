.text
####测试存取指令
lui $t0,65535
ori $t0,65516	#t0 is -20		
##base<0
	#offset>0
	ori $s1,0x0001
	sw $s1,24($t0)	#4 is s1
	lw $s2,24($t0)
	
##base=0
	#offset=0
	ori $s1,0x0010	#0 is s1
	sw $s1,0($0)
	lw $s3,0($0)
	#offset>0
	ori $s1,0x0100
	sw $s1,8($0)	#8 is s1
	lw $s4,8($0)
##base>0
	ori $t1,20
	#offset<0
	ori $s1,0x1000
	sw $s1,-8($t1)
	lw $s5,-8($t1)
	#offset=0
	ori $t2,0x0001
	sw $s1,0($t1)
	lw $s6,0($t1)
	#offset>0
	ori $t2,0x0010
	sw $s1,4($t1)
	lw $s7,4($t1)
