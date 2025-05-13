`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2023 13:55:46
// Design Name: 
// Module Name: top
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


module top
(input clk_out, timer_30s, timer_3s, button, reset, 
output reg [2:0] traff_state, 
output reg [1:0] pedes_state);



wire [2:0] traff_light;
wire [1:0] pedes_light;

counter_30s counter30s(
.clk_out(clk_out),
.reset(reset),
.timer_30s(timer_30s)
);

counter_3s counter3s(
.clk_out(clk_out),
.reset(reset),
.timer_3s(timer_3s)
);

clockdivider divider(
 .clk_in(clk_in),
 .clk_out(clk_out)
);

traffic_light mytraffic(
.timer_30s(timer_30s),
.timer_3s(timer_3s),

.reset(reset),
.button(button),
.traff_light(traff_light)
);

pedestrian_light mypedes(
.timer_30s(timer_30s),
.timer_3s(timer_3s),

.button(button),
.reset(reset),
.pedes_light(pedes_light)
);



 always @(posedge clk_out or button or posedge reset) 
 begin
    if (reset) 
    begin
      pedes_state <= 2'b01; 
      traff_state <= 3'b001;// reset state goes to red in traffic light and red in pedestrian light
    end 
    else if (button == 0) begin // Traffic light state
          pedes_state<=pedes_light;
          traff_state<=traff_light;
          end // Switch to pedestrian state if button is pressed
     else begin// Pedestrian state
          pedes_state <= pedes_light; 
          traff_state <= traff_light;
          end
    end

endmodule


