`timescale 1ns / 1ps

module datapath(
	input clk,
	input reset,
	
	//---stall_signal----//
	input PC_en,
	input D_REG_en,
	input E_REG_clr,
	
	//----Control_Signal----//
	input RegWrite,
	
	input [3:0] ALUOp,
	input [1:0] EXTOp,
	input [2:0] NPCOp,
	input [2:0] BranchOp,
	input [3:0] HILO_Op,
	input [3:0] DM_Op,
	
	input start,
	input ALUSrc_Sel,
	input [1:0] Elevel_Sel,
	input [1:0] Mlevel_Sel,
	input [1:0] Wlevel_Sel,
	
	input [4:0] A3,
	input [2:0] Tnew,
	
	//StallUnit
	output [31:0] Instr_D_out,
	output [31:0] Instr_E_out,
	output [31:0] Instr_M_out,
	output [2:0] Tnew_E_out,
	output [2:0] Tnew_M_out,
	output [4:0] A1_D_out,
	output [4:0] A2_D_out,
	output [4:0] A3_E_out,
	output [4:0] A3_M_out,
	output HILO_busy,
	output start_E,
	
	//----IM_Port----//
	output [31:0] i_inst_addr,
	input [31:0] i_inst_rdata,
	
	//----DM_Port----//
	input [31:0] m_data_rdata,
	output [31:0] m_data_addr,
	output [31:0] m_data_wdata,
	output [3:0] m_data_byteen,
	output [31:0] m_inst_addr,
	
	//GRF_Port//
	output w_grf_we,
	output [4:0] w_grf_addr,
	output [31:0] w_grf_wdata,
	output [31:0] w_inst_addr	
    );
	 
	//datapath_output
	assign Instr_D_out=Instr_D;
	assign Instr_E_out=Instr_E;
	assign Instr_M_out=Instr_M;
	assign Tnew_E_out=Tnew_E;
	assign Tnew_M_out=Tnew_M;
	assign A1_D_out=A1_D;
	assign A2_D_out=A2_D;
	assign A3_E_out=A3_E;
	assign A3_M_out=A3_M;
	
	//IM_Port//
	assign i_inst_addr=PC_F;
	
	//DM_Port//
	assign m_data_addr =AO_M;
	assign m_data_wdata =(DM_Op_M==4'd1)?{4{MF_Rt_M[7:0]}}:
								(DM_Op_M==4'd2)?{2{MF_Rt_M[15:0]}}:	
								(DM_Op_M==4'd3)?MF_Rt_M:32'h0;
								
	// assign m_data_byteen done!
	assign m_inst_addr = PC_M;
	
	//GRFPort//
	assign w_grf_we=RegWrite_W;
	assign w_grf_addr=A3_W;
	assign w_grf_wdata=RF_WD_W;
	assign w_inst_addr=PC_W;	 

//----DATAPATH_Signal----//
	 //----PC_Output----//
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
	 wire [3:0] HILO_Op_E;
	 wire [3:0] DM_Op_E;
    wire ALUSrc_Sel_E;
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
	 
	 //----HILO_Output----//
	 wire [31:0] HILO_Result;
	 
	 //----M_REG----//
    wire RegWrite_M;
	 wire [3:0] DM_Op_M;
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
	 wire [31:0] HL_M;

	//----BE----//
	// wire [3:0] m_data_byteen;
	
	//----W_REG----//
	 wire [31:0] Instr_W;
    wire RegWrite_W;
	 wire [3:0] DM_Op_W;
    wire [1:0] Wlevel_Sel_W;
    wire [31:0] PC_W;
    wire [31:0] AO_W;
    wire [31:0] DR_W;
	 
	 wire [4:0] A1_W;
	 wire [4:0] A2_W;
    wire [4:0] A3_W; 
	 wire [31:0] HL_W;
	 
	 //----DataExt----//
	 wire [31:0] DR_Ext;

	//----MUX-----//
	
	//----Forward----//
	//--E_Level--//
	wire [31:0] RF_WD_E= (Elevel_Sel_E==2'b00)? E32_E:
								(Elevel_Sel_E==2'b01)? PC_E+8:32'hffffffff;
	//--M_Level--//
	wire [31:0] RF_WD_M=(Mlevel_Sel_M==2'b00)?AO_M:
								(Mlevel_Sel_M==2'b01)?PC_M+8:
								(Mlevel_Sel_M==2'b10)?HL_M:32'hffffffff;
	
	//--M_Level--//
	wire [31:0] RF_WD_W= (Wlevel_Sel_W==2'b00)?AO_W:
								(Wlevel_Sel_W==2'b01)?PC_W+8:
								(Wlevel_Sel_W==2'b10)?DR_Ext:
								(Wlevel_Sel_W==2'b11)?HL_W:32'hffffffff;
								
	//-----Receive----//
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
	
//----F---//
	F_PC pc (
	//input
    .clk(clk), 
    .reset(reset), 
    .en(PC_en), 
    .NPC(NPC),
	//output
    .PC(PC_F)
    );

//-----DREG----//
D_REG dreg (
	 //input
    .clk(clk), 
    .reset(reset), 
    .en(D_REG_en), 
    .Instr_F(i_inst_rdata), 
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
	//input
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
    .BranchSignal(BranchSignal)
    );

D_EXT ext (
    .Imm(Imm_D), 
    .EXTOp(EXTOp), 
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
    .RF_RD1(RF_RD1), 
    .RF_RD2(RF_RD2)
    );
//----EREG----//
E_REG ereg (
    .clk(clk), 
    .reset(reset), 
    .clr(E_REG_clr), 
    .ALUOp(ALUOp), 
	 .HILO_Op(HILO_Op),
	 .DM_Op(DM_Op),
	 .start(start),
	 
    .ALUSrc_Sel(ALUSrc_Sel), 
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
	 .HILO_Op_E(HILO_Op_E),
	 .DM_Op_E(DM_Op_E),
	 .start_E(start_E),
	 
    .ALUSrc_Sel_E(ALUSrc_Sel_E), 
    .RegWrite_E(RegWrite_E), 
    .Elevel_Sel_E(Elevel_Sel_E), 
    .Mlevel_Sel_E(Mlevel_Sel_E), 
    .Wlevel_Sel_E(Wlevel_Sel_E),
	 
    .Instr_E(Instr_E), 
    .PC_E(PC_E), 
    .V1_E(V1_E), 
    .V2_E(V2_E), 
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
    .ALUOut(ALUOut)
    );

E_HILO hilo (
    .clk(clk), 
    .reset(reset), 
    .D1(MF_Rs_E), 
    .D2(MF_Rt_E), 
    .HILO_Op(HILO_Op_E), 				//from controller
    .HILO_Result(HILO_Result), 	// to MREG
    .HILO_busy(HILO_busy)			//To stall unit
    );

//----MREG----//
M_REG mreg (
    .clk(clk), 
    .reset(reset), 
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
	 .HILO_Result(HILO_Result),
	 .DM_Op_E(DM_Op_E),

    .RegWrite_M(RegWrite_M), 
	 .DM_Op_M(DM_Op_M),
    .Mlevel_Sel_M(Mlevel_Sel_M), 
    .Wlevel_Sel_M(Wlevel_Sel_M), 
    .Instr_M(Instr_M), 
    .PC_M(PC_M), 
    .AO_M(AO_M), 
    .V2_M(V2_M), 
	 .A1_M(A1_M),
    .A2_M(A2_M), 
    .A3_M(A3_M), 
    .Tnew_M(Tnew_M),
	 .HL_M(HL_M)
    );
	
//----M----//

M_BE be (
    .A(AO_M[1:0]), 
    .DM_Op(DM_Op_M), 					//from the controoler 
    .m_data_byteen(m_data_byteen)
    );
	
//-----W----//
W_REG wreg (
    .clk(clk), 
    .reset(reset), 
    .RegWrite_M(RegWrite_M), 
	 .DM_Op_M(DM_Op_M),
    .Wlevel_Sel_M(Wlevel_Sel_M), 
	 .Instr_M(Instr_M),
    .PC_M(PC_M), 
    .AO_M(AO_M), 
    .DM_RD(m_data_rdata), 
	 .A1_M(A1_M),
	 .A2_M(A2_M),
    .A3_M(A3_M), 
	 .HL_M(HL_M),
	 //output
    .RegWrite_W(RegWrite_W), 
	 .DM_Op_W(DM_Op_W),
    .Wlevel_Sel_W(Wlevel_Sel_W), 
	 .Instr_W(Instr_W),
    .PC_W(PC_W), 
    .AO_W(AO_W), 
    .DR_W(DR_W),
	 .A1_W(A1_W),
	 .A2_W(A2_W),
    .A3_W(A3_W),
	 .HL_W(HL_W)
    );

W_DataEXT dataext (
    .DM_Op_W(DM_Op_W), 
    .Din(DR_W), 
    .A(AO_W[1:0]), 
    .Dout(DR_Ext)
    );

endmodule
