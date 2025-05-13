`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2023 01:30:49
// Design Name: 
// Module Name: tb_top
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


module tb_top();


reg timer_30s, timer_3s, clk_out, reset, button;
wire [2:0] traff_state; 
wire [1:0] pedes_state;



top topmodule(
.clk_out(clk_out),
.timer_30s(timer_30s),
.timer_3s(timer_3s),
.button(button), 
.reset(reset),
.traff_state(traff_state), 
.pedes_state(pedes_state)
);



always #1 clk_out = ~clk_out;
always #45 timer_3s = !timer_3s;
always #450 timer_30s = !timer_30s;
initial begin
timer_30s = 0;
timer_3s = 0;
clk_out = 0;

 reset = 0; button = 0;
#10 reset = 0; button = 0;
#10 reset = 0; button = 0;
#10 reset = 0; button = 0;
#100
#10
#1 reset = 0; button = 0;
#1 reset = 0; button = 1;
#10 reset = 0; button = 0;
$finish;
end
endmodule
