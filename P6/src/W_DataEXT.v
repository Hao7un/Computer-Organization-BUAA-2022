`timescale 1ns / 1ps

module W_DataEXT(
	input [3:0] DM_Op_W,
	input [31:0] Din,
	input [1:0] A,
	output [31:0] Dout
    );
	reg [31:0] result;
	assign Dout=result;

	always@(*)begin
		case(DM_Op_W)
			4'd4:begin	//lb
				case (A)
					2'b00:result={{24{Din[7]}},Din[7:0]};
					
					2'b01:result={{24{Din[15]}},Din[15:8]};
					
					2'b10:result={{24{Din[23]}},Din[23:16]};
					
					2'b11:result={{24{Din[31]}},Din[31:24]};
				endcase
			end
			
			4'd5:begin  //lh
				if(A[1]==1'd1) begin
					result={{16{Din[31]}},Din[31:16]};
				end
				else begin
					result={{16{Din[15]}},Din[15:0]};
				end
			end
			
			4'd6:begin   //lw
				result=Din;
			end
			
			default:result=Din;
		endcase
	end


endmodule
