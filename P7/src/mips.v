`timescale 1ns / 1ps

 module mips(
    input clk,                    // 时钟信号					
    input reset,                  // 同步复位信号				
    input interrupt,              // 外部中断信号				
    output [31:0] macroscopic_pc, // 宏观 PC						

    output [31:0] i_inst_addr,    // IM 读取地址  （取指 PC）	
    input  [31:0] i_inst_rdata,   // IM 读取数据				

    output [31:0] m_data_addr,    // DM 读写地址				
    input  [31:0] m_data_rdata,   // DM 读取数据				
    output [31:0] m_data_wdata,   // DM 待写入数据				
    output [3 :0] m_data_byteen,  // DM 字节使能信号		

    output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信号

    output [31:0] m_inst_addr,    // M 级 PC						

    output w_grf_we,              // GRF 写使能信号			
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号	
    output [31:0] w_grf_wdata,    // GRF 待写入数据			
	
    output [31:0] w_inst_addr     // W 级 PC				
);

   wire [31:0] DEV0_RD,DEV1_RD;
	wire IRQ0,IRQ1;
	wire [5:0] HWInt=   {3'd0,interrupt,IRQ1,IRQ0};
	wire [31:0] DEV_Addr,DEV_WD;
	wire [31:0] PrRD;

    wire [31:0] cpu_m_data_wdata, cpu_m_data_addr;
    wire [3:0] cpu_m_data_byteen;
    wire [31:0] cpu_m_data_rdata;
	
CPU cpu (
    .clk(clk), 
    .reset(reset), 
	 .HWInt(HWInt),
	 
    .i_inst_addr(i_inst_addr), 
    .i_inst_rdata(i_inst_rdata), 
	 
    .m_data_addr(cpu_m_data_addr), 
	 .m_data_rdata(cpu_m_data_rdata), 
    .m_data_wdata(cpu_m_data_wdata), 
    .m_data_byteen(cpu_m_data_byteen), 
    .m_inst_addr(m_inst_addr), 
	 
    .w_grf_we(w_grf_we), 
    .w_grf_addr(w_grf_addr), 
    .w_grf_wdata(w_grf_wdata), 
    .w_inst_addr(w_inst_addr),
	 
	 .macroscopic_pc(macroscopic_pc)
    );
	 
Bridge bridge (
       .m_data_addr(m_data_addr),
       .m_data_wdata(m_data_wdata),
       .m_data_byteen(m_data_byteen),
       .m_data_rdata(m_data_rdata),

       .cpu_m_data_addr(cpu_m_data_addr),
       .cpu_m_data_wdata(cpu_m_data_wdata),
       .cpu_m_data_byteen(cpu_m_data_byteen),
       .cpu_m_data_rdata(cpu_m_data_rdata),
		 
       .m_int_addr(m_int_addr),     // 中断发生器待写入地址
       .m_int_byteen(m_int_byteen),   // 中断发生器字节使能信号

     .DEV_Addr(DEV_Addr), 
     .DEV_WD(DEV_WD), 
    .DEV0_RD(DEV0_RD), 
    .DEV1_RD(DEV1_RD), 
	 
    .WeCPU(|cpu_m_data_byteen), 
    .WeDEV0(WeDEV0), 
    .WeDEV1(WeDEV1)
    );

TC  dev0 (
    .clk(clk), 
    .reset(reset), 
    .Addr(DEV_Addr[31:2]), 
    .WE(WeDEV0), 
    .Din(DEV_WD), 
    .Dout(DEV0_RD), 
    .IRQ(IRQ0)
    );

TC dev1 (
    .clk(clk), 
    .reset(reset), 
    .Addr(DEV_Addr[31:2]), 
    .WE(WeDEV1), 
    .Din(DEV_WD), 
    .Dout(DEV1_RD), 
    .IRQ(IRQ1)
    );

endmodule
