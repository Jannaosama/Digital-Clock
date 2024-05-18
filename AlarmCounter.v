`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2024 01:46:54 AM
// Design Name: 
// Module Name: AlarmCounter
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


module AlarmCounter(
    input clk,
    input reset,
    input updown,
    input en_hours,
    input en_mins,
    output [3:0] minutes_units, 
    output [2:0] minutes_tens,
    output [3:0] hours_units,
    output [2:0] hours_tens

);

reg [3:0] enable;
wire [5:0] counter_sec; 
wire [5:0] counter_min; 
wire [4:0] counter_hour; 



counter_bits #(6,60) Minutes (clk, reset,en_mins ,updown, counter_min);
counter_bits #(5,24) Hours (clk, reset, en_hours,updown, counter_hour);

assign hours_tens = counter_hour / 10;
assign hours_units = counter_hour % 10;
assign minutes_tens = counter_min / 10;
assign minutes_units = counter_min % 10;

endmodule
