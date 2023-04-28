`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
`define Zero_Extend 2'b00
`define Sign_Extend 2'b01

module EXT(
    input [15:0] Imm,
    input [1:0] EXTOp,
    output [31:0] EXTImm
    );
  reg [31:0] result;
  assign EXTImm=result;

  always @(*) begin
    case (EXTOp)
        `Zero_Extend:result={16'd0,Imm};
        `Sign_Extend:result={{16{Imm[15]}},Imm};
		  
    endcase
  end

endmodule
