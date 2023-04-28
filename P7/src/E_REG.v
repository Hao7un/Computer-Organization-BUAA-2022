`timescale 1ns / 1ps
module E_REG(
    input clk,
    input reset,
	 input Req,
    input flush,
	 
    //come from MainCU
    input [3:0] ALUOp,
	 input [3:0] HILO_Op,
	 input [3:0] DM_Op,
	 input start,
    input ALUSrc_Sel,
    input RegWrite,
	 input [1:0] Elevel_Sel,  
    input [1:0] Mlevel_Sel, 
    input [2:0] Wlevel_Sel,  
	 
	 //come from D_stage
    input [31:0] Instr_D,
    input [31:0] PC_D,
    input [31:0] EXTOut,
	 input [4:0] A1_D,
	 input [4:0] A2_D,
	 //come from AT-Decoder
    input [4:0] A3,
    input [2:0] Tnew,	
	 
	 //come from forward-Mux
	 input [31:0] MF_Rs_D,
    input [31:0] MF_Rt_D,
	 
	 input [4:0] ExcCode_D,
	 input bd_D,

    //control signal
    output reg [3:0] ALUOp_E,
	 output reg [3:0] HILO_Op_E,
	 output reg [3:0] DM_Op_E,
	 output reg start_E,
    output reg ALUSrc_Sel_E,
    output reg RegWrite_E,
	 output reg [1:0] Elevel_Sel_E,	 //E级选择数据转发	
    output reg [1:0] Mlevel_Sel_E,   //M级选择数据转发
    output reg [2:0] Wlevel_Sel_E,   //W级选择数据转发
	 
    output reg [31:0] Instr_E,
    output reg [31:0] PC_E,
    output reg [31:0] V1_E,
    output reg [31:0] V2_E,
    output reg [31:0] E32_E,
	 
	 output reg [4:0] A1_E,
	 output reg [4:0] A2_E,
    output reg [4:0] A3_E,
    output reg [2:0] Tnew_E,
	 
	 output reg [4:0] ExcCode_old_E,
	 output reg bd_E
);
    initial begin
        ALUOp_E<=0;
		  HILO_Op_E<=0;
		  DM_Op_E<=0;
		  start_E<=0;
        ALUSrc_Sel_E<=0;
        RegWrite_E<=0;
		  Elevel_Sel_E<=0;
        Mlevel_Sel_E<=0;
        Wlevel_Sel_E<=0;
        Instr_E<=32'h0;
        PC_E<=0;
        V1_E<=0;
        V2_E<=0;
        E32_E<=0;
		  A1_E<=0;
		  A2_E<=0;
        A3_E<=0;
        Tnew_E<=0;
		  
		  ExcCode_old_E<=0;
		  bd_E<=0;
    end

  always @(posedge clk) begin
    if(reset||flush||Req) begin
        ALUOp_E<=0;
		  HILO_Op_E<=0;
		  DM_Op_E<=0;
		  start_E<=0;

        ALUSrc_Sel_E<=0;
        RegWrite_E<=0;
		  Elevel_Sel_E<=0;
        Mlevel_Sel_E<=0;
        Wlevel_Sel_E<=0;
        Instr_E<=32'h0;
		  PC_E<= flush ? PC_D : (Req ? 32'h0000_4180 : 32'h0);
        V1_E<=0;
        V2_E<=0;
        E32_E<=0;
		  A1_E<=0;
		  A2_E<=0;
        A3_E<=0;
        Tnew_E<=0;
		  
		  ExcCode_old_E<=flush? ExcCode_D: 5'd0;
		  bd_E<=flush? bd_D:0;
    end
	
    else begin
        ALUOp_E<=ALUOp;
		  HILO_Op_E<=HILO_Op;
		  DM_Op_E<=DM_Op;
		  start_E<=start;
        ALUSrc_Sel_E<=ALUSrc_Sel;
        RegWrite_E<=RegWrite;
		  Elevel_Sel_E<=Elevel_Sel;
        Mlevel_Sel_E<=Mlevel_Sel;
        Wlevel_Sel_E<=Wlevel_Sel;
        Instr_E<=Instr_D;
        PC_E<=PC_D;
        V1_E<=MF_Rs_D;
        V2_E<=MF_Rt_D;
        E32_E<=EXTOut;
		  A1_E<=A1_D;
		  A2_E<=A2_D;
        A3_E<=A3;
        Tnew_E<=Tnew;
		  ExcCode_old_E<=ExcCode_D;
		  bd_E<=bd_D;
    end
  end

endmodule