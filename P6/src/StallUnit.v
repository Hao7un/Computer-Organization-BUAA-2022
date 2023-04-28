`timescale 1ns / 1ps

//----宏定义----//

`define R_Type 6'b000000

//Statement：R类型指令定义的是Funct，非R类型定义的是Op

//----cal_r----//    `timescale 1ns / 1ps

//----宏定义----//

`define R_Type 6'b000000

//Statement：R类型指令定义的是Funct，非R类型定义的是Op

//----cal_r----//          
`define add_Funct 6'b100000
`define sub_Funct 6'b100010
`define and_Funct 6'b100100 
`define or_Funct  6'b100101
`define slt_Funct  6'b101010
`define sltu_Funct 6'b101011

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

module StallUnit(
	 input [31:0] Instr_D,
	 input [31:0] Instr_E,
	 input [31:0] Instr_M,
    input [2:0] Tnew_E,
    input [2:0] Tnew_M,
    input [4:0] A1_D,
    input [4:0] A2_D,
    input [4:0] A3_E,
    input [4:0] A3_M,
	 input HILO_busy,
	 input start_E,
	
    output [2:0] Tnew,
    //----A处理----//
    output [4:0] A3,
    output D_REG_en,
    output E_REG_clr,
    output PC_en
);

//----寄存器当前的指令----//
    wire [6:0] Op_D = Instr_D[31:26];
    wire [6:0] Funct_D = Instr_D[5:0]; 

//----cal_r----//
    wire add_D=(Op_D==`R_Type)&&(Funct_D==`add_Funct);
    wire sub_D=(Op_D==`R_Type)&&(Funct_D==`sub_Funct);
	 wire or_D=(Op_D==`R_Type)&&(Funct_D==`or_Funct);
	 wire and_D=(Op_D==`R_Type)&&(Funct_D==`and_Funct);
	 wire slt_D=(Op_D==`R_Type)&&(Funct_D==`slt_Funct);
	 wire sltu_D=(Op_D==`R_Type)&&(Funct_D==`sltu_Funct);
    wire cal_r_D=add_D|sub_D|or_D|and_D|slt_D|sltu_D;

//----cal_i----//
    wire ori_D=(Op_D==`ori_Op);
	 wire andi_D=(Op_D==`andi_Op);
	 wire addi_D=(Op_D==`addi_Op);
    wire cal_i_D=ori_D|andi_D|addi_D;
	 
//----lui----//
	wire lui_D=(Op_D==`lui_Op);

//----branch----//
    wire beq_D=(Op_D==`beq_Op);
	 wire bne_D=(Op_D==`bne_Op);
    wire branch_D=beq_D|bne_D;

//----load----//
    wire lw_D=(Op_D==`lw_Op);
	 wire lh_D=(Op_D==`lh_Op);
	 wire lb_D=(Op_D==`lb_Op);
    wire load_D=lw_D|lh_D|lb_D;

//----store----//
    wire sw_D=(Op_D==`sw_Op);
	 wire sh_D=(Op_D==`sh_Op);
	 wire sb_D=(Op_D==`sb_Op);
    wire store_D=sw_D|sh_D|sb_D;
    
//----jumpreg_D----//
    wire jr_D=(Op_D==`R_Type)&&(Funct_D==`jr_Funct);
	 
	 wire jumpreg_D=jr_D;

//----jumplink_D----//
    wire jal_D=(Op_D==`jal_Op);

	 wire jumplink_D=jal_D;

//----md----//
	wire mult_D=(Op_D==`R_Type)&&(Funct_D==`mult_Funct);
	wire multu_D=(Op_D==`R_Type)&&(Funct_D==`multu_Funct);
	wire div_D=(Op_D==`R_Type)&&(Funct_D==`div_Funct);
	wire divu_D=(Op_D==`R_Type)&&(Funct_D==`divu_Funct);
	
	wire md_D=mult_D|multu_D|div_D|divu_D;
	
//----mf----//
	wire mfhi_D=(Op_D==`R_Type)&&(Funct_D==`mfhi_Funct);
	wire mflo_D=(Op_D==`R_Type)&&(Funct_D==`mflo_Funct);
	wire mf_D=mfhi_D|mflo_D;
	
//----mt----//
	wire mthi_D=(Op_D==`R_Type)&&(Funct_D==`mthi_Funct);
	wire mtlo_D=(Op_D==`R_Type)&&(Funct_D==`mtlo_Funct);
	wire mt_D=mthi_D|mtlo_D;

    assign Tnew=   (jumplink_D|lui_D)?3'd0:
						 (cal_r_D|cal_i_D|mf_D)?3'd1:
                   (load_D)?3'd2:3'd0;
	
    assign A3=  (cal_r_D|mf_D)? Instr_D[15:11]:             //选择Rd
                (cal_i_D|load_D|lui_D)? Instr_D[20:16]:     //选择Rt
                (jumplink_D)?5'd31:5'd0; 						   //选择$31
					
    //----AT_Decode----//
    wire [2:0] Rs_Tuse=  (jumpreg_D|branch_D)?3'd0:
							    (cal_r_D|cal_i_D|load_D|store_D|md_D|mt_D)?3'd1:3'd5;

    wire [2:0] Rt_Tuse=	(branch_D)?3'd0:
							(cal_r_D|md_D)?3'd1:
							(store_D)?3'd2:3'd5;

//----应当满足的条件：Tuse<Tnew，寄存器相同且不为0号寄存器----//

    wire StallRs_E=(Rs_Tuse<Tnew_E) && (A1_D == A3_E)&&(A1_D!=5'b0);    
    wire StallRt_E=(Rt_Tuse<Tnew_E) && (A2_D == A3_E)&&(A2_D!=5'b0);

    wire StallRs_M=(Rs_Tuse<Tnew_M) && (A1_D == A3_M)&&(A1_D!=5'b0);
    wire StallRt_M=(Rt_Tuse<Tnew_M) && (A2_D == A3_M)&&(A2_D!=5'b0);
	 
	 wire Stall_HILO=(md_D||mf_D||mt_D) && (HILO_busy||start_E);
	 
    assign stall=StallRs_E||StallRt_E||StallRs_M||StallRt_M||Stall_HILO;

    assign D_REG_en =~stall;
    assign E_REG_clr =stall;
    assign PC_en=~stall;

endmodule