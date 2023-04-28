`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:17 10/05/2022 
// Design Name: 
// Module Name:    BlockChecker 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module BlockChecker(
    input clk,
    input reset,
    input [7:0] in,
    output result
    );
   reg signed [31:0] cnt=0;
    reg result;
    reg [3:0] state;
    reg flow=0;
    parameter S0=4'b0,S1=4'b1,S2=4'b10,S3=4'b11,S4=4'b100,S5=4'b101,S6=4'b110,S7=4'b111,S8=4'b1000,S9=4'b1001;

    always@(posedge clk or posedge reset)begin
      if(reset)
      begin
        state<=S0;
        cnt<=0;
        flow<=0;
      end
      else begin
        case(state)
          S0:begin
            if(in==" ")begin
              state<=S0;
            end
            else if(in=="b"||in=="B")begin
              state<=S1;
            end
            else if(in=="e"||in=="E")begin
              state<=S6;
            end
            else begin
              state<=S9;
            end

          end

          S1:begin
            if(in==" ")begin
              state<=S0;
            end
            else if(in=="e"||in=="E")begin
              state<=S2;
            end
            else begin
              state<=S9;
            end
          end

          S2:begin
            if(in==" ")begin
              state<=S0;
            end
            else if(in=="g"||in=="G")begin
              state<=S3;
            end
            else begin
              state<=S9;
            end
          end

          S3:begin
            if(in==" ")begin
              state<=S0;
            end
            else if(in=="i"||in=="I")begin
              state<=S4;
            end
            else begin
              state<=S9;
            end
          end

          S4:begin
            if(in==" ")begin
              state<=S0;
            end
            else if(in=="n"||in=="N")begin
              cnt=cnt+32'b1;
              state<=S5;
            end
            else begin
              state<=S9;
            end
          end

          S5:begin
            if(in==" ")begin
              state<=S0;
            end
            else begin
              cnt=cnt+32'b11111111111111111111111111111111;
              state<=S9;
            end
          end

          S6:begin
            if(in==" ")begin
              state<=S0;
            end
            else if(in=="n"||in=="N")begin
              state<=S7;
            end
            else begin
              state<=S9;
            end
          end

          S7:begin
            if(in==" ")begin
              state<=S0;
            end
            else if(in=="d"||in=="D")begin
              state<=S8;
              cnt=cnt+32'b11111111111111111111111111111111;
            end
            else begin
              state<=S9;
            end
          end

          S8:begin
            if(in==" ")begin
              if(cnt<0) flow=1;
              state<=S0;
            end
            else begin
              cnt=cnt+32'b1;
              state<=S9;
            end
          end

          S9:begin
            if(in==" ")begin
              state<=S0;
            end
            else begin
              state<=S9;
            end
          end

        endcase
      end
    end

    always@(*) begin
        if(flow)
          result<=0;
        else if(cnt==0)
          result<=1;
        else
          result<=0;
    end

endmodule
