`timescale 1ns / 1ps
`define NPC_PlusFour 3'b000
`define NPC_Branch  3'b001
`define NPC_Jump    3'b010
`define NPC_JumpReg 3'b011

module D_NPC(
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
		case(NPCOp)
			`NPC_PlusFour:result = PC_F+4;
			
			`NPC_Jump:result={PC_D[31:28],Instr_index,2'b0};
			
			`NPC_JumpReg:result=RegData;
			
			`NPC_Branch:begin
				if(BranchSignal)
					result=PC_D+4+(offset<<2);
				else 
					result=PC_F+4;
			end
			
		endcase
	end

endmodule
