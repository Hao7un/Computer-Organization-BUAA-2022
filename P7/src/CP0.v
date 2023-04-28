//SR
`define CU0 SR[28]
`define IM SR[15:10]                //分别对应六个外部中断
`define EXL SR[1]                   //任何异常发生时置位
`define IE    SR[0]                    //全局中断使能，该位置 1 表示允许中断，置 0 表示禁止中断。

//Cause
`define BD Cause[31]                //当该位置 1 的时候，EPC 指向当前指令的前一条指令（一定为跳转），否则指向当前指令。
`define hwint_pend Cause[15:10]     
//为 6 位待决的中断位，分别对应 6 个外部中断，相应位置 1 表示有中断，置 0 表示无中断，将会每个周期被修改一次，修改的内容来自计时器和外部中断。
`define ExcCode Cause[6:2]          //异常编码，记录当前发生的是什么异常。

//寄存器编号
`define sr 12
`define cause 13
`define epc 14

module CP0(
    input clk,  
    input reset,
    input [4:0] A1,        //读CP0寄存器编号
    input [4:0] A2,        //写CP0寄存器编号
    input [31:0] CP0In,    //CP0寄存器的写入数据
    input [31:0] PC,       //中断/异常时的PC
    input BDIn,
    input [4:0] ExcCode,   //中断/异常类型
    input [5:0] HWInt,     //6个设备中断
    input We,              //CP0寄存器写使能
    input EXLClr,          //用于清除SR的EXL   （EXL为0）

    output Req,      //中断异常请求，输出至CPU控制器
    output [31:0] EPCOut,  //EPC寄存器输出到NPC
    output [31:0] CP0Out,  //CP0寄存器的输出数据
	 output cu0,
	 output exl
);
    reg [31:0] SR;
    reg [31:0] Cause;
    reg [31:0] EPC;
	 
    wire IntReq = (|(HWInt & `IM)) & !`EXL & `IE;
    wire ExcReq = (|ExcCode) & !`EXL; 
	 
    assign Req  = IntReq | ExcReq;
    assign EPCOut = EPC;
	 assign cu0 = SR[28];
	 assign exl = `EXL;

 //读CP0
    assign CP0Out = (A1==`sr) ?            {3'b0,`CU0,12'b0, `IM, 8'b0, `EXL, `IE} :
													  (A1==`cause) ?   {`BD, 15'b0, `hwint_pend, 3'b0, `ExcCode, 2'b0} :
													  (A1==`epc) ?        EPC :   0;
										  
    initial begin
        SR<=32'h1000_0000;
        Cause<=32'h0;
        EPC<=32'h0;
    end

  always @(posedge clk) begin
 
        if(reset)begin
            SR<=32'h1000_0000;
            Cause<=32'h0;
            EPC<=32'h0;        
        end
		  
        else begin
            `hwint_pend<=HWInt; //更新中断
				
            if(EXLClr)begin
                `EXL<=1'b0;
            end
				
            if(Req)  begin   //进入异常
                `ExcCode <=  IntReq ? 5'd0 : ExcCode;
                `EXL            <=   1'b1;
                `BD             <=    BDIn;  
                 EPC             <=   (BDIn)? PC-4 : PC;
            end
				
            else if(We)begin
                case(A2)
                    `sr:begin
                        SR  <=  CP0In;
                    end
                    `epc:begin
                        EPC  <=CP0In;
                    end
                endcase
            end
        end
  end
endmodule