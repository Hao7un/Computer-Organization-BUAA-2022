`timescale 1ns / 1ps
`include "def.v"

module Main_CU(
    input [31:0] Instr_D,

    //----使能信号----//
    output reg RegWrite,
	 output reg start,

    //-----操作选择信号----//
    output reg [3:0] ALUOp,
    output reg [1:0] EXTOp,
    output reg [2:0] NPCOp,
	 output reg [2:0] BranchOp,	//use for cmp
	 output reg [3:0] HILO_Op,
	 output reg [3:0] DM_Op,
	
    //----MUX-----//
    output reg ALUSrc_Sel,		       //选择RF_RD2或者立即数--->ALU_SrcB
	 output reg [1:0] Elevel_Sel,		
    output reg [1:0] Mlevel_Sel,
    output reg [2:0] Wlevel_Sel
);

	wire  [5:0] Op,Funct;
	assign Op = Instr_D[31:26];
	assign Funct = Instr_D[5:0];
	
  always @(*) begin
    if(Op==`R_Type)begin     //R_Type Instruction
        case(Funct)
            `add_Funct:begin
                //
                RegWrite<=1;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end

            `sub_Funct:begin
                //
					 start<=1'd0;
                RegWrite<=1;
                //
                ALUOp<=4'b0001;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end

            `and_Funct:begin
                //
					 start<=1'd0;
                RegWrite<=1;
                //
                ALUOp<=4'b0011;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end
            `or_Funct:begin
                //
					 start<=1'd0;
                RegWrite<=1;
                //
                ALUOp<=4'b0010;  //the same as 'ori'
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end
				
				`slt_Funct:begin
                //
					 start<=1'd0;
                RegWrite<=1;
                //
                ALUOp<=4'b0100;  
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;				
				end
				`sltu_Funct:begin
                //
					 start<=1'd0;
                RegWrite<=1;
                //
                ALUOp<=4'b0101;  //the same as 'ori'
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;		 
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;				
				end
				
				`srl_Funct:begin
                //
					 start<=1'd0;
                RegWrite<=1;
                //
                ALUOp<=4'b0110; 
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;		 
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;								
				end

            `jr_Funct:begin
                //
					 start<=1'd0;
                RegWrite<=0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b011;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end
				
				`mult_Funct:begin
                //
					 start<=1'd1;
                RegWrite<=0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd1;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
				end
				`multu_Funct:begin
                //
					 start<=1'd1;
                RegWrite<=0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd2;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
				end
				`div_Funct:begin
                //
                RegWrite<=0;
					 start<=1'd1;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd3; 
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
				end
				`divu_Funct:begin
                //
                RegWrite<=0;
					 start<=1'd1;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd4;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
				end
				`mfhi_Funct:begin
                //
					 start<=1'd0;
                RegWrite<=1;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd5;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b10;
                Wlevel_Sel<=3'b011;
				end
				`mflo_Funct:begin
                //
                RegWrite<=1;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd6;	 
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b10;
                Wlevel_Sel<=3'b011;
				end
				`mthi_Funct:begin
                //
                RegWrite<=0;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd7;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
				end
				`mtlo_Funct:begin
                //
                RegWrite<=0;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd8; 
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
				end
				default:begin
                RegWrite<=0;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;				
				end
        endcase
    end

	 else if(Op==`CP0_Type)begin
	 
		if(Funct==`eret_Funct) begin						//erect	
                RegWrite<=0;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;				
		end
		
		else if(Instr_D[25:21]==`mfc0_Rs) begin   //mfc0
                RegWrite<=1;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b100;	
		end
		
		else if(Instr_D[25:21]==`mtc0_Rs) begin	//mtc0
                RegWrite<=0;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;	   
                Mlevel_Sel<=2'b00;		 
                Wlevel_Sel<=3'b000;			
		end
	 
	 end
	 
    else begin              //non-R_Type Instruction
        case(Op)
            `ori_Op:begin
                //
                RegWrite<=1;
					 start<=1'd0;
                //
                ALUOp<=4'b0010;
                EXTOp<=2'b00;       //零拓展
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=1;      //选择拓展后的立即数
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end
            `addi_Op:begin
                //
                RegWrite<=1;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b01;       //sign-extend
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=1;      //choose the imm
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end
            `andi_Op:begin
                //
                RegWrite<=1;
					 start<=1'd0;
                //
                ALUOp<=4'b0011;
                EXTOp<=2'b00;       //zero-extend
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=1;      //imm
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end

            `lui_Op: begin
                //
                RegWrite<=1;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;
                EXTOp<=2'b10;       //lui
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=1;      //选择拓展后的立即数
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end

            `beq_Op: begin             //流水线中b_type指令与ALU，在CMP中进行比较
                //
                RegWrite<=0;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;      //无关
                EXTOp<=2'b01;       //符号拓展
                NPCOp<=3'b001;      //选择branch
					 BranchOp<=3'b001;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;    
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end

            `bne_Op: begin             //流水线中b_type指令与ALU，在CMP中进行比较
                //
                RegWrite<=0;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;      //无关
                EXTOp<=2'b01;       //符号拓展
                NPCOp<=3'b001;      //选择branch
					 BranchOp<=3'b010;
					 HILO_Op<=4'd0; 
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;    
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end
            `sb_Op: begin
                //
                RegWrite<=0;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;      //加法
                EXTOp<=2'b01;       //符号拓展
                NPCOp<=3'b000;   
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd1;
                //
                ALUSrc_Sel<=1;      //选择立即数
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end
            `sh_Op: begin
                //
                RegWrite<=0;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;      //加法
                EXTOp<=2'b01;       //符号拓展
                NPCOp<=3'b000;   
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd2;
                //
                ALUSrc_Sel<=1;      //选择立即数
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end
            `sw_Op: begin
                //
                RegWrite<=0;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;      //加法
                EXTOp<=2'b01;       //符号拓展
                NPCOp<=3'b000;   
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd3;
                //
                ALUSrc_Sel<=1;      //选择立即数
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b000;
            end
            `lb_Op: begin
                //
                RegWrite<=1;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;      //加法
                EXTOp<=2'b01;       //符号拓展
                NPCOp<=3'b000;      
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd4;
                //
                ALUSrc_Sel<=1;      //选择立即数
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b010;
            end
				
            `lh_Op: begin
                //
                RegWrite<=1;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;      //加法
                EXTOp<=2'b01;       //符号拓展
                NPCOp<=3'b000;      
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd5;
                //
                ALUSrc_Sel<=1;      //选择立即数
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b010;
            end		
				
            `lw_Op: begin
                //
                RegWrite<=1;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;      //加法
                EXTOp<=2'b01;       //符号拓展
                NPCOp<=3'b000;      
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd6;
                //
                ALUSrc_Sel<=1;      //选择立即数
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=3'b010;
            end
				
            `jal_Op: begin
                //
                RegWrite<=1;
					 start<=1'd0;
                //
                ALUOp<=4'b0000;      
                EXTOp<=2'b00;       
                NPCOp<=3'b010;   
					 BranchOp<=3'b000;
					 HILO_Op<=4'd0;
					 DM_Op<=4'd0;
                //
                ALUSrc_Sel<=0;   
					 Elevel_Sel<=2'b01;
                Mlevel_Sel<=2'b01;
                Wlevel_Sel<=3'b001;  
            end
        endcase
    end
  end

endmodule

