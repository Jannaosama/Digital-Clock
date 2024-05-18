`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 11:57:55 AM
// Design Name: 
// Module Name: RisingEdgeDetector
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


module rising_edge (input clk, rst, w, output z);

reg [1:0] state, nextState;
parameter [1:0] A=2'b00, B=2'b01, C=2'b10;

always @(*) begin

case (state)

A: if (w==0) nextState = A;
 else nextState = B;
B: if (w==0) nextState = A;
 else nextState = C;
C: if (w==0) nextState = A;
 else nextState = C;
 
default: nextState = A;
endcase
end

always @ (posedge clk or posedge rst) begin
if(rst) state <= A;
else state <= nextState;
end
// output generation (combinational logic)
assign z = (state == B);
endmodule
