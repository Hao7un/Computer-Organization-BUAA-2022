`timescale 1ns / 1ps
module D_REG(
    input clk,
    input reset,
	 input Req,
    input en,
    input [31:0] Instr_F,
    input [31:0] PC_F,
	 input [4:0] ExcCode_F,
	 input bd_F,
	 
    output reg [31:0] Instr_D,
    output reg [31:0] PC_D,
    output reg [25:0] Instr_index_D,
	 output reg [15:0] Imm_D,
    output reg [4:0] A1_D,
    output reg [4:0] A2_D,
	 output reg [4:0] ExcCode_old_D,
	 output reg bd_D
);
    initial begin
        Instr_D<=32'h0;
        PC_D<=32'h0;
		  Instr_index_D<=25'h0;
        A1_D<=5'h0;
        A2_D<=5'h0;
        Imm_D<=5'h0;
		  ExcCode_old_D<=5'h0;
		  bd_D<=0;
    end
	//reset>Req>stall
    always @(posedge clk) begin
        if (reset|Req) begin
				Instr_D<=32'h0;
				PC_D<=(Req)?32'h0000_4180:32'h0;
				Instr_index_D<=25'h0;
				A1_D<=5'h0;
				A2_D<=5'h0;
				Imm_D<=5'h0;
				ExcCode_old_D<=5'h0;
				bd_D<=0;
        end
		  
        else if (en) begin
            Instr_D<=Instr_F;
            PC_D<=PC_F;
            Instr_index_D<=Instr_F[25:0];
            A1_D<=Instr_F[25:21];
            A2_D<=Instr_F[20:16];
            Imm_D<=Instr_F[15:0];
				ExcCode_old_D<=ExcCode_F;
				bd_D<=bd_F;
        end
    end

endmodule