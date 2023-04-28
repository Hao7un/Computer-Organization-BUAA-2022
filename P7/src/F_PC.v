`timescale 1ns / 1ps
module F_PC(
    input clk,
    input reset,
    input en,      //PC的使能端，用于阻塞
	 input Req,	// exception 
	 
    input [31:0] NPC, 
	 output reg [31:0] PC
    );

    initial begin
      PC=32'h0000_3000;
    end
   
  always @(posedge clk) begin
		if(reset)begin
			PC <= 32'h3000;        
		end
		else if (en | Req) begin
			PC <= NPC;
		end
  end
endmodule