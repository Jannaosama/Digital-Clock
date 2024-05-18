`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 11:47:28 AM
// Design Name: 
// Module Name: clockdivider
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


module clockDivider #( n = 250000)
    (input clk, rst, output reg clkout);
    
parameter WIDTH = $clog2(n);
reg [WIDTH-1:0] count;

always @ (posedge clk, posedge rst) begin
    if (rst == 1'b1) 
    count <= 32'b0;
    else if (count == n-1)
     count <= 32'b0;
    else
     count <= count + 1;
    end

always @ (posedge clk, posedge rst) 
begin
    if (rst) 
     clkout <= 0;
        else if (count == n-1)
         clkout <= ~ clkout;
    end
    endmodule
