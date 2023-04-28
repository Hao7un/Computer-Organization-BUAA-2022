`timescale 1ns / 1ps

module mips(
	input clk,
	input reset,
	
	//IM_Port//
	output [31:0] i_inst_addr,
	input [31:0] i_inst_rdata,
	
	//DM_Port//
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
	
	 wire PC_en,D_REG_en,E_REG_clr;
	 wire RegWrite;
	 wire [2:0] BranchOp;
	 wire [3:0] ALUOp;
	 wire [1:0] EXTOp;
	 wire [2:0] NPCOp;
	 wire [3:0] HILO_Op;
	 wire [3:0] DM_Op;
	 wire ALU_Src_Sel;
	 wire [1:0] Elevel_Sel,Mlevel_Sel,Wlevel_Sel;
	 wire [4:0] A3,A1_D,A2_D,A3_E,A3_M;
	 wire [31:0] Instr_D,Instr_E,Instr_M;
	 wire [2:0] Tnew_E,Tnew_M,Tnew;
	 wire HILO_busy,start;
	 wire start_E;
	 
datapath dp (
    .clk(clk), 
    .reset(reset), 
    .PC_en(PC_en), 
    .D_REG_en(D_REG_en), 
    .E_REG_clr(E_REG_clr), 
    .RegWrite(RegWrite), 
	 .start(start),
	 .BranchOp(BranchOp),
    .ALUOp(ALUOp), 
    .EXTOp(EXTOp), 
    .NPCOp(NPCOp), 
	 .HILO_Op(HILO_Op),
	 .DM_Op(DM_Op),
	 
	 
    .ALUSrc_Sel(ALU_Src_Sel), 
    .Elevel_Sel(Elevel_Sel), 
    .Mlevel_Sel(Mlevel_Sel), 
    .Wlevel_Sel(Wlevel_Sel), 
    .A3(A3), 
    .Tnew(Tnew), 
    .Instr_D_out(Instr_D), 
    .Tnew_E_out(Tnew_E), 
    .Tnew_M_out(Tnew_M), 
    .A1_D_out(A1_D), 
    .A2_D_out(A2_D), 
    .A3_E_out(A3_E), 
    .A3_M_out(A3_M),
	 .HILO_busy(HILO_busy),
	 .start_E(start_E),
	 
	 .i_inst_addr(i_inst_addr),
	 .i_inst_rdata(i_inst_rdata),
	 
	  .m_data_rdata(m_data_rdata),
	  .m_data_addr(m_data_addr),
	  .m_data_wdata(m_data_wdata),
	  .m_data_byteen(m_data_byteen),
	  .m_inst_addr(m_inst_addr),

     .w_grf_we(w_grf_we),
     .w_grf_addr(w_grf_addr),
     .w_grf_wdata(w_grf_wdata),
     .w_inst_addr(w_inst_addr)
    );
	 
controller ctrl (
    .clk(clk), 
    .reset(reset), 
    .Instr_D(Instr_D), 
    .Instr_E(Instr_E), 
    .Instr_M(Instr_M), 
    .Tnew_E(Tnew_E), 
    .Tnew_M(Tnew_M), 
    .A1_D(A1_D), 
    .A2_D(A2_D), 
    .A3_E(A3_E), 
    .A3_M(A3_M), 
	 .HILO_busy(HILO_busy),
	 .start_E(start_E),
	 
    .PC_en(PC_en), 
    .D_REG_en(D_REG_en), 
    .E_REG_clr(E_REG_clr), 
    .A3(A3), 
    .Tnew(Tnew), 
	 
	 .RegWrite(RegWrite), 
	 .start(start),
	 .BranchOp(BranchOp),
    .ALUOp(ALUOp), 
	 .NPCOp(NPCOp),
	 .EXTOp(EXTOp),
	 .HILO_Op(HILO_Op),
	 .DM_Op(DM_Op),
	 
	 
    .ALU_Src_Sel(ALU_Src_Sel), 
    
    .Elevel_Sel(Elevel_Sel), 
    .Mlevel_Sel(Mlevel_Sel), 
    .Wlevel_Sel(Wlevel_Sel)
    );

endmodule