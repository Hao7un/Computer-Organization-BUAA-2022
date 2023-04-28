//----md----//
`define HILO_mult 4'd1
`define HILO_multu 4'd2
`define HILO_div 4'd3
`define HILO_divu 4'd4
//----mf----//
`define HILO_mfhi 4'd5
`define HILO_mflo 4'd6
//----mt----//
`define HILO_mthi 4'd7
`define HILO_mtlo 4'd8

module E_HILO(
    input clk,
    input reset,
    input [31:0] D1,
    input [31:0] D2,
    input [3:0] HILO_Op,    //选择不同的乘除法操作

    output [31:0] HILO_Result,
    output HILO_busy    //输出到StallUnit中
);
    reg [31:0] HI,LO;   //两个乘除法寄存器
    reg busy;
    reg [3:0] cycle;
	 
    assign HILO_busy=busy;
	 assign HILO_Result=(HILO_Op==`HILO_mfhi)?HI:
							  (HILO_Op==`HILO_mflo)?LO:32'h0;
	 
    reg [63:0] temp; 

    initial begin
        HI<=32'h0;
        LO<=32'h0;
        busy<=1'h0;
        cycle<=4'h0;
		  temp<=64'h0;
    end

  always @(posedge clk) begin
    if(reset) begin
        HI<=32'h0;
        LO<=32'h0;
        busy<=1'h0;
        cycle<=4'h0;
    end

    else begin
        if(busy==1'd0)begin    //not in the calculation
            case(HILO_Op)
                `HILO_mult:begin
                    cycle<=4'd5;
                    busy<=1'd1;
                    temp<=$signed(D1)*$signed(D2);
                end

                `HILO_multu:begin
                    cycle<=4'd5;
                    busy<=1'd1;
                    temp<=D1*D2;
                end

                `HILO_div:begin
                    cycle<=4'd10;
                    busy<=1'd1;
                    temp<={$signed(D1)%$signed(D2),$signed(D1)/$signed(D2)};
                end

                `HILO_divu:begin
                    cycle<=4'd10;
                    busy<=1'd1;
                    temp<={D1%D2,D1/D2};
                end

                `HILO_mthi:begin
                    cycle<=4'd0;
                    busy<=1'd0;
                    HI<=D1;
                end

                `HILO_mtlo:begin
                    cycle<=4'd0;
                    busy<=1'd0;
                    LO<=D1;
                end
            endcase
        end

        else if(busy==1'd1)begin //calculating
            if(cycle==4'd1)begin
                busy<=1'd0;
					 cycle<=4'd0;
                {HI,LO}<=temp;
            end
            else begin
                cycle<=cycle-1;
            end
        end
    end
  end

endmodule