`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 11:59:36 AM
// Design Name: 
// Module Name: PushButtonDetector
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


module PushButtonDetector (input clk, x , reset , output  z ); 


wire outDebouncer;
wire outSynchronizer;
//wire outRisisngEdge;


debouncer Ddebouncer( clk, reset, x,  outDebouncer);
synchronizer Ssynchronizer( clk, reset, outDebouncer, outSynchronizer);
rising_edge RrisingEdge( clk, reset,outSynchronizer,  z);

//assign z = outRisisngEdge;
endmodule

