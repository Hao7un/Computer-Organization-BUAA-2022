init:
    add $28,$0,$0
    add $29,$0,$0
    add $30,$0,$0
    add $31,$0,$0
    ori $28,$28,4

#D级Rs
block1:		#E jal
addi $t0,$0,10     
jal block2		
add $t0,$ra,$0      

block2:		#E lui
addi $t0,$0,10     
lui $t1,0x1111     
add $t0,$t1,$0    

block3:		#M_jal
addi $t0,$0,10
jal block4
nop
add $t0,$ra,$0

block4:		#M_lui
addi $t0,$0,10
lui $t1,0x1111
nop
add $t0,$t1,$0

block5:		#M_cal_r
addi $t0,$t0,10
addi $t1,$t1,20
nop
add $t2,$t1,$0

block6:		#M_cal_i
addi $t0,$t0,10
addi $t1,$t1,20
nop
ori $t2,$t1,10

block7:		#M_HILO
addi $t0,$t0,10
addi $t1,$t1,20
nop
mult $t0,$t1
mfhi $t2
mflo $t3

block8:		#W_jal
addi $t0,$t0,10
jal block9
nop
nop
add $t0,$ra,$0

block9:		#W_lui
addi $t0,$t0,10
lui $t1,0x1111
nop
nop
add $t0,$t1,$0

block10:	#W_cal_r
addi $t0,$t0,10
addi $t1,$t1,20
nop
nop
add $t2,$t1,$0

block11: #W_cali
addi $t0,$t0,10
addi $t1,$t1,20
nop
nop
ori $t2,$t1,10

block12: #W_HILO
addi $t0,$t0,10
addi $t1,$t1,20
nop
nop
mult $t0,$t1
mfhi $t2
mflo $t3

block13: #W_load
addi $t1,$t1,10
addi $t0,$0,0
lw $t1,($t0)
nop
nop
add $t2,$t1,$0

#D级Rt
block14:		#E jal
addi $t0,$0,10     
jal block15		
add $t0,$0,$ra     

block15:		#E lui
addi $t0,$0,10     
lui $t1,0x1111     
add $t0,$0,$t1    

block16:		#M_jal
addi $t0,$0,10
jal block17
nop
add $t0,$0,$ra

block17:		#M_lui
addi $t0,$0,10
lui $t1,0x1111
nop
add $t0,$0,$t1

block18:		#M_cal_r
addi $t0,$t0,10
addi $t1,$t1,20
nop
add $t2,$0,$t1

block19:		#M_HILO
addi $t0,$t0,10
addi $t1,$t1,20
nop
mult $t0,$t1
mfhi $t2
mflo $t3

block20:		#W_jal
addi $t0,$t0,10
jal block21
nop
nop
add $t0,$0,$ra

block21:		#W_lui
addi $t0,$t0,10
lui $t1,0x1111
nop
nop
add $t0,$0,$t1

block22:	#W_cal_r
addi $t0,$t0,10
addi $t1,$t1,20
nop
nop
add $t2,$0,$t1


block23: #W_HILO
addi $t0,$t0,10
addi $t1,$t1,20
nop
nop
mult $t0,$t1
mfhi $t2
mflo $t3

block24: #W_load
addi $t1,$0,10
addi $t0,$0,0
lw $t1,($t0)
nop
nop
add $t2,$0,$t1

#E_Rs
block25:	#M_jal
jal block26
add $t0,$ra,$0

block26:	#M_lui
addi $t0,$0,1    
lui $t1,100 
add $t2,$t1,$0  
nop		

block27:	#M_cal_r
addi $t0,$0,1    
add $t1,$0,$t0  
add $t2,$t1,$0  
nop		

block28:	#M_cal_i
ori $t0,$0,1    
ori $t1,$0,100 
add $t2,$t1,$0 

block29:	#M_Hilo
addi $t0,$0,10
addi $t1,$0,20
mult $t0,$t1
mflo $t2
add $t3,$t2,$0

block30:
jal block31
nop
add $t0,$ra,$0
 
block31:
addi $t0,$0,1    
lui $t1,100 
nop
add $t2,$t1,$0  

block32:
addi $t0,$0,1    
add $t1,$0,$t0  
nop
add $t2,$t1,$0 

block33:
addi $t0,$0,1    
ori $t1,$0,100 
nop
add $t2,$t1,$0 

block34:
ori $t1,$0,10
ori $t0,$0,0
lw $t1,0($t0)
nop
add $t2,$t1,$0

block35:
addi $t0,$0,10
addi $t1,$0,20
mult $t0,$t1
mflo $t2
nop
add $t3,$t2,$0

#E_Rt
block36:	#M_jal
jal block37
add $t0,$0,$ra

block37:	#M_lui
addi $t0,$0,1    
lui $t1,100 
add $t2,$0,$t1
nop		

block38:	#M_cal_r
addi $t0,$0,1    
add $t1,$0,$t0  
add $t2,$0,$t1 
nop		

block39:	#M_cal_i
ori $t0,$0,1    
ori $t1,$0,100 
add $t2,$0,$t1

block40:	#M_Hilo
addi $t0,$0,10
addi $t1,$0,20
mult $t0,$t1
mflo $t2
add $t3,$0,$t2

block41:
jal block42
nop
add $t0,$0,$ra
 
block42:
addi $t0,$0,1    
lui $t1,100 
nop
add $t2,$0,$t1

block43:
addi $t0,$0,1    
add $t1,$0,$t0  
nop
add $t2,$0,$t1 

block44:
addi $t0,$0,1    
ori $t1,$0,100 
nop
add $t2,$0,$t1 

block45:
ori $t1,$t1,10
ori $t0,$0,0
lw $t1,0($t0)
nop
add $t2,$0,$t1

block46:
addi $t0,$0,10
addi $t1,$0,20
mult $t0,$t1
mflo $t2
nop
add $t3,$0,$t2

#M_Rt
block47:
jal block48
sw $ra,0($0)

block48:
addi $t0,$0,0
lui $t0,0x1111
sw $t0,0($0)

block49:
addi $t0,$t0,100
add $t1,$t0,$0
sw $t1,0($0)

block50:
addi $t0,$t0,100
add $t1,$t0,$0
sw $t1,0($0)

block51:
addi $t0,$t0,100
lw $t0,($0)
sw $t0,($0)

block52:	#W级HILO
addi $t0,$0,10
addi $t1,$0,10
mult $t0,$t1
mflo $t2
sw $t2,($0)

##STALL TEST

#branch
block53:
addi $t0,$t0,1
add $t1,$t0,$0
beq $t0,$t1,label1
nop
label1:
add $s0,$0,$0

block54:
addi $t0,$t0,1
addi $t1,$t0,10
beq $t0,$t1,label2
nop
label2:
add $s0,$0,$0

block55:
addi $t0,$t0,1
lw  $t1,($0)
beq $t0,$t1,label3
nop
label3:
add $s0,$0,$0

block56:
addi $s1,$0,100
addi $t0,$t0,10
addi $t1,$t1,10
mult $t0,$t1
mflo $t2
beq $t2,$s1,label4
nop
label4:
add $s0,$0,$0

block57:
addi $t0,$t0,1
lw  $t1,($0)
nop
beq $t0,$t1,label5
nop
label5:
add $s0,$0,$0

#cal_r
block58:
addi $t0,$0,10
nop
lw $t0,($0)
add $t1,$t0,$t0

#cal_i
block59:
addi $t0,$0,10
nop
lw $t0,($0)
ori $t0,$t0,100

#hilo
block60:
addi $t0,$t0,10
addi $t1,$t1,10
sw $t1,($0)
nop
lw $t2,($0)
mult $t1,$t2
mfhi $s0
mflo $s1

#load
block61:
sw $0,($0)
addi $t0,$0,4
lw $t0,($0)
lw $t1,($t0)

#store
block62:
addi $t0,$0,123
lw $t0,($0)
sw $t1,($t0)



