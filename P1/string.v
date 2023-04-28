module string(
    input clk,
    input clr,
    input [7:0] in,
    output out
    );

    parameter S0=2'b00,S1=2'b01,S2=2'b10,S3=2'b11;
    reg [1:0] state;

  always @(posedge clk or posedge clr) begin
    if(clr)begin
      state<=S0;
    end
    else begin
      case(state)
        S0: state<=(in>="0" && in<="9")?S1:S3;

        S1:state<=(in=="+" || in=="*")?S2:S3;

        S2:state<= (in>="0"&&in<="9") ?S1:S3;

        S3:state<=S3;
      
      endcase 
    end
  end

  assign out=(state==S1)?1:0;
endmodule