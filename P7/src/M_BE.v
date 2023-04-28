`timescale 1ns / 1ps
`include "def.v"

module M_BE(
	input [1:0] A,
	input [3:0] DM_Op,
	output [3:0] MemWrite_byteen 
    );
	
	reg [3:0] result;
	assign MemWrite_byteen=result;
	
	always@(*) begin
		case(DM_Op)
		`DM_sb:begin
			case(A)
				2'b00:result=4'b0001;
				2'b01:result=4'b0010;
				2'b10:result=4'b0100;
				2'b11:result=4'b1000;
			endcase
		end
		
		`DM_sh:begin
			if(A[1]==1'b0)begin
				result=4'b0011;
			end
			else if(A[1]==1'b1)begin
				result=4'b1100;
			end
		end
		
		`DM_sw:begin
			result=4'b1111;
		end
		
		default:result=4'b0000;
		
		endcase
	end


endmodule
