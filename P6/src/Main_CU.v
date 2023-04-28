`timescale 1ns / 1ps

//----宏定义----//

`define R_Type 6'b000000

//Statement：R类型指令定义的是Funct，非R类型定义的是Op

//----cal_r----//    `timescale 1ns / 1ps

//----宏定义----//

`define R_Type 6'b000000

//Statement：R类型指令定义的是Funct，非R类型定义的是Op

//----cal_r----//          
`define add_Funct 6'b100000
`define sub_Funct 6'b100010
`define and_Funct 6'b100100 
`define or_Funct  6'b100101
`define slt_Funct  6'b101010
`define sltu_Funct 6'b101011

//----cal_i----//     
`define ori_Op 6'b001101
`define addi_Op 6'b001000
`define andi_Op 6'b001100

//----lui----//
`define lui_Op 6'b001111

//----branch----//
`define beq_Op 6'b000100
`define bne_Op 6'b000101

//----load-----//           
`define lw_Op  6'b100011
`define lh_Op  6'b100001
`define lb_Op  6'b100000

//----store----//
`define sw_Op  6'b101011
`define sh_Op  6'b101001
`define sb_Op  6'b101000

//----jumplink----//
`define jal_Op 6'b000011   

//----jumpreg----//
`define jr_Funct  6'b001000

//----md----//
`define mult_Funct  6'b011000
`define multu_Funct 6'b011001
`define div_Funct   6'b011010
`define divu_Funct  6'b011011

//----mf----//
`define mfhi_Funct  6'b010000
`define mflo_Funct  6'b010010

//----mt----//
`define mthi_Funct  6'b010001
`define mtlo_Funct  6'b010011

module Main_CU(
    input [5:0] Op,
    input [5:0] Funct,

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
    output reg [1:0] Wlevel_Sel
);

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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;				
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
                Wlevel_Sel<=2'b00;				
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b11;
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
                Wlevel_Sel<=2'b11;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;				
				end
        endcase
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b00;
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
                Wlevel_Sel<=2'b10;
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
                Wlevel_Sel<=2'b10;
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
                Wlevel_Sel<=2'b10;
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
                Wlevel_Sel<=2'b01;  
            end
        endcase
    end
  end

endmodule

