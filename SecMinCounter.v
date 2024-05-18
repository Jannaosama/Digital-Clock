`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 11:51:18 AM
// Design Name: 
// Module Name: SecMinCounter
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


module SecMinHourCounter( input clk,
    input reset,
    input en_clk,
    input updown,
    input en_hours,
    input en_mins,
    output [3:0] minutes_units, 
    output [2:0] minutes_tens,
    output [3:0] hours_units,
    output [2:0] hours_tens,
    output [5:0] counter_sec 

);

reg [3:0] enable;
wire [5:0] counter_min; 
wire [4:0] counter_hour; 
wire enable_minute_clock;
wire enable_hour_clock;

assign enable_minute_clock = en_clk ? (counter_sec == 59 & en_clk) : en_mins;
assign enable_hour_clock =en_clk ? (enable_minute_clock & counter_min == 59) : en_hours;

counter_bits #(6,60) Seconds (clk, reset, en_clk,updown, counter_sec); //Seconds Counter
counter_bits #(6,60) Minutes (clk, reset,enable_minute_clock ,updown, counter_min); //Minutes Counter
counter_bits #(5,24) Hours (clk, reset, enable_hour_clock,updown, counter_hour); ////Hours Counter

assign hours_tens = counter_hour / 10;
assign hours_units = counter_hour % 10;
assign minutes_tens = counter_min / 10;
assign minutes_units = counter_min % 10;

endmodule 

