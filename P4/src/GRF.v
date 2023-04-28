`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module GRF(
    input clk,
    input reset,
	 input [31:0] PC,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] GRF_WD,
    input RegWrite,
    output [31:0] RD1,
    output [31:0] RD2
    );

    reg [31:0] registers [31:0];
	 
    integer  i;
    initial begin
        for(i=0 ; i<=31 ; i=i+1)begin
          registers[i] = 32'h0000_0000;
        end
    end

    assign RD1= (A1==5'b0)? 32'b0:registers[A1];
    assign RD2= (A2==5'b0)? 32'b0:registers[A2];

  always @(posedge clk) begin
    if(reset)begin
        for(i=0 ; i<=31 ; i=i+1)begin
          registers[i] <= 32'h0000_0000;
        end
    end
    else begin
        if(RegWrite==1&&A3!=5'd0)begin
          registers[A3]<=GRF_WD;
			  $display("@%h: $%d <= %h", PC, A3, GRF_WD);
        end
    end
  end

endmodule