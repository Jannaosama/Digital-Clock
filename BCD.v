`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 12:55:40 PM
// Design Name: 
// Module Name: BCD
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module bcd(input clk1, input en,input [1:0]sel, input [3:0] minutes_units, [2:0] minutes_tens,[3:0] hours_units,[2:0] hours_tens,
output reg [6:0]segments, output reg [3:0]anode , output reg dp);
reg [3:0] num;
always @ (sel) begin
    case (sel)
    0:begin
        anode =4'b1110;
        num = minutes_units;
        dp =1;
     end
    1:begin
        anode =4'b1101;
        num = minutes_tens;
        dp = 1;
    end
    2:begin
        anode =4'b1011;
        num = hours_units;
        dp = en ? clk1: 1;
    end
    3:begin
        dp = 1;
        anode =4'b0111;
        num = hours_tens;
    end
    endcase
end
always@(num)begin
    case (num)
    0:segments =7'b0000001;
    1:segments =7'b1001111;
    2:segments =7'b0010010;
    3:segments =7'b0000110;
    4:segments =7'b1001100;
    5:segments =7'b0100100;
    6:segments =7'b0100000;
    7:segments =7'b0001111;
    8:segments =7'b0000000;
    9:segments =7'b0000100;
    
    endcase
end
endmodule
