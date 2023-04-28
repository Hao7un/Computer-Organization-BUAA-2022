`timescale 1ns / 1ps
`include "def.v"
module D_NPC(
    input Req,
    input eret_D,
	 input [31:0] EPCOut,
	 
    input [31:0] PC_F,      //F级寄存器的PC值
    input [31:0] PC_D,      //D级寄存器的PC值
	 input [2:0] NPCOp,     //选择不同的跳转方式
	 
    input BranchSignal,
	 
    input [31:0] offset,
    input [25:0] Instr_index,
    input [31:0] RegData,
    output [31:0] NPC
);

	reg [31:0] result;
	assign NPC=result;
	
	always@(*)begin
			if(Req) begin
					result = 32'h0000_4180;
			end
			else if(eret_D)begin
					result = EPCOut+4; 	
			end
			else begin
					case(NPCOp)
							`NPC_PlusFour:   result = PC_F+4;
			
							`NPC_Jump:   result={PC_D[31:28],Instr_index,2'b0};
			
							`NPC_JumpReg:   result=RegData;
			
							`NPC_Branch:begin
										if(BranchSignal)  result=PC_D+4+(offset<<2);
										else                             result=PC_F+4;
							end		
							default:result = PC_F+4;
					endcase
			end
	end
endmodule
