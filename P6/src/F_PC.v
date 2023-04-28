module F_PC(
    input clk,
    input reset,
    input en,      //IFU的使能端，用于阻塞
    input [31:0] NPC,
	 output [31:0] PC
    );

    reg [31 : 0] PC_Reg;

    assign PC=PC_Reg;

    initial begin
      PC_Reg=32'h3000;
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