`timescale 1ns / 1ps
module W_REG(
    input clk,
    input reset,

    input RegWrite_M,
	 input [3:0] DM_Op_M,
    input [1:0] Wlevel_Sel_M,
	 
    input [31:0] PC_M,
	 input [31:0] Instr_M,
    input [31:0] AO_M,
    input [31:0] DM_RD,
	 
	 input [4:0] A1_M,
	 input [4:0] A2_M,
    input [4:0] A3_M,
	 input [31:0] HL_M,
	 
    output reg RegWrite_W,
	 output reg [3:0] DM_Op_W,
	 output reg [31:0] Instr_W,
    output reg [1:0] Wlevel_Sel_W,
	 
    output reg [31:0] PC_W,
    output reg [31:0] AO_W,
    output reg [31:0] DR_W,
	 
	 output reg [4:0] A1_W,
	 output reg [4:0] A2_W,
    output reg [4:0] A3_W,
	 output reg [31:0] HL_W
);
    initial begin
        RegWrite_W<=1'h0;
		  DM_Op_W<=4'h0;
        Wlevel_Sel_W<=2'h0;
		  Instr_W<=32'h0;
        PC_W<=32'h0;
        AO_W<=32'h0;
        DR_W<=32'h0;
		  A1_W<=5'h0;
		  A2_W<=5'h0;
		  A3_W<=5'h0;
		  HL_W<=32'h0;
    end

  always @(posedge clk) begin
    if(reset) begin
        RegWrite_W<=1'h0;
		  DM_Op_W<=4'h0;
        Wlevel_Sel_W<=2'h0;
		  Instr_W<=32'h0;
        PC_W<=32'h0;
        AO_W<=32'h0;
        DR_W<=32'h0;
		  A1_W<=5'h0;
		  A2_W<=5'h0;
		  A3_W<=5'h0;
		  HL_W<=32'h0;
    end   
	 
    else begin
        RegWrite_W<=RegWrite_M;
		  DM_Op_W<=DM_Op_M;
        Wlevel_Sel_W<=Wlevel_Sel_M;
		  Instr_W<=Instr_M;
        PC_W<=PC_M;
        AO_W<=AO_M;
        DR_W<=DM_RD;
		  A1_W<=A1_M;
		  A2_W<=A2_M;
        A3_W<=A3_M;
		  HL_W<=HL_M;
    end
  end
endmodule
