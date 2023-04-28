`timescale 1ns / 1ps

module D_GRF(
    input clk,
    input reset,
    input RegWrite,     //控制信号
	 input [31:0] PC_W,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] GRF_WD,
    output [31:0] RF_RD1,
    output [31:0] RF_RD2
    );

    reg [31:0] registers [31:0];
	 
    integer  i;
    initial begin
        for(i=0 ; i<=31 ; i=i+1)begin
          registers[i] <= 32'b0;
        end
    end

    //GRF内部转发---解决结构冒险
    assign RF_RD1= (A1==5'b0)? 32'b0:
						(A1==A3&&RegWrite)?GRF_WD:
						registers[A1];

    assign RF_RD2= (A2==5'b0)? 32'b0:
						 (A2==A3&&RegWrite)?GRF_WD:
						registers[A2];
               
  always @(posedge clk) begin

    if(reset)begin
        for(i=0 ; i<=31 ; i=i+1)begin
          registers[i] <= 32'b0;
        end
    end

    else begin
        if(RegWrite==1&&A3!=5'd0)begin
           registers[A3]<=GRF_WD;
			  $display("%d@%h: $%d <= %h", $time,PC_W, A3, GRF_WD);
        end
    end

  end

endmodule