`timescale 1ns / 1ps
`include "def.v"

module E_ALU(
    input [31:0] Src_A,
    input [31:0] Src_B,
	 input [4:0] shamt,
    input [3:0] ALUOp,
    output [31:0] ALUOut,
	 output overflow
);
    reg [31:0] result;
    assign ALUOut=result;
	 
	 reg  [32:0] temp;
	 assign overflow= (temp[32]!=temp[31]);
	 
  always @(*) begin
    case(ALUOp)
        `ALU_add:begin
				result= Src_A + Src_B;
				temp = {Src_A[31],Src_A[31:0]} + {Src_B[31],Src_B[31:0]};
			end
			
        `ALU_sub:begin
				result= Src_A - Src_B;
				temp = {Src_A[31],Src_A[31:0]} - {Src_B[31],Src_B[31:0]};
			end
			
        `ALU_or:          result= Src_A | Src_B;  
		  `ALU_and:		result= Src_A & Src_B;
		  `ALU_slt:         result=($signed(Src_A)<$signed(Src_B)) ? 32'b1 : 32'b0;
		  `ALU_sltu:      result=(Src_A<Src_B)? 32'b1:32'b0;
		  `ALU_srl:         result= Src_B>>shamt;

        default:     result=32'hffff_ffff;
		  
    endcase
  end

endmodule
