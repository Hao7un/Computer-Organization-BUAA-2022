`timescale 1ns / 1ps
module mips(
	input clk,
	input reset
    );
	
	wire MemWrite,ALUSrc_Sel,RegWrite;
	wire [3:0] ALUOp;
	wire [2:0] NPCOp;
	wire [1:0] EXTOp,RegDst_Sel,GRFWD_Sel;
	wire [5:0] Op,Funct;


DataPath datapath (
    .clk(clk), 
    .reset(reset), 
    .MemWrite(MemWrite), 
    .ALUOp(ALUOp), 
    .ALUSrc_Sel(ALUSrc_Sel), 
    .RegWrite(RegWrite), 
    .EXTOp(EXTOp), 
    .NPCOp(NPCOp), 
    .RegDst_Sel(RegDst_Sel), 
    .GRFWD_Sel(GRFWD_Sel), 
    .Op(Op), 
    .Funct(Funct)
    );
	 
Control control (
    .Op(Op), 
    .Funct(Funct), 
    .MemWrite(MemWrite), 
    .ALUOp(ALUOp), 
    .ALUSrc_Sel(ALUSrc_Sel), 
    .RegWrite(RegWrite), 
    .EXTOp(EXTOp), 
    .NPCOp(NPCOp), 
    .RegDst_Sel(RegDst_Sel), 
    .GRFWD_Sel(GRFWD_Sel)
    );
	 
endmodule