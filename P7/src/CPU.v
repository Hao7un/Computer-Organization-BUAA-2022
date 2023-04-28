`timescale 1ns / 1ps
`include "def.v"
module CPU(
	input clk,
	input reset,

	//Interrupt//
	input [5:0] HWInt,

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
	output [31:0] w_inst_addr,
	output [31:0] macroscopic_pc
    );

	//D E M Instr PC
	wire [31:0] Instr_F, Instr_D, Instr_E,Instr_M, Instr_W;
	wire [31:0] PC_F, PC_D,PC_E,PC_M,PC_W;
	
	//ExcCode 
	wire [4:0] ExcCode_F, ExcCode_D, ExcCode_E,  ExcCode_M;
	
	 //----PC_Output----//
	 wire [31:0] temp_PC;

	 //----D_REG_Output----//
   wire [25:0] Instr_index_D;
	 wire [4:0] A1_D;
	 wire [4:0] A2_D;
	 wire [15:0] Imm_D;
	 wire [4:0] ExcCode_old_D;

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
    wire [2:0] Wlevel_Sel_E;   //W级选择数据转发
    wire [31:0] V1_E;
    wire [31:0] V2_E;
    wire [31:0] E32_E;
	 
	 wire [4:0] A1_E;
	 wire [4:0] A2_E;
    wire [4:0] A3_E;
    wire [2:0] Tnew_E;
	 wire [4:0] ExcCode_old_E;
	 
	 //----ALU_Output----//
	 wire [31:0] ALUOut;
	 wire overflow;
	 
	 //----HILO_Output----//
	 wire [31:0] HILO_Result;
	 
	 //----M_REG----//
    wire RegWrite_M;
	 wire [3:0] DM_Op_M;
    wire [1:0] Mlevel_Sel_M;
    wire [2:0] Wlevel_Sel_M;
    wire [31:0] AO_M;  //写回寄存器的WriteData
    wire [31:0] V2_M;     //输入到DM中的WriteData
	 
	 wire [4:0] A1_M;
	 wire [4:0] A2_M;
    wire [4:0] A3_M;
    wire [2:0] Tnew_M;
	 wire [31:0] HL_M;
	 wire [4:0] ExcCode_old_M;

	//----BE----//
	wire [3:0] MemWrite_byteen;
	
	//----CP0----//
	wire Req;
	wire [31:0] EPCOut;
	wire [31:0] CP0Out;
	
	//----W_REG----//
    wire RegWrite_W;
	 wire [3:0] DM_Op_W;
    wire [2:0] Wlevel_Sel_W;
    wire [31:0] AO_W;
    wire [31:0] DR_W;
	 wire [4:0] A1_W;
	 wire [4:0] A2_W;
    wire [4:0] A3_W; 
	 wire [31:0] HL_W;
	 wire [31:0] CP0Out_W;
	 
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
	
	//--W_Level--//
	wire [31:0] RF_WD_W= (Wlevel_Sel_W==3'b000)?AO_W:
								                             (Wlevel_Sel_W==3'b001)?PC_W+8:
								                             (Wlevel_Sel_W==3'b010)?DR_Ext:
								                             (Wlevel_Sel_W==3'b011)?HL_W:
																	   (Wlevel_Sel_W==3'b100)? CP0Out_W :32'hffffffff;
								
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
	wire [31:0] MF_Rt_M= (A2_M==5'd0)?32'd0:
																	(A2_M==A3_W)?RF_WD_W:V2_M;
	
	//----Others----//
	wire [31:0] Mux1_Output= (ALUSrc_Sel_E==0)?MF_Rt_E:E32_E;
	
//----F---//
	F_PC pc (
    .clk(clk), 
	 .Req(Req),
    .reset(reset), 
    .en(PC_en), 
    .NPC(NPC), 
	 
    .PC(temp_PC)
    );
	 
		assign PC_F=(eret_D)?  EPCOut:  temp_PC;
		assign Instr_F = (excAdEL_F) ? 32'd0 : i_inst_rdata;
		assign i_inst_addr=PC_F;
		
//----AdEL_F:PC-----//
		assign excAdEL_F = ((  |PC_F[1:0]  ) | (PC_F < 32'h0000_3000) | (PC_F > 32'h0000_6ffc))?1'd1:1'd0;
		assign excSyscall_F=(Instr_F[31:26]==`R_Type && Instr_F[5:0]==`syscall_Funct) ? 1'd1:1'd0;		//syscall
		
		assign ExcCode_F = excAdEL_F ? `AdEL :
																	excSyscall_F? `Syscall: `NoneExc;

		assign bd_F=jal_D|jr_D|beq_D|bne_D;

//-----DREG----//
D_REG dreg (
	 //input
    .clk(clk), 
    .reset(reset), 
	 .Req(Req),
    .en(D_REG_en), 
    .Instr_F(Instr_F), 
    .PC_F(PC_F), 
	 .ExcCode_F(ExcCode_F),
	 .bd_F(bd_F),
	 
	 //output
    .Instr_D(Instr_D), 
    .PC_D(PC_D), 
    .Instr_index_D(Instr_index_D), 
    .A1_D(A1_D), 
    .A2_D(A2_D), 
    .Imm_D(Imm_D),
	 .ExcCode_old_D(ExcCode_old_D),
	 .bd_D(bd_D)
    );
wire [3:0] ALUOp;
wire [1:0] EXTOp;
wire [2:0] NPCOp;
wire [2:0] BranchOp;
wire [3:0] HILO_Op;
wire [3:0] DM_Op;
wire [1:0] Elevel_Sel;
wire [1:0] Mlevel_Sel;
wire [2:0] Wlevel_Sel;
Main_CU cu (
    .Instr_D(Instr_D), 
    .RegWrite(RegWrite), 
    .start(start), 
    .ALUOp(ALUOp), 
    .EXTOp(EXTOp), 
    .NPCOp(NPCOp), 
    .BranchOp(BranchOp), 
    .HILO_Op(HILO_Op), 
    .DM_Op(DM_Op), 
    .ALUSrc_Sel(ALUSrc_Sel), 
    .Elevel_Sel(Elevel_Sel), 
    .Mlevel_Sel(Mlevel_Sel), 
    .Wlevel_Sel(Wlevel_Sel)
    );

//----D----//
    wire [6:0] Op_D = Instr_D[31:26],Funct_D = Instr_D[5:0];
    wire add_D=(Op_D==`R_Type)&&(Funct_D==`add_Funct),sub_D=(Op_D==`R_Type)&&(Funct_D==`sub_Funct),or_D=(Op_D==`R_Type)&&(Funct_D==`or_Funct),and_D=(Op_D==`R_Type)&&(Funct_D==`and_Funct);
	 wire slt_D=(Op_D==`R_Type)&&(Funct_D==`slt_Funct), sltu_D=(Op_D==`R_Type)&&(Funct_D==`sltu_Funct);
	 wire srl_D=(Op_D==`R_Type)&&(Funct_D==`srl_Funct);
    wire ori_D=(Op_D==`ori_Op), andi_D=(Op_D==`andi_Op),addi_D=(Op_D==`addi_Op);
	 wire lui_D=(Op_D==`lui_Op);
    wire beq_D=(Op_D==`beq_Op), bne_D=(Op_D==`bne_Op);
    wire lw_D = (Op_D==`lw_Op),   lh_D=(Op_D==`lh_Op),     lb_D=(Op_D==`lb_Op);
    wire sw_D= (Op_D==`sw_Op),  sh_D=(Op_D==`sh_Op),  sb_D=(Op_D==`sb_Op);
    wire jr_D=(Op_D==`R_Type)  &&  (Funct_D==`jr_Funct),    jal_D=(Op_D==`jal_Op);
	 wire mult_D=(Op_D==`R_Type)&&(Funct_D==`mult_Funct),multu_D=(Op_D==`R_Type)&&(Funct_D==`multu_Funct),div_D=(Op_D==`R_Type)&&(Funct_D==`div_Funct),divu_D=(Op_D==`R_Type)&&(Funct_D==`divu_Funct);
	 wire mfhi_D=(Op_D==`R_Type)&&(Funct_D==`mfhi_Funct),mflo_D=(Op_D==`R_Type)&&(Funct_D==`mflo_Funct),mthi_D=(Op_D==`R_Type)&&(Funct_D==`mthi_Funct),mtlo_D=(Op_D==`R_Type)&&(Funct_D==`mtlo_Funct);
	 wire eret_D=(Op_D==`CP0_Type)&&(Funct_D==`eret_Funct),  mfc0_D=(Op_D==`CP0_Type)&&(Instr_D[25:21]==`mfc0_Rs),  mtc0_D=(Op_D==`CP0_Type)&&(Instr_D[25:21]==`mtc0_Rs);
	 wire syscall_D=(Op_D==6'd0)&&(Funct_D==`syscall_Funct);
	 wire nop_D=(Op_D==6'd0)&&(Funct_D==6'd0);
	 
 	 assign RI_D=!(add_D|sub_D|or_D|and_D|slt_D|sltu_D|srl_D|ori_D|andi_D|addi_D|lui_D|beq_D|bne_D|lw_D|lh_D|lb_D|sw_D|sh_D|sb_D|jr_D|jal_D|
					                    mult_D|multu_D|div_D|divu_D|mfhi_D|mflo_D|mthi_D|mtlo_D|nop_D|eret_D|mfc0_D|mtc0_D|syscall_D);
	 
	 assign ExcCode_D =  (ExcCode_old_D>0 ) ? ExcCode_old_D:
																  RI_D ? `RI :`NoneExc;

D_NPC npc (
	  .Req(Req),
	  .eret_D(eret_D),
	  .EPCOut(EPCOut),
	  
    .PC_F(PC_F), 
    .PC_D(PC_D),
	 
    .BranchSignal(BranchSignal), 
    .offset(EXTOut), 
    .Instr_index(Instr_index_D), 
    .RegData(MF_Rs_D), 
    .NPCOp(NPCOp), 
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
	 
		assign w_grf_we=RegWrite_W;
		assign w_grf_addr=A3_W;
		assign w_grf_wdata=RF_WD_W;
		assign w_inst_addr=PC_W;	 
	
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

	 wire [4:0] A3;
	 wire [2:0] Tnew;

//----EREG----//
E_REG ereg (
    .clk(clk), 
    .reset(reset), 
	 .Req(Req),
    .flush(E_REG_flush), 
	 
    .ALUOp(ALUOp), 
	 .HILO_Op(HILO_Op),
	 .DM_Op(DM_Op),
	 .start(start),
	 
    .ALUSrc_Sel(ALUSrc_Sel), 
    .RegWrite(RegWrite), 
    .Elevel_Sel(Elevel_Sel), 
    .Mlevel_Sel(Mlevel_Sel), 
    .Wlevel_Sel(Wlevel_Sel), 
    .Instr_D( (RI_D)? 32'h0:Instr_D),		//considered as nop when RI happens 
    .PC_D(PC_D), 
    .MF_Rs_D(MF_Rs_D), 
    .MF_Rt_D(MF_Rt_D), 
    .EXTOut(EXTOut), 
    .A1_D(A1_D), 
    .A2_D(A2_D), 
    .A3(A3), 
    .Tnew(Tnew), 
	 .ExcCode_D(ExcCode_D),
	 .bd_D(bd_D),
	 
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
    .Tnew_E(Tnew_E),
	 .ExcCode_old_E(ExcCode_old_E),
	 .bd_E(bd_E)
    );	
	 
//----E----//	 
	 wire [6:0] Op_E = Instr_E[31:26],Funct_E = Instr_E[5:0];
    wire add_E=(Op_E==`R_Type)&&(Funct_E==`add_Funct),sub_E=(Op_E==`R_Type)&&(Funct_E==`sub_Funct),addi_E=(Op_E==`addi_Op);
	 wire sw_E =  (Op_E==`sw_Op), sh_E=(Op_E==`sh_Op), sb_E=(Op_E==`sb_Op);
	 wire lw_E  =  (Op_E==`lw_Op),  lh_E=(Op_E==`lh_Op),    lb_E=(Op_E==`lb_Op);
	 
	 assign is_ARI     =   add_E|sub_E|addi_E;
	 assign is_Store=   sw_E   |sh_E   |sb_E;
	 assign is_Load =   lw_E    |lh_E    |lb_E;
	 assign OvARI_E =            is_ARI    &&  overflow;
	 assign OvStore_E   =  is_Store   &&  overflow;
	 assign OvLoad_E   =   is_Load    &&  overflow;
	 
	 assign ExcCode_E =  (ExcCode_old_E>0) ? ExcCode_old_E :
																 OvARI_E ?     `Ov :
																 OvStore_E? `AdES  :
																 OvLoad_E?  `AdEL: `NoneExc;

E_ALU alu (
    .Src_A(MF_Rs_E), 
    .Src_B(Mux1_Output), 
	 .shamt(Instr_E[10:6]),
    .ALUOp(ALUOp_E), 
    .ALUOut(ALUOut),
	 .overflow(overflow)
    );

E_HILO hilo (
    .clk(clk), 
    .reset(reset), 
	 .Req(Req),
	 
    .D1(MF_Rs_E), 
    .D2(MF_Rt_E), 
    .HILO_Op(HILO_Op_E), 		
    .HILO_Result(HILO_Result), 	
    .HILO_busy(HILO_busy)		
    );

//----MREG----//
M_REG mreg (
    .clk(clk), 
    .reset(reset), 
	 .Req(Req),
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
	 .ExcCode_E(ExcCode_E),
	 .bd_E(bd_E),
	 
	 //output
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
	 .HL_M(HL_M),
	 .ExcCode_old_M(ExcCode_old_M),
	 .bd_M(bd_M)
    );
	
//----M----//
	 wire [6:0] Op_M = Instr_M[31:26],  Funct_M = Instr_M[5:0];
    wire lw_M=(Op_M==`lw_Op),lh_M=(Op_M==`lh_Op),lb_M=(Op_M==`lb_Op);
    wire sw_M=(Op_M==`sw_Op),sh_M=(Op_M==`sh_Op),sb_M=(Op_M==`sb_Op);
	 wire [31:0] addr_M;
	 assign addr_M=AO_M;
	 
	 //----AdEL----//
	 assign Load_AlignError   =  (lw_M&(|addr_M[1:0]))  ||  (lh_M&(addr_M[0]));
	 assign Load_TimerError =   (lh_M|lb_M) && ((addr_M>= 32'h0000_7f00  &&  addr_M<=32'h0000_7f0b)||
																																	 (addr_M>= 32'h0000_7f10  &&  addr_M<=32'h0000_7f1b));
																																	 
	 assign Load_RangeError  =  (lw_M|lh_M|lb_M)   &&   !(((addr_M>= 32'h0000_0000) && (addr_M <= 32'h0000_2fff))  ||
																																							  ((addr_M>= 32'h0000_7f00) && (addr_M<= 32'h0000_7f0b))  ||
																																							  ((addr_M >= 32'h0000_7f10) && (addr_M<= 32'h0000_7f1b)) ||
																																							  ((addr_M >= 32'h0000_7f20) && (addr_M<= 32'h0000_7f23)));
	 assign AdEL_M =Load_AlignError | Load_TimerError | Load_RangeError;
	 
	 //----AdES----//
	 assign Store_AlignError  =  (sw_M&(|addr_M[1:0]))  ||  (sh_M&(addr_M[0]));
	 
	 assign Store_TimerError =  (sh_M|sb_M) && ((addr_M>= 32'h0000_7f00  &&  addr_M<=32'h0000_7f0b)||
																																	  (addr_M>= 32'h0000_7f10  &&  addr_M<=32'h0000_7f1b)); 	 
																																	 
	 assign Store_CounterError =   (sw_M|sh_M|sb_M) &&(((addr_M>= 32'h0000_7f08) && (addr_M<= 32'h0000_7f0b))  ||
																																							    ((addr_M >= 32'h0000_7f18) && (addr_M<= 32'h0000_7f1b)) );
																																							  
	 assign Store_RangeError      =   (sw_M|sh_M|sb_M) &&!(((addr_M>= 32'h0000_0000) && (addr_M <= 32'h0000_2fff))  ||
																																							  ((addr_M>= 32'h0000_7f00) && (addr_M<= 32'h0000_7f0b))  ||
																																							  ((addr_M >= 32'h0000_7f10) && (addr_M<= 32'h0000_7f1b)) ||
																																							  ((addr_M >= 32'h0000_7f20) && (addr_M<= 32'h0000_7f23)));
																																							  
	 assign AdES_M = Store_AlignError | Store_TimerError | Store_CounterError | Store_RangeError;
	 
	 assign ExcCode_M= (ExcCode_old_M>0)? ExcCode_old_M:
																 AdEL_M?`AdEL:
																 AdES_M?`AdES: 
																 (cu0==1'd0&&exl==1'd0&&(mtc0_M|mfc0_M))?`RI:
																 `NoneExc;

	 //CP0 SIGNAL//
	 assign eret_M  = (Op_M==`CP0_Type)  &&  (Funct_M==`eret_Funct);
	 assign mtc0_M=(Op_M==`CP0_Type)  &&  (Instr_M[25:21]==`mtc0_Rs);
	 assign mfc0_M=(Op_M==`CP0_Type)  &&  (Instr_M[25:21]==`mfc0_Rs);

//-------cp0-------//
CP0 cp0 (
    .clk(clk), 			
    .reset(reset),
	 
    .A1(Instr_M[15:11]), 		
    .A2(Instr_M[15:11]), 			
    .CP0In(MF_Rt_M), 	
    .PC(PC_M),			
    .BDIn(bd_M),			  
    .ExcCode(ExcCode_M),  
    .HWInt(HWInt), 		  
    .We(mtc0_M), 			 
    .EXLClr(eret_M),	 
	 
	 //output
    .Req(Req), 
    .EPCOut(EPCOut), 
    .CP0Out(CP0Out),
	 .cu0(cu0),
	 .exl(exl)
    );
					 
M_BE be (
    .A(AO_M[1:0]), 
    .DM_Op(DM_Op_M), 		
    .MemWrite_byteen(MemWrite_byteen)
    );
	 
	 assign macroscopic_pc= PC_M;
	assign m_data_addr =AO_M;
	assign m_data_wdata = (DM_Op_M==4'd1)?  {4{MF_Rt_M[7:0]}}:
																			(DM_Op_M==4'd2)?  {2{MF_Rt_M[15:0]}}:	
																			(DM_Op_M==4'd3)?  MF_Rt_M:32'h0;
															
	assign m_data_byteen= (Req==1) ?  4'b0 : MemWrite_byteen;
	assign m_inst_addr = PC_M;

//-----W----//
W_REG wreg (
    .clk(clk), 
    .reset(reset), 
	 .Req(Req),
	 
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
	 .CP0Out(CP0Out),
	 
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
	 .HL_W(HL_W),
	 .CP0Out_W(CP0Out_W)
    );

W_DataEXT dataext (
    .DM_Op_W(DM_Op_W), 
    .Din(DR_W), 
    .A(AO_W[1:0]), 
    .Dout(DR_Ext)
    );

StallUnit stallunit (
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
    .Tnew(Tnew), 
    .A3(A3), 
    .D_REG_en(D_REG_en), 
    .E_REG_flush(E_REG_flush), 
    .PC_en(PC_en)
    );
	 
endmodule
	 
