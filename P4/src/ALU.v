`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
`define ADD  4'b0000
`define SUB  4'b0001
`define OR   4'b0010
`define LUI  4'b0011
`define SLL  4'b0100

module ALU(
    input [31:0] Src_A,
    input [31:0] Src_B,
    input [4:0] Shamt,
    input [3:0] ALUOp,
    output Zero,
    output [31:0] ALU_Result
);
    reg [31:0] result;
    assign ALU_Result=result;
    assign Zero=(ALU_Result==32'd0)?1'b1:1'b0;

  always @(*) begin
    case(ALUOp)
        `ADD:    result= Src_A + Src_B;
        `SUB:    result= Src_A - Src_B;
        `OR:     result= Src_A | Src_B;  
        `LUI:    result= { {Src_B[15:0]},16'd0};
        `SLL:    result= Src_B << Shamt;
        default:begin
          result=0;
        end
    endcase
  end
endmodule
