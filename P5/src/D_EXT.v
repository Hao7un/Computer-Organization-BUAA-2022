`timescale 1ns / 1ps

`define EXT_ZeroExtend 2'b00
`define EXT_SignExtend 2'b01
`define EXT_lui		  2'b10

module D_EXT(
    input [15:0] Imm,
    input [1:0] EXTOp,
    output [31:0] EXTOut
    );

  reg [31:0] EXT_Result;
  assign EXTOut=EXT_Result;

  always @(*) begin
    case (EXTOp)
        `EXT_ZeroExtend: EXT_Result={16'd0,Imm};
        `EXT_SignExtend: EXT_Result={{16{Imm[15]}},Imm};
		  `EXT_lui:EXT_Result={Imm,16'd0};
		  default:EXT_Result=32'hffff_ffff;
    endcase
  end

endmodule