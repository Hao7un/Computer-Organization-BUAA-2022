`timescale 1ns / 1ps

//R类型指令 funct
`define add 6'b100000
`define sub 6'b100010
`define jr  6'b001000
`define sll 6'b000000

`define R_type 6'b000000

//I类型与J类型 Op
`define lw  6'b100011
`define sw  6'b101011
`define ori 6'b001101
`define lui 6'b001111
`define beq 6'b000100
`define j   6'b000010
`define jal 6'b000011

module Control(
    input [5:0] Op,
    input [5:0] Funct,
	
    output MemWrite,
    output RegWrite,
	 output [3:0] ALUOp,
    output [1:0] EXTOp,
    output [2:0] NPCOp,
	 output ALUSrc_Sel,			//MUX
    output [1:0] RegDst_Sel,	//MUX
    output [1:0] GRFWD_Sel		//MUX
);

    assign MemWrite=(Op==`sw)?1'b1:1'b0;

	 assign RegWrite=(Op==`lw||Op==`ori||Op==`lui||(Op==`R_type&&Funct==`add)||(Op==`R_type&&Funct==`sub)||(Op==`R_type&&Funct==`sll)||Op==`jal)?1'b1:1'b0;
	 
    assign ALUOp=(Op==`R_type&&Funct==`add)? 4'b0000:
                 (Op==`R_type&&Funct==`sub)? 4'b0001:
                 (Op==`R_type&&Funct==`sll)? 4'b0100:
                 (Op==`lw)?  4'b0000:
                 (Op==`sw)?  4'b0000:
                 (Op==`ori)? 4'b0010:
                 (Op==`lui)? 4'b0011:
                 (Op==`beq)? 4'b0001:4'b0000;
					  
	 assign EXTOp=(Op==`lw||Op==`sw||Op==`beq)?1'b1:1'b0;
	 
	 assign NPCOp= (Op==`beq)?3'b001:
						(Op==`j||Op==`jal)?3'b010:
                  (Op==`R_type&&Funct==`jr)?3'b011:3'b000;
	 
	 
    assign ALUSrc_Sel= (Op==`lw||Op==`sw||Op==`ori||Op==`lui)? 1'b1:1'b0;

    assign RegDst_Sel=  ((Op==`R_type&&Funct==`add)||(Op==`R_type&&Funct==`sub)||(Op==`R_type&&Funct==`sll))?2'b01:
                        (Op==`jal)?2'b10:2'b00;

    assign GRFWD_Sel=  (Op==`lw)?2'b01:
                       (Op==`jal) ?2'b10:2'b00;

endmodule
