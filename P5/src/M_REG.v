`timescale 1ns / 1ps
module M_REG(
    input clk,
    input reset,

    input MemWrite_E,
    input RegWrite_E,
    input [1:0] Mlevel_Sel_E,
    input [1:0] Wlevel_Sel_E,
	 
    input [31:0] Instr_E,
    input [31:0] PC_E,
    input [31:0] ALUOut,
    input [31:0] V2_E,
	 
	 input [4:0] A1_E,
	 input [4:0] A2_E,
    input [4:0] A3_E,
    input [2:0] Tnew_E,

    output reg MemWrite_M,
    output reg RegWrite_M,
    output reg [1:0] Mlevel_Sel_M,
    output reg [1:0] Wlevel_Sel_M,
	 
    output reg [31:0] Instr_M,
    output reg [31:0] PC_M,
    output reg [31:0] AO_M,     //写回寄存器的WriteData
    output reg [31:0] V2_M,     //输入到DM中的WriteData
	 
	 output reg [4:0] A1_M,	
	 output reg [4:0] A2_M,
    output reg [4:0] A3_M,
    output reg [2:0] Tnew_M
);

    initial begin
        MemWrite_M<=0;
        RegWrite_M<=0;
        Mlevel_Sel_M<=0;
        Wlevel_Sel_M<=0;
        Instr_M<=32'h0;
        PC_M<=32'h0;
        AO_M<=32'h0;
        V2_M<=32'h0;
		  A1_M<=5'h0;
		  A2_M<=5'h0;
        A3_M<=5'h0;
        Tnew_M<=5'h0;
    end

  always @(posedge clk) begin
    if(reset) begin
        MemWrite_M<=0;
        RegWrite_M<=0;
        Mlevel_Sel_M<=0;
        Wlevel_Sel_M<=0;
        Instr_M<=32'h0;
        PC_M<=32'h0;
        AO_M<=32'h0;
        V2_M<=32'h0;
		  A1_M<=5'h0;
		  A2_M<=5'h0;
        A3_M<=5'h0;
        Tnew_M<=5'h0;
    end   
    else begin
        MemWrite_M<=MemWrite_E;
        RegWrite_M<=RegWrite_E;
        Mlevel_Sel_M<=Mlevel_Sel_E;
        Wlevel_Sel_M<=Wlevel_Sel_E;
        Instr_M<=Instr_E;
        PC_M<=PC_E;
        AO_M<=ALUOut;
        V2_M<=V2_E;
		  A1_M<=A1_E;
		  A2_M<=A2_E;
        A3_M<=A3_E;
        if (Tnew_E>=3'd1)begin
            Tnew_M<=Tnew_E-3'd1;
			end
        else begin 
            Tnew_M<=3'd0;
			end
    end
  end

endmodule