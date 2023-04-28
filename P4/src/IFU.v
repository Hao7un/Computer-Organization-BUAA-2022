`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module IFU(
    input clk,
    input reset,
    input [31:0] next_PC,
    output [31:0] Instr,
    output [31:0] PC
    );

    reg [31 : 0] InstrMemory [4095 : 0];
    reg [31 : 0] PC_Reg;

    assign Instr= InstrMemory[(PC-32'h0000_3000)>>2];
    assign PC=PC_Reg;

	 integer i;
    initial begin
      PC_Reg=32'h3000;
		for(i=0;i<4096;i=i+1)		//initialize the Memory
			InstrMemory[i] = 32'h0000_0000;
			$readmemh("code.txt",InstrMemory);
    end
   
  always @(posedge clk) begin
    if(reset)begin
        PC_Reg<=32'h3000;        
    end
    else begin
        PC_Reg<=next_PC;
    end
  end

endmodule
