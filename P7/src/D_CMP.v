`timescale 1ns / 1ps
`include "def.v"
module D_CMP(
    input [31:0] MF_Rs_D,    
    input [31:0] MF_Rt_D,
    input [2:0] BranchOp,  //控制器生成的跳转指令
    output BranchSignal
);
	 reg result;
	 assign BranchSignal=result;
	 
    assign equal = (MF_Rs_D==MF_Rt_D)?1'b1:1'b0;
	 
	 always@(*)begin
		 case(BranchOp)
			`CMP_beq:begin
				if(equal)
					result=1;
				else
					result=0;
			end
			
			`CMP_bne:begin
				if(~equal)
					result=1;
				else
					result=0;
			end
			default:result=0;
		 endcase
	 end
endmodule