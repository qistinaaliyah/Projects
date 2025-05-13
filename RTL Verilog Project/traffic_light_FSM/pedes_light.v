`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2023 23:55:57
// Design Name: 
// Module Name: pedes_light
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


module pedestrian_light(
input timer_30s, timer_3s, reset, button, 
output reg [1:0] pedes_light
);
 
 parameter red=0, idle=1, green=2;
 reg [1:0] state = red;
 counter_30s my_timer_30 (timer_30s);
 counter_3s my_timer_3 (timer_3s);
 
always @ (posedge timer_30s or posedge timer_3s or posedge reset or button) 
if (reset==1'b1) state<=red;
else 
    case (state)
    red: if (button == 1) state <= idle;
    idle: if (timer_3s) state <= green;
    green: if (button == 0 && timer_30s) state <= red;
    //else if (timer_30s) state <= red;
    default:;
    endcase

always@(*)
  case(state)
  red: pedes_light <= 2'b01;
  green: pedes_light <= 2'b11;

  endcase
endmodule