.text
    # 只允许外部中断
    ori $t0, $0, 0x1001
    mtc0 $t0, $12

    #ov
    lui $t0, 0x7fff
    lui $t1, 0x7fff
    
    add $t2, $t0, $t1
    addi $t2,$t0,0x7fff
    lui $t0,0xffff
    lui $t1,0xffff
    sub $t2,$t0,$t1
    
    #adel
    	#ALign
    lb $0,-1($0)
    lb $0,-2($0)
    lb $0,-3($0)
    lb $0,0($0)
    lb $0,1($0)
    lb $0,2($0)
    lb $0,3($0)
    
    lh $0,-1($0)
    lh $0,-2($0)
    lh $0,-3($0)
    lh $0,0($0)
    lh $0,1($0)
    lh $0,2($0)
    lh $0,3($0)
    
    lw $0,-1($0)
    lw $0,-2($0)
    lw $0,-3($0)
    lw $0,0($0)
    lw $0,1($0)
    lw $0,2($0)
    lw $0,3($0)
    
    	#Timer
    ori $t0,$0,0x7f00
    lb $0,0($t0)
    lh $0,0($t0)
    
    	#Range
    ori $t0,$0,0x3000
    lb $0,0($t0)
    lh $0,0($t0)
    lw $0,0($0)

    #ades
    sb $0,-1($0)
    sb $0,-2($0)
    sb $0,-3($0)
    sb $0,0($0)
    sb $0,1($0)
    sb $0,2($0)
    sb $0,3($0)
    
    sh $0,-1($0)
    sh $0,-2($0)
    sh $0,-3($0)
    sh $0,0($0)
    sh $0,1($0)
    sh $0,2($0)
    sh $0,3($0)
    
    sw $0,-1($0)
    sw $0,-2($0)
    sw $0,-3($0)
    sw $0,0($0)
    sw $0,1($0)
    sw $0,2($0)
    sw $0,3($0)
    
    	#Timer
    ori $t0,$0,0x7f00
    sb $0,0($t0)
    sh $0,0($t0)
    
    	#Range
    ori $t0,$0,0x3000
    sb $0,0($t0)
    sh $0,0($t0)
    sw $0,0($0)
    
    	#Count
    ori $t0,$0,0x7f08
    sb $0,0($0)
    sh $0,0($0)
    sw $0,0($0)


    #syscall
    ori $t0,0
    syscall
    ori $t1,0


    #delay_slot_test
    lui $t0, 0x7fff
    lui $t1, 0x7fff    
    jal label:
    add $t2, $t0, $t1

label:
	ori $t0,0
	ori $t1,0