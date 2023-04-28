module F_IFU(
    input clk,
    input reset,
    input en,      //IFU的使能端，用于阻塞
    input [31:0] NPC,
	 output [31:0] PC,
    output [31:0] Instr
    );

    reg [31 : 0] InstrMemory [4095 : 0];
    reg [31 : 0] PC_Reg;

    assign Instr= InstrMemory[(PC-32'h0000_3000)>>2];
    assign PC=PC_Reg;

	 integer i;
    initial begin
      PC_Reg=32'h3000;
		for(i=0;i<4096;i=i+1)		//initialize the Memory
			InstrMemory[i] = 32'h0;
		$readmemh("code.txt",InstrMemory);
    end
   
  always @(posedge clk) begin
    if(reset)begin
        PC_Reg<=32'h3000;        
    end

    else if (en) begin
        PC_Reg<=NPC;
    end
	 
    else begin      //阻塞的时候停止
        PC_Reg<=PC_Reg;
    end
  end

endmodule