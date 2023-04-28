`timescale 1ns / 1ps
`timescale 1ns / 1ps

//----宏定义----//

`define R_Type 6'b000000

//Statement：R类型指令定义的是Funct，非R类型定义的是Op

//----cal_r----//          
`define add_Funct 6'b100000
`define sub_Funct 6'b100010

//----cal_i----//     
`define ori_Op 6'b001101

//----lui----//
`define lui_Op 6'b001111

//----branch----//
`define beq_Op 6'b000100

//----load-----//           
`define lw_Op  6'b100011

//----store----//
`define sw_Op  6'b101011

//----jumplink----//
`define jal_Op 6'b000011   

//----jumpreg----//
`define jr_Funct  6'b001000

module StallUnit(
	 input [31:0] Instr_D,
    input [2:0] Tnew_E,
    input [2:0] Tnew_M,
    input [4:0] A1_D,
    input [4:0] A2_D,
    input [4:0] A3_E,
    input [4:0] A3_M,
	
    output [2:0] Tnew,
    //----A处理----//
    output [4:0] A3,
    output D_REG_en,
    output E_REG_clr,
    output IFU_en
);

//----寄存器当前的指令----//
    wire [6:0] Op_D = Instr_D[31:26];
    wire [6:0] Funct_D = Instr_D[5:0]; 

//----cal_r----//
    wire add_D=(Op_D==`R_Type)&&(Funct_D==`add_Funct);
    wire sub_D=(Op_D==`R_Type)&&(Funct_D==`sub_Funct);
    wire cal_r_D=add_D|sub_D;

//----cal_i----//
    wire ori_D=(Op_D==`ori_Op);
    wire cal_i_D=ori_D;
	 
//----lui----//
	wire lui_D=(Op_D==`lui_Op);

//----branch----//
    wire beq_D=(Op_D==`beq_Op);
    wire branch_D=beq_D;

//----load----//
    wire lw_D=(Op_D==`lw_Op);
    wire load_D=lw_D;

//----store----//
    wire sw_D=(Op_D==`sw_Op);
    wire store_D=sw_D;
    
//----jumpreg_D----//
    wire jr_D=(Op_D==`R_Type)&&(Funct_D==`jr_Funct);
	 
	 wire jumpreg_D=jr_D;

//----jumplink_D----//
    wire jal_D=(Op_D==`jal_Op);

	 wire jumplink_D=jal_D;
//----应当满足的条件：Tuse<Tnew，寄存器相同且不为0号寄存器----//

    assign Tnew=   (jumplink_D|lui_D)?3'd0:
						 (cal_r_D|cal_i_D)?3'd1:
                   (load_D)?3'd2:3'd0;
	
    assign A3=  (cal_r_D)? Instr_D[15:11]:             //选择Rd
                (cal_i_D|load_D|lui_D)? Instr_D[20:16]:     //选择Rt
                (jumplink_D)?5'd31:5'd0; 						   //选择$31

    //----AT_Decode----//
    wire [2:0] Rs_Tuse=  (jumpreg_D|branch_D)?3'd0:
							    (cal_r_D|cal_i_D|load_D|store_D)?3'd1:3'd5;

    wire [2:0] Rt_Tuse=	(branch_D)?3'd0:
							(cal_r_D)?3'd1:
							(store_D)?3'd2:3'd5;

    wire StallRs_E=(Rs_Tuse<Tnew_E) && (A1_D == A3_E)&&(A1_D!=5'b0);    
    wire StallRt_E=(Rt_Tuse<Tnew_E) && (A2_D == A3_E)&&(A2_D!=5'b0);

    wire StallRs_M=(Rs_Tuse<Tnew_M) && (A1_D == A3_M)&&(A1_D!=5'b0);
    wire StallRt_M=(Rt_Tuse<Tnew_M) && (A2_D == A3_M)&&(A2_D!=5'b0);

    assign stall=StallRs_E||StallRt_E||StallRs_M||StallRt_M;

    assign D_REG_en =~stall;
    assign E_REG_clr =stall;
    assign IFU_en=~stall;

endmodule