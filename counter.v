`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 11:44:33 AM
// Design Name: 
// Module Name: counter
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

module counter_bits #(x = 3, n = 8)

(input clk, reset, enable,updown, output reg [x-1:0] count); 

always @(posedge clk, posedge reset)
 begin
     if (reset == 1)
        count <= 0; 
     else 
     begin
     if (enable)begin
         if(updown)begin
         
             if (count<n-1)
             begin
                count <= count + 1; 
                end
             else
             begin
                count<=0;
             end
          end
            
           else begin
             if (count<n-1)
                    begin
                    count <= count -1; 
                    end
             else begin
                    count<=0;
                    
             end
           end
      end          
      else
         count <= count;
 
    end 
end

endmodule

