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

//----cal_i----//     
`define ori_Op 6'b001101

//----lui----//
`define lui_Op 6'b001111

//----branch----//
`define beq_Op 6'b000100

//----load-----//           
`define lw_Op  6'b100011

//----store----//
`define sw_Op  6'b101011

//----jumplink----//
`define jal_Op 6'b000011   

//----jumpreg----//
`define jr_Funct  6'b001000

module Main_CU(
    input [5:0] Op,
    input [5:0] Funct,

    //----使能信号----//
    output reg MemWrite,
    output reg RegWrite,

    //-----操作选择信号----//
    output reg [3:0] ALUOp,
    output reg [1:0] EXTOp,
    output reg [2:0] NPCOp,
	 output reg [2:0] BranchOp,	//use for cmp

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
                MemWrite<=0;
                RegWrite<=1;
                //
                ALUOp<=3'b000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=2'b00;
            end

            `sub_Funct:begin
                //
                MemWrite<=0;
                RegWrite<=1;
                //
                ALUOp<=3'b001;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=2'b00;
            end

            `jr_Funct:begin
                //
                MemWrite<=0;
                RegWrite<=0;
                //
                ALUOp<=3'b000;
                EXTOp<=2'b00;
                NPCOp<=3'b011;
					 BranchOp<=3'b000;
                //
                ALUSrc_Sel<=0;
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=2'b00;
            end
				default:begin
                MemWrite<=0;
                RegWrite<=0;
                //
                ALUOp<=3'b000;
                EXTOp<=2'b00;
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
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
                MemWrite<=0;
                RegWrite<=1;
                //
                ALUOp<=3'b010;
                EXTOp<=2'b00;       //零拓展
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
                //
                ALUSrc_Sel<=1;      //选择拓展后的立即数
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=2'b00;

            end

            `lui_Op: begin
                //
                MemWrite<=0;
                RegWrite<=1;
                //
                ALUOp<=3'b000;
                EXTOp<=2'b10;       //lui
                NPCOp<=3'b000;
					 BranchOp<=3'b000;
                //
                ALUSrc_Sel<=1;      //选择拓展后的立即数
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=2'b00;
            end

            `beq_Op: begin             //流水线中b_type指令与ALU，在CMP中进行比较
                //
                MemWrite<=0;
                RegWrite<=0;
                //
                ALUOp<=3'b000;      //无关
                EXTOp<=2'b01;       //符号拓展
                NPCOp<=3'b001;      //选择branch
					 BranchOp<=3'b001;
                //
                ALUSrc_Sel<=0;    
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=2'b00;
            end
				
            `lw_Op: begin
                //
                MemWrite<=0;
                RegWrite<=1;
                //
                ALUOp<=3'b000;      //加法
                EXTOp<=2'b01;       //符号拓展
                NPCOp<=3'b000;      
					 BranchOp<=3'b000;
                //
                ALUSrc_Sel<=1;      //选择立即数
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=2'b10;
            end

            `sw_Op: begin
                //
                MemWrite<=1;
                RegWrite<=0;
                //
                ALUOp<=3'b000;      //加法
                EXTOp<=2'b01;       //符号拓展
                NPCOp<=3'b000;   
					 BranchOp<=3'b000;					 
                //
                ALUSrc_Sel<=1;      //选择立即数
					 Elevel_Sel<=2'b00;
                Mlevel_Sel<=2'b00;
                Wlevel_Sel<=2'b00;
            end

            `jal_Op: begin
                //
                MemWrite<=0;
                RegWrite<=1;
                //
                ALUOp<=3'b000;      
                EXTOp<=2'b00;       
                NPCOp<=3'b010;   
					 BranchOp<=3'b000;					 
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

