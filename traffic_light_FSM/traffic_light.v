`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2023 23:17:19
// Design Name: 
// Module Name: traffic_light
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


module traffic_light(
input timer_30s, timer_3s, reset, button,
output reg [2:0] traff_light
);
 
 parameter red=0, red_amber=1, green=2, amber=3;
 reg [2:0] state = 3'b001;
 counter_30s my_timer_30 (timer_30s);
 counter_3s my_timer_3 (timer_3s);
 
always @ (posedge timer_30s or posedge timer_3s or reset or button) 
if (reset==1'b1) state<=red;
else 
    case (state)
    red: if (timer_30s) state <=red_amber;
    else if (button==1) 
         state <=amber;
    red_amber: if (timer_3s) state <=green;
    else if (button==1) 
        state <=amber;
    green: if (timer_30s) state <=amber;
    else if (button==1) 
        state <=amber;
    amber: if (timer_3s) state<= red;
    else if (button==1) 
        state <=amber;
    
    default:;
    endcase

always@(*)
  case(state)
  red: traff_light <= 3'b001;
  red_amber: traff_light <= 3'b101;
  green: traff_light <= 3'b011;
  amber: traff_light <= 3'b100;
  endcase
endmodule