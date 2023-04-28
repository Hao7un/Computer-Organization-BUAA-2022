`timescale 1ns / 1ps

module controller(
	input clk,
	input reset,
	input [31:0] Instr_D,
	input [31:0] Instr_E,
	input [31:0] Instr_M,
	
	//----StallUnit----//
   input [2:0] Tnew_E,
   input [2:0] Tnew_M,
	input [4:0] A1_D,
	input [4:0] A2_D,
	input [4:0] A3_E,
	input [4:0] A3_M,
	input HILO_busy,
	input start_E,
	
	output PC_en,
	output D_REG_en,
	output E_REG_clr,
	output [4:0] A3,
	output [2:0] Tnew,
	
	//-----CU----//
	output RegWrite,
	output start,
	output [2:0] BranchOp,
	output [3:0] ALUOp,
	output [2:0] NPCOp,
	output [1:0] EXTOp,
	output [3:0] HILO_Op,
	output [3:0] DM_Op,
	
	output ALU_Src_Sel,
	output [1:0] Elevel_Sel,
	output [1:0] Mlevel_Sel,
	output [2:0] Wlevel_Sel
    );
	

StallUnit stallunit (
    .Instr_D(Instr_D),
	 .Instr_E(Instr_E), 
	 .Instr_M(Instr_M), 	 
	 
    .Tnew_E(Tnew_E), 
    .Tnew_M(Tnew_M), 
    .A1_D(A1_D), 
    .A2_D(A2_D), 
    .A3_E(A3_E), 
    .A3_M(A3_M), 
    .HILO_busy(HILO_busy), 
	 .start_E(start_E),
	 
    .Tnew(Tnew), 
    .A3(A3), 
    .D_REG_en(D_REG_en), 
    .E_REG_clr(E_REG_clr), 
    .PC_en(PC_en)
    );

Main_CU cu (
	 .Instr_D(Instr_D),
	
    .RegWrite(RegWrite), 
	 .start(start),
	 
	 .BranchOp(BranchOp),
    .ALUOp(ALUOp), 
    .EXTOp(EXTOp), 
    .NPCOp(NPCOp), 
	 .HILO_Op(HILO_Op),
	 .DM_Op(DM_Op),
	 
    .ALUSrc_Sel(ALU_Src_Sel), 
    .Elevel_Sel(Elevel_Sel), 
    .Mlevel_Sel(Mlevel_Sel), 
    .Wlevel_Sel(Wlevel_Sel)
    );

endmodule
