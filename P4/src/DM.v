`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module DM(
	 input [31:0] PC,
    input [31:0] address,
    input [31:0] DM_WD,
    input MemWrite,
    input clk,
    input reset,
    output [31:0] ReadData
    );
    
    reg [31 : 0] DataMemory [3071 : 0];
    reg [31:0] result;
    integer i;

   assign ReadData =DataMemory[address[13:2]];

	initial begin
        for(i = 0; i <=3071; i = i+1)begin
          DataMemory[i]<=32'h0;  //初始化为0
        end		
	end

  always @(posedge clk) begin
    if(reset)begin
        for(i = 0; i <=3071; i=i+1)begin
          DataMemory[i]<=32'd0;  //初始化为0
        end
    end

    else begin
        if(MemWrite==1)begin
            DataMemory[address[13:2]]<= DM_WD;
				$display("@%h: *%h <= %h", PC,address, DM_WD);
        end
    end
  end

endmodule
