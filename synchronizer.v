`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 12:00:46 PM
// Design Name: 
// Module Name: synchronizer
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


module synchronizer (input clk, reset, in, output reg out);
reg r1;
always@(posedge clk, posedge reset) begin
     if(reset == 1'b1) begin
         r1 <= 0;
         out <= 0;
     end
     else begin
         r1 <= in;
         out <= r1;
     end
end
endmodule
