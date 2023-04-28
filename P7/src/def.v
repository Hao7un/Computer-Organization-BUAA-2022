//-----DataPath----//
`define AdEL 4
`define AdES 5
`define Syscall 8
`define RI 10
`define Ov 12
`define NoneExc 0

//----NPC----//
`define NPC_PlusFour 3'b000
`define NPC_Branch  3'b001
`define NPC_Jump    3'b010
`define NPC_JumpReg 3'b011

//----CMP----//
`define CMP_beq 3'b001 
`define CMP_bne 4'b010

//----EXT----//
`define EXT_ZeroExtend 2'b00
`define EXT_SignExtend 2'b01
`define EXT_lui		  2'b10

//----ALU----//
`define ALU_add  4'b0000
`define ALU_sub  4'b0001
`define ALU_or   4'b0010
`define ALU_and   4'b0011
`define ALU_slt  4'b0100
`define ALU_sltu  4'b0101
`define ALU_srl    4'b0110

//----HILO----//
//--md--//
`define HILO_mult 4'd1
`define HILO_multu 4'd2
`define HILO_div 4'd3
`define HILO_divu 4'd4
//--mf--//
`define HILO_mfhi 4'd5
`define HILO_mflo 4'd6
//--mt--//
`define HILO_mthi 4'd7
`define HILO_mtlo 4'd8

//-----BE----//
`define DM_sb 4'd1
`define DM_sh 4'd2
`define DM_sw 4'd3
`define DM_lb 4'd4
`define DM_lh 4'd5
`define DM_lw 4'd6


//----Control----//

//----宏定义----//

`define R_Type 6'b000000

//----cal_r----//          
`define add_Funct 6'b100000
`define sub_Funct 6'b100010
`define and_Funct 6'b100100 
`define or_Funct  6'b100101
`define slt_Funct  6'b101010
`define sltu_Funct 6'b101011
`define srl_Funct  6'b000010

//----cal_i----//     
`define ori_Op 6'b001101
`define addi_Op 6'b001000
`define andi_Op 6'b001100

//----lui----//
`define lui_Op 6'b001111

//----branch----//
`define beq_Op 6'b000100
`define bne_Op 6'b000101

//----load-----//           
`define lw_Op  6'b100011
`define lh_Op  6'b100001
`define lb_Op  6'b100000

//----store----//
`define sw_Op  6'b101011
`define sh_Op  6'b101001
`define sb_Op  6'b101000

//----jumplink----//
`define jal_Op 6'b000011  

//----jumpreg----//
`define jr_Funct  6'b001000

//----md----//
`define mult_Funct  6'b011000
`define multu_Funct 6'b011001
`define div_Funct   6'b011010
`define divu_Funct  6'b011011

//----mf----//
`define mfhi_Funct  6'b010000
`define mflo_Funct  6'b010010

//----mt----//
`define mthi_Funct  6'b010001
`define mtlo_Funct  6'b010011

//----CP0-----//
`define CP0_Type    6'b010000
`define eret_Funct    6'b011000
`define mfc0_Rs  5'b00000
`define mtc0_Rs  5'b00100
`define syscall_Funct 6'b001100