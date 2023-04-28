`define DEBUG_DEV_DATA 32'h0;

module Bridge(
	 //connected to CPU
    input [31:0] cpu_m_data_addr,
    input [31:0] cpu_m_data_wdata,
    input [3:0] cpu_m_data_byteen,
    output [31:0] cpu_m_data_rdata,

	  //connected to HardWare
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    input [31:0] m_data_rdata,
	 
    output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信号
	 
    //写入DEV的地址与数据
    output [31:0] DEV_Addr,
    output [31:0] DEV_WD,
    
    //从DEV中读出的数据
    input [31:0] DEV0_RD,
    input [31:0] DEV1_RD,

    //写使能信号
    input WeCPU,
    output  WeDEV0,
    output  WeDEV1
);

//DEV0:0x0000_7F00∼0x0000_7F0B
//DEV1:0x0000_7F10∼0x0000_7F1B


assign HitDEV0=(cpu_m_data_addr>=32'h00007F00)&&(cpu_m_data_addr<=32'h00007F0B);     //Decode
assign HitDEV1=(cpu_m_data_addr>=32'h00007F10)&&(cpu_m_data_addr<=32'h00007F1B);
assign HitInt     = (cpu_m_data_addr>=32'h00007F20)&&(cpu_m_data_addr<=32'h00007F23);
assign cpu_m_data_rdata= (HitDEV0)?DEV0_RD:
																					(HitDEV1)?DEV1_RD:
																					(HitInt)     ? 32'd0:    m_data_rdata;
																					
 assign m_data_addr       =  cpu_m_data_addr;
 assign m_data_wdata    =  cpu_m_data_wdata;
 assign m_data_byteen  =  (HitDEV0|HitDEV1|HitInt)?   4'd0  :
																				cpu_m_data_byteen;
																				
assign m_int_addr      =   cpu_m_data_addr;
assign m_int_byteen =  HitInt?  4'd1:    4'd0;

//Write Data to DEV
assign WeDEV0=WeCPU&HitDEV0;
assign WeDEV1=WeCPU&HitDEV1;

assign DEV_Addr=cpu_m_data_addr;
assign DEV_WD=cpu_m_data_wdata;

endmodule