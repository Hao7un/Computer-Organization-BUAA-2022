.ktext 0x4180
_entry:	
	mfc0	$1, $13
	ori		$k0, $0, 0x1000
	sw		$sp, -4($k0)

	addi	$k0, $k0, -256
	addi 	$sp, $k0,0
	
	beq $0,$0,_save_context
	nop

_main_handler:		
	mfc0	$k0, $13           		#读出异常编码
    ori $k1, $0, 0x7c
    and $k0, $k0, $k1

	ori	$k1, $0, 0x0000		   		#中断
	beq	$k0, $k1, int_handler
	nop
	
	ori	$k1, $0, 0x0004		    	#取指令/数据错误
	beq	$k0, $k1, adel_handler
	nop
	ori	$k1, $0, 0x0005					#存数据错误
	beq	$k0, $k1, ades_handler
	nop
	ori	$k1, $0, 0x000a					#未知指令
	beq	$k0, $k1, ri_handler
	nop
	ori	$k1, $0, 0x000c					#溢出
	beq	$k0, $k1, ov_handler
	nop

int_handler:
	beq $0,$0,_restore_context	#直接返回
	nop

adel_handler:
	mfc0	$t0, $14
	mfc0	$k0, $13
	lui	$t2, 0x8000		#is delay_slot?
	and	$t3, $k0, $t2
	addi	$t0, $t0, 4
	bne	$t3, $t2, adel_nxt
	nop
	addi	$t0, $t0, 4
	adel_nxt:
	mtc0	$t0, $14
	beq $0,$0,_restore_context
	nop

ades_handler:
	mfc0	$t0, $14
	mfc0	$k0, $13
	lui	$t2, 0x8000
	and	$t3, $k0, $t2
	addi	$t0, $t0, 4
	bne	$t3, $t2, ades_nxt
	nop
	addi	$t0, $t0, 4
	ades_nxt:
	mtc0	$t0, $14
	beq	 $0,$0,_restore_context
	nop
	

ri_handler:
	mfc0	$t0, $14
	mfc0	$k0, $13
	lui	$t2, 0x8000
	and	$t3, $k0, $t2
	addi	$t0, $t0, 4
	bne	$t3, $t2, ri_nxt
	nop
	addi	$t0, $t0, 4
	ri_nxt:
	mtc0	$t0, $14
	beq $0,$0,_restore_context
	nop
	
ov_handler:
	mfc0	$t0, $14
	mfc0	$k0, $13
	lui	$t2, 0x8000
	and	$t3, $k0, $t2
	addi	$t0, $t0, 4
	bne	$t3, $t2, ov_nxt
	nop
	addi	$t0, $t0, 4
	ov_nxt:
	mtc0	$t0, $14
	beq $0,$0,_restore_context
	nop

_restore:
	eret

_save_context:
    	sw  	$2, 8($sp)    
    	sw  	$3, 12($sp)    
    	sw  	$4, 16($sp)    
    	sw  	$5, 20($sp)    
    	sw  	$6, 24($sp)    
    	sw  	$7, 28($sp)    
    	sw  	$8, 32($sp)    
    	sw  	$9, 36($sp)    
    	sw  	$10, 40($sp)    
    	sw  	$11, 44($sp)    
    	sw  	$12, 48($sp)    
    	sw  	$13, 52($sp)    
    	sw  	$14, 56($sp)    
    	sw  	$15, 60($sp)    
    	sw  	$16, 64($sp)    
    	sw  	$17, 68($sp)    
    	sw  	$18, 72($sp)    
    	sw  	$19, 76($sp)    
    	sw  	$20, 80($sp)    
    	sw  	$21, 84($sp)    
    	sw  	$22, 88($sp)    
    	sw  	$23, 92($sp)    
    	sw  	$24, 96($sp)    
    	sw  	$25, 100($sp)    
    	sw  	$28, 112($sp)    
    	sw  	$29, 116($sp)    
    	sw  	$30, 120($sp)    
    	sw  	$31, 124($sp)
	mfhi 	$k0
	sw 	$k0, 128($sp)
	mflo 	$k0
	sw 	$k0, 132($sp)
	beq $0,$0,_main_handler
	nop
	

_restore_context:
	addi	$sp, $0,  0x1000
	addi	$sp, $sp, -256
    	lw  	$2, 8($sp)    
    	lw  	$3, 12($sp)    
    	lw  	$4, 16($sp)    
    	lw  	$5, 20($sp)    
    	lw  	$6, 24($sp)    
    	lw  	$7, 28($sp)    
    	lw  	$8, 32($sp)    
    	lw  	$9, 36($sp)    
    	lw  	$10, 40($sp)    
    	lw  	$11, 44($sp)    
    	lw  	$12, 48($sp)    
    	lw  	$13, 52($sp)    
    	lw  	$14, 56($sp)    
    	lw  	$15, 60($sp)    
    	lw  	$16, 64($sp)    
    	lw  	$17, 68($sp)    
    	lw  	$18, 72($sp)    
    	lw  	$19, 76($sp)    
    	lw  	$20, 80($sp)    
    	lw  	$21, 84($sp)    
    	lw  	$22, 88($sp)    
    	lw  	$23, 92($sp)    
    	lw  	$24, 96($sp)    
    	lw  	$25, 100($sp)    
    	lw  	$28, 112($sp)   
    	lw  	$30, 120($sp)    
    	lw  	$31, 124($sp)    
	lw 		$k0, 128($sp)
	mthi 	$k0
	lw 		$k0, 132($sp)
	mtlo 	$k0
    lw  	$29, 116($sp) 
	ori     $1,$0,1
    beq $0,$0,_restore	
	nop	