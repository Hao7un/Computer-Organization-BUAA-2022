`timescale 1ns / 1ps
`define CMP_beq 3'b001 //宏命名规则  模块_指令

module D_CMP(
    input [31:0] MF_Rs_D,    
    input [31:0] MF_Rt_D,
    input [2:0] BranchOp,  //控制器生成的跳转指令
    output BranchSignal
);

    assign equal = (MF_Rs_D==MF_Rt_D)?1'b1:1'b0;
    assign BranchSignal=((BranchOp==`CMP_beq)&&equal);

endmodule