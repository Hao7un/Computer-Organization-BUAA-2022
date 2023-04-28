`timescale 1ns / 1ps

module mips(
	input clk,
	input reset
    );
	
	 wire IFU_en,D_REG_en,E_REG_clr;
	 wire MemWrite,RegWrite;
	 wire [2:0] BranchOp;
	 wire [3:0] ALUOp;
	 wire [1:0] EXTOp;
	 wire [2:0] NPCOp;
	 wire ALU_Src_Sel;
	 wire [1:0] Elevel_Sel,Mlevel_Sel,Wlevel_Sel;
	 wire [4:0] A3,A1_D,A2_D,A3_E,A3_M;
	 wire [31:0] Instr_D;
	 wire [2:0] Tnew_E,Tnew_M,Tnew;
	 
datapath dp (
    .clk(clk), 
    .reset(reset), 
	 //StallUnit//
    .IFU_en(IFU_en), 
    .D_REG_en(D_REG_en), 
    .E_REG_clr(E_REG_clr),
	 
	 //Control//
    .MemWrite(MemWrite), 
    .RegWrite(RegWrite), 
	 .BranchOp(BranchOp),
    .ALUOp(ALUOp), 
    .EXTOp(EXTOp), 
    .NPCOp(NPCOp), 
    .ALUSrc_Sel(ALU_Src_Sel), 
    .Elevel_Sel(Elevel_Sel), 
    .Mlevel_Sel(Mlevel_Sel), 
    .Wlevel_Sel(Wlevel_Sel), 
	 
	 //A3---destination Tnew---passing through
    .A3(A3), 
    .Tnew(Tnew), 

	 //used for StallUnit
    .Instr_D_out(Instr_D), 
    .Tnew_E_out(Tnew_E), 
    .Tnew_M_out(Tnew_M), 
    .A1_D_out(A1_D), 
    .A2_D_out(A2_D), 
    .A3_E_out(A3_E), 
    .A3_M_out(A3_M)
    );
	 
controller ctrl (
    .clk(clk), 
    .reset(reset), 
	 
	 //Stallunit and Control
    .Instr_D(Instr_D), 
    .Tnew_E(Tnew_E), 
    .Tnew_M(Tnew_M), 
    .A1_D(A1_D), 
    .A2_D(A2_D), 
    .A3_E(A3_E), 
    .A3_M(A3_M), 
	 
	 //StallUnit
    .IFU_en(IFU_en), 
    .D_REG_en(D_REG_en), 
    .E_REG_clr(E_REG_clr), 
	 
    .A3(A3), 
    .Tnew(Tnew), 
	 
	 //Control
	 .BranchOp(BranchOp),
    .ALUOp(ALUOp), 
	 .NPCOp(NPCOp),
	 .EXTOp(EXTOp),
    .ALU_Src_Sel(ALU_Src_Sel), 
    .MemWrite(MemWrite), 
    .RegWrite(RegWrite), 
    .Elevel_Sel(Elevel_Sel), 
    .Mlevel_Sel(Mlevel_Sel), 
    .Wlevel_Sel(Wlevel_Sel)
    );

endmodule