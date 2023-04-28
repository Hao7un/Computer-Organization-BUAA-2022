`timescale 1ns / 1ps

`define ALU_add  4'b0000        //宏命名规则  模块_指令
`define ALU_sub  4'b0001
`define ALU_or   4'b0010
`define ALU_and   4'b0011
`define ALU_slt  4'b0100
`define ALU_sltu  4'b0101

module E_ALU(
    input [31:0] Src_A,
    input [31:0] Src_B,
    input [3:0] ALUOp,
    output [31:0] ALUOut
);
    reg [31:0] result;
    assign ALUOut=result;

  always @(*) begin
    case(ALUOp)
        `ALU_add:    result= Src_A + Src_B;
        `ALU_sub:    result= Src_A - Src_B;
        `ALU_or:     result= Src_A | Src_B;  
		  `ALU_and:		result= Src_A & Src_B;
		  `ALU_slt:    result=($signed(Src_A)<$signed(Src_B)) ? 32'b1 : 32'b0;
		  `ALU_sltu:   result=(Src_A<Src_B)? 32'b1:32'b0;

        default:     result=32'hffff_ffff;
    endcase
  end

endmodule
