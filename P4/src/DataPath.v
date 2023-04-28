`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module DataPath(
	input clk,
	input reset,
	input MemWrite,
	input RegWrite,
	input [3:0] ALUOp,
	input [1:0]EXTOp,
	input [2:0] NPCOp,
	input ALUSrc_Sel, 	//Mux
	input [1:0] RegDst_Sel,		//Mux
	input [1:0] GRFWD_Sel,  	//Mux
	output [5:0] Op, 
	output [5:0] Funct
    );


	//ALU output 
	wire [31:0] ALU_Result;
	wire Zero;

	//DM output
	wire [31:0] ReadData;

	//EXT output
	wire [31:0] EXTImm;
	
	//GRF output
	wire [31:0] RD1,RD2;
	
	//NPC output
	wire [31:0] next_PC;

	//IFU output
	wire [31:0] Instr;
	wire [31:0] PC;
	//divide the instr apart
	wire [4:0] Rs,Rt,Rd;
	wire [15:0] Imm16;
	wire [25:0] Instr_Index;
	wire [4:0] Shamt;
	
	assign Rs=Instr[25:21];
	assign Rt=Instr[20:16];
	assign Rd=Instr[15:11];
	assign Imm16=Instr[15:0];
	assign Instr_Index=Instr[25:0];
	assign Shamt=Instr[10:6];

	//MUX:
	//RegDst
	wire [4:0] Mux1_output;
	
	assign Mux1_output=(RegDst_Sel==2'b00)?Rt:
								(RegDst_Sel==2'b01)?Rd:
								(RegDst_Sel==2'b10)?5'h1f:Rt;
	//RegWriteData
	wire [31:0] Mux2_output;
	assign Mux2_output=(GRFWD_Sel==2'b00)?ALU_Result:
								(GRFWD_Sel==2'b01)?ReadData:
								(GRFWD_Sel==2'b10)?(PC+32'd4):ALU_Result;	
	//Src_B
	wire [31:0] Mux3_output;
	assign Mux3_output=(ALUSrc_Sel==0)?RD2:EXTImm;

	//Datapath output
	assign Op=Instr[31:26];
	assign Funct=Instr[5:0];

//IFU
IFU ifu (
    .clk(clk), 
    .reset(reset), 
    .next_PC(next_PC), 
    .Instr(Instr), 
    .PC(PC)
    );


//NPC
NPC npc (
    .PC(PC), 
    .Offset(EXTImm), 
    .Instr_Index(Instr_Index), 
    .RegData(RD1), 
    .Zero(Zero), 
    .NPCOp(NPCOp), 
    .next_PC(next_PC)
    );
	 
//GRF
GRF grf (
    .PC(PC), 
    .A1(Rs), 
    .A2(Rt), 
    .A3(Mux1_output), 
    .GRF_WD(Mux2_output), 
    .clk(clk), 
    .reset(reset), 
    .RegWrite(RegWrite), 
    .RD1(RD1), 
    .RD2(RD2)
    );	 
	 
//EXT
EXT ext (
    .Imm(Imm16), 
    .EXTOp(EXTOp), 
    .EXTImm(EXTImm)
    );	
	 
//ALU	 
ALU alu (
    .Src_A(RD1), 
    .Src_B(Mux3_output), 
    .Shamt(Shamt), 
    .ALUOp(ALUOp), 
    .Zero(Zero), 
    .ALU_Result(ALU_Result)
    );

//DM	 
DM dm (
    .PC(PC), 
    .address(ALU_Result), 
    .DM_WD(RD2), 
    .MemWrite(MemWrite), 
    .clk(clk), 
    .reset(reset), 
    .ReadData(ReadData)
    );
	 






endmodule