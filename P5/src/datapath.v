`timescale 1ns / 1ps

module datapath(
	input clk,
	input reset,
	
	//---stall_signal----//
	input IFU_en,
	input D_REG_en,
	input E_REG_clr,
	
	//----Control_Signal----//
	input MemWrite,
	input RegWrite,
	input [3:0] ALUOp,
	input [1:0] EXTOp,
	input [2:0] NPCOp,
	input [2:0] BranchOp,
	input ALUSrc_Sel,
	input [1:0] Elevel_Sel,
	input [1:0] Mlevel_Sel,
	input [1:0] Wlevel_Sel,
	
	
	input [4:0] A3,
	input [2:0] Tnew,
	
	//AT_Decoder
	output [31:0] Instr_D_out,
	
	//StallUnit
	output [2:0] Tnew_E_out,
	output [2:0] Tnew_M_out,
	output [4:0] A1_D_out,
	output [4:0] A2_D_out,
	output [4:0] A3_E_out,
	output [4:0] A3_M_out

    );
	 
	 //----F_IFU_Output----//
	 wire [31:0] Instr_F;
	 wire [31:0] PC_F;

	 //----D_REG_Output----//
	 wire [31:0] Instr_D;
	 wire [31:0] PC_D;
	 wire [25:0] Instr_index_D;
	 wire [4:0] A1_D;
	 wire [4:0] A2_D;
	 wire [15:0] Imm_D;
	 
	 //----NPC_Output----//
	 wire [31:0] NPC;
	 
	 //----CMP_Output----//
	 wire BranchSignal;
	 
	 //----GRF_Output----//
	 wire [31:0] RF_RD1;
	 wire [31:0] RF_RD2;
	 
	 //----EXT_Output----//
	 wire [31:0] EXTOut;
	 
	//----E_REG_output----//
    wire [3:0] ALUOp_E;
    wire ALUSrc_Sel_E;
    wire MemWrite_E;
    wire RegWrite_E;
	 wire [1:0] Elevel_Sel_E;   //E级选择数据转发
    wire [1:0] Mlevel_Sel_E;   //M级选择数据转发
    wire [1:0] Wlevel_Sel_E;   //W级选择数据转发
    wire [31:0] Instr_E;
    wire [31:0] PC_E;
    wire [31:0] V1_E;
    wire [31:0] V2_E;
    wire [31:0] E32_E;
	 
	 wire [4:0] A1_E;
	 wire [4:0] A2_E;
    wire [4:0] A3_E;
    wire [2:0] Tnew_E;
	 
	 //----ALU_Output----//
	 wire [31:0] ALUOut;
	 
	 //----M_REG----//
    wire MemWrite_M;
    wire RegWrite_M;
    wire [1:0] Mlevel_Sel_M;
    wire [1:0] Wlevel_Sel_M;
    wire [31:0] Instr_M;
    wire [31:0] PC_M;
    wire [31:0] AO_M;  //写回寄存器的WriteData
    wire [31:0] V2_M;     //输入到DM中的WriteData
	 
	 wire [4:0] A1_M;
	 wire [4:0] A2_M;
    wire [4:0] A3_M;
    wire [2:0] Tnew_M;	 

	//----DM----//
	 wire [31:0] DM_RD;
	
	//----W_REG----//
    wire RegWrite_W;
	 wire [31:0] Instr_W;
    wire [1:0] Wlevel_Sel_W;
    wire [31:0] PC_W;
    wire [31:0] AO_W;
    wire [31:0] DR_W;
	 
	 wire [4:0] A1_W;
	 wire [4:0] A2_W;
    wire [4:0] A3_W; 

	//------------------------------MUX-----------------------//
	
	//-------------Forward-------------//
	//--E_Level--//
	wire [31:0] RF_WD_E= (Elevel_Sel_E==2'b00)? E32_E:
								(Elevel_Sel_E==2'b01)? PC_E+8:32'hffffffff;
	//--M_Level--//
	wire [31:0] RF_WD_M=(Mlevel_Sel_M==2'b00)?AO_M:
								(Mlevel_Sel_M==2'b01)?PC_M+8:32'hffffffff;
	
	//--M_Level--//
	wire [31:0] RF_WD_W= (Wlevel_Sel_W==2'b00)?AO_W:
								(Wlevel_Sel_W==2'b01)?PC_W+8:
								(Wlevel_Sel_W==2'b10)?DR_W:32'hffffffff;
								
	//----------------Receive----------------//
	//--D_Level--//
	wire [31:0] MF_Rs_D=(A1_D==5'd0)?32'd0:
							  (A1_D==A3_E)?RF_WD_E:
							  (A1_D==A3_M)?RF_WD_M:
							  RF_RD1;
	
	wire [31:0] MF_Rt_D=(A2_D==5'd0)?32'd0:
							  (A2_D==A3_E)?RF_WD_E:
							  (A2_D==A3_M)?RF_WD_M:
							  RF_RD2;
	
	//--E_Level--//
	wire [31:0] MF_Rs_E=(A1_E==5'd0)?32'd0:
							  (A1_E==A3_M)?RF_WD_M:
							  (A1_E==A3_W)?RF_WD_W:
							  V1_E;
	
	wire [31:0] MF_Rt_E=(A2_E==5'd0)?32'd0:
							  (A2_E==A3_M)?RF_WD_M:
							  (A2_E==A3_W)?RF_WD_W:
							  V2_E;
	
	//--M_Level--//
	wire [31:0] MF_Rt_M=(A2_M==5'd0)?32'd0:
							  (A2_M==A3_W)?RF_WD_W:V2_M;
	
	//----Others----//
	wire [31:0] Mux1_Output= (ALUSrc_Sel_E==0)?MF_Rt_E:E32_E;
	
	//datapath_output to controller
	assign Instr_D_out=Instr_D;
	assign Tnew_E_out=Tnew_E;
	assign Tnew_M_out=Tnew_M;
	assign A1_D_out=A1_D;
	assign A2_D_out=A2_D;
	assign A3_E_out=A3_E;
	assign A3_M_out=A3_M;
	

//----F---//
	F_IFU ifu (
    .clk(clk), 
    .reset(reset), 
    .en(IFU_en), 
    .NPC(NPC), 
	 
    .Instr(Instr_F), 
    .PC(PC_F)
    );

//-----DREG----//
D_REG dreg (
	 //input
    .clk(clk), 
    .reset(reset), 
    .en(D_REG_en), 
    .Instr_F(Instr_F), 
    .PC_F(PC_F), 
	 
	 //output
    .Instr_D(Instr_D), 
    .PC_D(PC_D), 
    .Instr_index_D(Instr_index_D), 
    .A1_D(A1_D), 
    .A2_D(A2_D), 
    .Imm_D(Imm_D)
    );

//----D----//

D_NPC npc (
    .PC_F(PC_F), 
    .PC_D(PC_D), 
    .BranchSignal(BranchSignal), 
    .offset(EXTOut), 
    .Instr_index(Instr_index_D), 
    .RegData(MF_Rs_D), 
    .NPCOp(NPCOp), 
	 
	 //output
    .NPC(NPC)
    );

D_CMP cmp (
    .MF_Rs_D(MF_Rs_D), 
    .MF_Rt_D(MF_Rt_D), 
	 .BranchOp(BranchOp),
	 
	 //output
    .BranchSignal(BranchSignal)
    );

D_EXT ext (
    .Imm(Imm_D), 
    .EXTOp(EXTOp), 
	 
	 //output
    .EXTOut(EXTOut)
    );

D_GRF grf (
    .clk(clk), 
    .reset(reset), 
    .RegWrite(RegWrite_W), 
    .PC_W(PC_W), 
    .A1(A1_D), 
    .A2(A2_D), 
    .A3(A3_W), 
    .GRF_WD(RF_WD_W),

	  //output
    .RF_RD1(RF_RD1), 
    .RF_RD2(RF_RD2)
    );
//----EREG----//
E_REG ereg (
    .clk(clk), 
    .reset(reset), 
    .clr(E_REG_clr),
	 
	 //Control_signal
    .ALUOp(ALUOp), 
    .ALUSrc_Sel(ALUSrc_Sel), 
    .MemWrite(MemWrite), 
    .RegWrite(RegWrite), 
    .Elevel_Sel(Elevel_Sel), 
    .Mlevel_Sel(Mlevel_Sel), 
    .Wlevel_Sel(Wlevel_Sel), 

    .Instr_D(Instr_D), 
    .PC_D(PC_D), 
    .MF_Rs_D(MF_Rs_D), 
    .MF_Rt_D(MF_Rt_D), 
    .EXTOut(EXTOut), 
    .A1_D(A1_D), 
    .A2_D(A2_D), 
    .A3(A3), 
    .Tnew(Tnew), 
	 
	 //output
    .ALUOp_E(ALUOp_E), 
    .ALUSrc_Sel_E(ALUSrc_Sel_E), 
    .MemWrite_E(MemWrite_E), 
    .RegWrite_E(RegWrite_E), 
    .Elevel_Sel_E(Elevel_Sel_E), 
    .Mlevel_Sel_E(Mlevel_Sel_E), 
    .Wlevel_Sel_E(Wlevel_Sel_E), 
	 
    .Instr_E(Instr_E), 
    .PC_E(PC_E), 
    .V1_E(V1_E), 	  //Rs value
    .V2_E(V2_E), 	  //Rt value
    .E32_E(E32_E), 
    .A1_E(A1_E), 
    .A2_E(A2_E), 
    .A3_E(A3_E), 
    .Tnew_E(Tnew_E)
    );	
	 
//----E----//	 
E_ALU alu (
    .Src_A(MF_Rs_E), 
    .Src_B(Mux1_Output), 
    .ALUOp(ALUOp_E), 
	 //output 
    .ALUOut(ALUOut)
    );
//----MREG----//
M_REG mreg (
    .clk(clk), 
    .reset(reset), 

    .MemWrite_E(MemWrite_E), 
    .RegWrite_E(RegWrite_E), 
    .Mlevel_Sel_E(Mlevel_Sel_E), 
    .Wlevel_Sel_E(Wlevel_Sel_E), 
	 
    .Instr_E(Instr_E), 
    .PC_E(PC_E), 
    .ALUOut(ALUOut), 
    .V2_E(MF_Rt_E), 
	 .A1_E(A1_E),
    .A2_E(A2_E), 
    .A3_E(A3_E), 
    .Tnew_E(Tnew_E), 

	//output
    .MemWrite_M(MemWrite_M), 
    .RegWrite_M(RegWrite_M), 
    .Mlevel_Sel_M(Mlevel_Sel_M), 
    .Wlevel_Sel_M(Wlevel_Sel_M), 
	 
    .Instr_M(Instr_M), 
    .PC_M(PC_M), 
    .AO_M(AO_M), 
    .V2_M(V2_M), 
	 .A1_M(A1_M),
    .A2_M(A2_M), 
    .A3_M(A3_M), 
    .Tnew_M(Tnew_M)
    );
	
//----M----//
M_DM dm (
    .clk(clk), 
    .reset(reset), 
	 
    .PC_M(PC_M), 
    .DM_Addr(AO_M), 
    .DM_WD(MF_Rt_M), 
    .MemWrite(MemWrite_M), 
	 
	 //output
    .DM_RD(DM_RD)
    );
	
//-----W----//
W_REG wreg (
    .clk(clk), 
    .reset(reset), 
	 
    .RegWrite_M(RegWrite_M), 
    .Wlevel_Sel_M(Wlevel_Sel_M), 
	 
	 .Instr_M(Instr_M),
    .PC_M(PC_M), 
    .AO_M(AO_M), 
    .DM_RD(DM_RD), 
	 .A1_M(A1_M),
	 .A2_M(A2_M),
    .A3_M(A3_M), 
    .RegWrite_W(RegWrite_W), 
    .Wlevel_Sel_W(Wlevel_Sel_W), 
	 
	 .Instr_W(Instr_W),
    .PC_W(PC_W), 
    .AO_W(AO_W), 
    .DR_W(DR_W),
	 .A1_W(A1_W),
	 .A2_W(A2_W),
    .A3_W(A3_W)
    );
endmodule
