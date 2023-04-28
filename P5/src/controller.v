`timescale 1ns / 1ps

module controller(
	input clk,
	input reset,
	input [31:0] Instr_D,
	//----StallUnit----//
   input [2:0] Tnew_E,
   input [2:0] Tnew_M,
	input [4:0] A1_D,
	input [4:0] A2_D,
	input [4:0] A3_E,
	input [4:0] A3_M,
	output IFU_en,
	output D_REG_en,
	output E_REG_clr,
	output [4:0] A3,
	output [2:0] Tnew,
	
	//-----CU----//
	output MemWrite,
	output RegWrite,
	output [2:0] BranchOp,
	output [3:0] ALUOp,
	output [2:0] NPCOp,
	output [1:0] EXTOp,
	output ALU_Src_Sel,
	output [1:0] Elevel_Sel,
	output [1:0] Mlevel_Sel,
	output [1:0] Wlevel_Sel
    );
	wire [5:0] Op=Instr_D[31:26];
	wire [5:0] Funct=Instr_D[5:0];
	wire [2:0] Rs_Tuse,Rt_Tuse;
	

	 
StallUnit stallunit (
    .Instr_D(Instr_D), 
    .Tnew_E(Tnew_E), 
    .Tnew_M(Tnew_M), 
    .A1_D(A1_D), 
    .A2_D(A2_D), 
    .A3_E(A3_E), 
    .A3_M(A3_M), 
    .Tnew(Tnew), 
    .A3(A3), 
    .D_REG_en(D_REG_en), 
    .E_REG_clr(E_REG_clr), 
    .IFU_en(IFU_en)
    );

Main_CU cu (
    .Op(Op), 
    .Funct(Funct), 
    .MemWrite(MemWrite), 
    .RegWrite(RegWrite), 
	 .BranchOp(BranchOp),
    .ALUOp(ALUOp), 
    .EXTOp(EXTOp), 
    .NPCOp(NPCOp), 
    .ALUSrc_Sel(ALU_Src_Sel), 
    .Elevel_Sel(Elevel_Sel), 
    .Mlevel_Sel(Mlevel_Sel), 
    .Wlevel_Sel(Wlevel_Sel)
    );
endmodule
