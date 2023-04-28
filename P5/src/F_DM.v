`timescale 1ns / 1ps

module M_DM(
    input clk,
    input reset,
	 input MemWrite,             //控制信号
	 input [31:0] PC_M,
    input [31:0] DM_Addr,
    input [31:0] DM_WD,
    output [31:0] DM_RD
    );
    integer i;

    reg [31 : 0] DataMemory [3071 : 0];
  
    assign DM_RD =DataMemory[DM_Addr[13:2]];

	initial begin
		for(i=0;i<3072;i=i+1) begin  //1024
			DataMemory[i]<=32'b0;
		end
	end

    always @(posedge clk) begin
        if(reset)begin
            for(i = 0; i <=3071; i=i+1)begin
                DataMemory[i]<=32'b0;  //初始化为0
            end
    end

    else begin
        if(MemWrite==1)begin
            DataMemory[DM_Addr[13:2]]<=DM_WD;
			$display("%d@%h: *%h <= %h",$time,PC_M,DM_Addr, DM_WD);
        end
    end
  end
endmodule