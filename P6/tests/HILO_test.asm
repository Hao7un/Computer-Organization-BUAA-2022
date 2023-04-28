ori $t0,$t0,100
ori $t1,$t1,12313
ori $t2,$t2,32422
lui $t3,0x1111
ori $t3,$t3,0x1111

mult $t1,$t2
mfhi $s0
mflo $s1

multu $t2,$t3
mfhi $s0
mflo $s1

div $t1,$t2
mfhi $s0
mflo $s1

divu $t2,$t3
mfhi $s0
mflo $s1

ori $s3,$s3,100
mthi $s3
mtlo $s3
mult $t1,$t2
mfhi $s0
mflo $s1










