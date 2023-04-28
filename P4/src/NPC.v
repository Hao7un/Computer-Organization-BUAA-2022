`timescale 1ns / 1ps

`define PlusFour 3'b000
`define Branch  3'b001
`define Jump    3'b010
`define JumpReg 3'b011

module NPC(
    input [31:0] PC,
    input [31:0] Offset,
    input [25:0] Instr_Index,
    input [31:0] RegData,
    input Zero,
    input [2:0] NPCOp,
    output [31:0] next_PC
);
    reg [31:0] result;

    assign next_PC=result;

    initial begin
      result=32'h3000;
    end

  always @(*) begin
    case (NPCOp)
        `PlusFour:result=PC+4;
		  
        `Branch:begin
            if(Zero)begin
				result=PC+4+(Offset<<2);
				end
            else begin
				result=PC+4;
				end
        end

        `Jump:result={PC[31:28],Instr_Index,2'b0};

        `JumpReg:result=RegData;

        default:result=PC+4;
    endcase
  end
endmodule
