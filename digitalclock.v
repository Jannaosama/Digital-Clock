`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 11:49:56 AM
// Design Name: 
// Module Name: digitalclock
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


module DigitalClock( input clk , reset , input [4:0] bottons, output  [6:0] segments , output [3:0] anode, output reg led0, led12,led13, led14, led15,output dp, output  sound);
wire clkout200,  clk1hz;

wire  [3:0] minutes_units;
wire [2:0] minutes_tens;
wire [3:0] hours_units;
wire  [2:0] hours_tens;
wire  [3:0] alarm_minutes_units; //Register for the minutes units alarm
wire [2:0] alarm_minutes_tens;//Register for the minutes tens alarm
wire [3:0] alarm_hours_units; //Register for the hours units alarm
wire  [2:0] alarm_hours_tens; //Register for the hours tens alarm

wire [1:0] sel; 
clockDivider #(50000000)clockkdiv (clk, reset,  clk1hz);
clockDivider #(250000) clockkdiv200hz (clk, reset,  clkout200);

wire [4:0] button_out;
genvar i;
generate 
for(i=0; i<5; i=i+1)
begin
PushButtonDetector DUT (clkout200,bottons[i]  , reset ,button_out[i]);
end

endgenerate
reg clk_input;
reg en_clock;
reg updown;
reg enable_adjust_min;
reg enable_adjust_hours;
reg enable_alarm_min;
reg enable_alarm_hours;
wire [5:0] secs;

counter_bits #(2,4) AnodeSel (clkout200, reset, 1'b1, 1'b1,sel);
//The Counter used to detect the 
AlarmCounter secminalarm(clkout200,reset,updown,enable_alarm_min,enable_alarm_hours,alarm_minutes_units,  alarm_minutes_tens,alarm_hours_units,alarm_hours_tens);

SecMinHourCounter secmin( clk_input ,reset,en_clock,updown,enable_adjust_min,enable_adjust_hours,minutes_units, minutes_tens,hours_units,hours_tens, secs);

reg selBCD;
wire  [3:0] out_minutes_units;
wire [2:0] out_minutes_tens;
wire [3:0] out_hours_units;
wire  [2:0] out_hours_tens;
assign out_minutes_units = selBCD ? minutes_units : alarm_minutes_units;
assign out_minutes_tens = selBCD ? minutes_tens : alarm_minutes_tens;
assign out_hours_units = selBCD ? hours_units : alarm_hours_units;
assign out_hours_tens = selBCD ? hours_tens : alarm_hours_tens;

wire alarm_flag;

assign alarm_flag = (minutes_units == alarm_minutes_units) &(minutes_tens == alarm_minutes_tens) &(hours_units == alarm_hours_units) &(hours_tens == alarm_hours_tens) &(secs == 5'd0);

bcd bcds(clk1hz, en_clock,sel, out_minutes_units, out_minutes_tens,out_hours_units,out_hours_tens, segments, anode,dp);


reg [3:0] state, next;

parameter [3:0] Adjust_hour=4'b0000,U_Adjust_hour=4'b0001,D_Adjust_hour=4'b0010,Adjust_mins=4'b0011,U_Adjust_mins=4'b0100,D_Adjust_mins=4'b0110,Alarm_hour=4'b0101,U_Alarm_hour=4'b0111,D_Alarm_hour=4'b1001,Alarm_mins=4'b1011,U_Alarm_mins=4'b1010,D_Alarm_mins=4'b1100,Clock=4'b1101,Alarm = 4'b1111;
parameter [4:0]BTNU = 5'd1, BTND = 5'd2 , BTNR = 5'd4,BTNL = 5'd8,BTNC = 5'd16;

always @(state,button_out) 
begin 
case(state)
    Clock: 
    begin
       if(alarm_flag == 1) //Checking for the Alarm mode
        next = Alarm;
       else if(button_out == BTNC) //Checking for the Adjust mode
            next = Adjust_hour;
        else
             next = Clock; //Checking for the clockmode
    end
    Adjust_hour: //  Adjust Time Hour
        begin   
        if(button_out == BTNC)
            next = Clock;
        else if(button_out == BTNU ) //  Increment the hour
            next = U_Adjust_hour;
        else if (button_out == BTND)
            next = D_Adjust_hour; //  Increment the minutes
        else if (button_out == BTNL|| button_out == BTNR)
            next = Adjust_mins;
        else 
            next = Adjust_hour;
        end
    U_Adjust_hour:  
    begin
        next = Adjust_hour;
    end
    D_Adjust_hour:
    begin
        next = Adjust_hour;
    end
    Adjust_mins:
    begin
       if(button_out == BTNC)
            next = Clock;
        else if(button_out == BTNU )
            next=U_Adjust_mins;
        else if (button_out == BTND)
            next=D_Adjust_mins;
        else if (button_out == BTNL|| button_out == BTNR)
            next=Alarm_hour;
        else 
            next=Adjust_mins;
    end
    U_Adjust_mins:
    begin
        next = Adjust_mins;
    end
    D_Adjust_mins:
    begin
        next = Adjust_mins;
    end
    Alarm_hour:
    begin
      if(button_out == BTNC)
            next = Clock;
        else if(button_out == BTNU )
            next=U_Alarm_hour;
        else if (button_out == BTND)
            next=D_Alarm_hour;
        else if (button_out == BTNL|| button_out == BTNR)
            next=Alarm_mins;
        else 
            next=Alarm_hour;
    end
    U_Alarm_hour:
    begin
        next = Alarm_hour;
    end
   D_Alarm_hour:
    begin
        next = Alarm_hour;
    end
   Alarm_mins:
    begin
    if(button_out == BTNC)
            next = Clock;
        else if(button_out == BTNU )
            next=U_Alarm_mins;
        else if (button_out == BTND)
            next=D_Alarm_mins;
        else if (button_out == BTNL|| button_out == BTNR)
            next=Adjust_hour;
        else 
            next=Alarm_mins;
    end
    U_Alarm_mins:
    begin
        next = Alarm_mins;
    end
    D_Alarm_mins:
    begin
        next = Alarm_mins;
    end
   
    Alarm:begin
        if(button_out == BTNC | button_out == BTND | button_out == BTNL | button_out == BTNR | button_out == BTNU)
            next = Clock;
        else
            next = Alarm;
    end


endcase
end


always @(state) // next state (output) block
begin 
    case(state)
        Clock: begin//clock
            led0=0;
            led12=0;
            led13=0;
            led14=0;
            led15=0;
            clk_input = clk1hz;
            en_clock = 1'b1;
            updown = 1'b1;
            enable_adjust_min = 1'b0;
            enable_adjust_hours = 1'b0;
            enable_alarm_min= 1'b0;
            enable_alarm_hours= 1'b0;
            selBCD = 1'b1;
         end
        Adjust_hour:     
        begin
            led0=1;
            led12=1;
            led13=0;
            led14=0;
            led15=0;
            clk_input = clkout200;
            en_clock = 1'b0;
            updown = 1'b1;
            enable_adjust_min = 1'b0;
            enable_adjust_hours = 1'b0;
            enable_alarm_min= 1'b0;
            enable_alarm_hours= 1'b0;
            selBCD = 1'b1;


        end
        U_Adjust_hour:  
        begin
            led0=1;
            led12=1;
            led13=0;
            led14=0;
            led15=0;
            clk_input = clkout200;
            en_clock = 1'b0;
            updown = 1'b1;
            enable_adjust_min = 1'b0;
            enable_adjust_hours = 1'b1;
            enable_alarm_min= 1'b0;
            enable_alarm_hours= 1'b0;
            selBCD = 1'b1;
        end
        D_Adjust_hour:
        begin
            led0=1;
            led12=1;
            led13=0;
            led14=0;
            led15=0;
            clk_input = clkout200;
            en_clock = 1'b0;
            updown = 1'b0;
            enable_adjust_min = 1'b0;
            enable_adjust_hours = 1'b1;
            enable_alarm_min= 1'b0;
            enable_alarm_hours= 1'b0;
            selBCD = 1'b1;
        end
       Adjust_mins:
        begin
            led0=1;
            led12=0;
            led13=1;
            led14=0;
            led15=0;
            clk_input = clkout200;
            en_clock = 1'b0;
            updown = 1'b1;
            enable_adjust_min = 1'b0;
            enable_adjust_hours = 1'b0;
            enable_alarm_min= 1'b0;
            enable_alarm_hours= 1'b0;
            selBCD = 1'b1;
        end
        U_Adjust_mins:
        begin
            led0=1;
            led12=0;
            led13=1;
            led14=0;
            led15=0;
            clk_input = clkout200;
            en_clock = 1'b0;
            updown = 1'b1;
            enable_adjust_min = 1'b1;
            enable_adjust_hours = 1'b0;
            enable_alarm_min= 1'b0;
            enable_alarm_hours= 1'b0;
            selBCD = 1'b1;
        end
       D_Adjust_mins:
        begin
            led0=1;
            led12=0;
            led13=1;
            led14=0;
            led15=0;
            clk_input = clkout200;
            en_clock = 1'b0;
            updown = 1'b0;
            enable_adjust_min = 1'b1;
            enable_adjust_hours = 1'b0;
            enable_alarm_min= 1'b0;
            enable_alarm_hours= 1'b0;
            selBCD = 1'b1;
        end
        Alarm_hour:
        begin
            led0=1;
            led12=0;
            led13=0;
            led14=1;
            led15=0;
            clk_input = clk1hz;
            en_clock = 1'b0;
            updown = 1'b1;
            enable_adjust_min = 1'b0;
            enable_adjust_hours = 1'b0;
            enable_alarm_min= 1'b0;
            enable_alarm_hours= 1'b0;
            selBCD = 1'b0;
        end
        U_Alarm_hour:
        begin
            led0=1;
            led12=0;
            led13=0;
            led14=1;
            led15=0;
            clk_input = clkout200;
            en_clock = 1'b0;
            updown = 1'b1;
            enable_adjust_min = 1'b0;
            enable_adjust_hours = 1'b0;
            enable_alarm_min= 1'b0;
            enable_alarm_hours= 1'b1;
            selBCD = 1'b0;
        end
       D_Alarm_hour:
        begin
            led0=1;
            led12=0;
            led13=0;
            led14=1;
            led15=0;
            en_clock = 1'b0;
            updown = 1'b0;
            enable_adjust_min = 1'b0;
            enable_adjust_hours = 1'b0;
            enable_alarm_min= 1'b0;
            enable_alarm_hours= 1'b1;
            selBCD = 1'b0;
        end
       Alarm_mins:
        begin
            led0=1;
            led12=0;
            led13=0;
            led14=0;
            led15=1;
            clk_input = clkout200;
            en_clock = 1'b0;
            updown = 1'bX;
            enable_adjust_min = 1'b0;
            enable_adjust_hours = 1'b0;
            enable_alarm_min= 1'b0;
            enable_alarm_hours= 1'b0;
            selBCD = 1'b0;
        end
        U_Alarm_mins:
        begin
            led0=1;
            led12=0;
            led13=0;
            led14=0;
            led15=1;
            clk_input = clkout200;
            en_clock = 1'b0;
            updown = 1'b1;
            enable_adjust_min = 1'b0;
            enable_adjust_hours = 1'b0;
            enable_alarm_min= 1'b1;
            enable_alarm_hours= 1'b0;
            selBCD = 1'b0;
        end
        D_Alarm_mins:
            begin
                led0=1;
                led12=0;
                led13=0;
                led14=0;
                led15=1;
                clk_input = clkout200;
                en_clock = 1'b0;
                updown = 1'b0;
                enable_adjust_min = 1'b0;
                enable_adjust_hours = 1'b0;
                enable_alarm_min= 1'b1;
                enable_alarm_hours= 1'b0;
                selBCD = 1'b0;
            end
        Alarm:
            begin
                led0=clk1hz;
                led12=0;
                led13=0;
                led14=0;
                led15=1;
                clk_input = clk1hz;
                en_clock = 1'b1;
                updown = 1'b1;
                enable_adjust_min = 1'b0;
                enable_adjust_hours = 1'b0;
                enable_alarm_min= 1'b0;
                enable_alarm_hours= 1'b0;
                selBCD = 1'b1;
             end
        endcase
  end
   
always @( posedge clkout200, posedge reset)
begin
    if(reset) state <= Clock;
    
    else state <= next;

end

assign sound = (state == Alarm) ? led0:0;



// Instantiate 2-bit binary counter for seconds

endmodule
