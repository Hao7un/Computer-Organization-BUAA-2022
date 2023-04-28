####跳转类测试
##j指令测试
ori $t1,$t1,4369	
j test1

ori $t2,$t2,4369	
test1:			#j:向前跳转测试

ori $t3,$t3,4369
j test2	

test3:			#j：向后跳转测试
ori $t5,$t5,4369
j end1

test2:
ori $t4,$t4,4369
j test3

end1:
ori $t6,$t6,4369

##jal指令测试
jal test4
ori $s7,$0,0x1111
j beq_test
##jr指令测试
test4:
add $t7,$ra,$0	#将ra的值存到t7之中
jr $ra

beq_test:
ori $t8,$t8,0x1111
ori $t9,$t9,0x1111
j branch1
##beq指令测试

#跳转且目标在指令之前
branch1_test:
ori $s0,$s0,0x1010
j branch3

branch1:

beq $t8,$t9,branch1_test
ori $s0,$s0,0x1111
j branch3

#跳转且目标就是这条指令
#branch2:
#beq $t8,$t9,branch2
#ori $s1,0x1010
#j branch3

branch3:
#跳转且目标在指令之后
beq $t8,$t9,branch3_test
ori $s2,$s2,0x1111
j branch4
branch3_test:
ori $s2,$s2,0x1010
j branch4

#不跳转且目标在指令之前
branch4_test:
ori $s3,$s3,0x1010
j branch5

branch4:
add $t8,$0,$0
ori $t8,$t8,0x111
beq $t8,$t9,branch4_test
ori $s3,$s3,0x1111
j branch5

branch5:
#不跳转且目标就是这条指令
beq $t8,$t9,branch5
ori $s4,$s4,0x1111
j branch6

branch6:
#不跳转且目标在指令之后
beq $t8,$t9,branch6_test
ori $s5,$s5,0x1111
j end

branch6_test:
ori $s5,$s5,0x1010
j end

end:


