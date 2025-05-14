`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 07:50:14 PM
// Design Name: 
// Module Name: subbyte_tb
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


module subbyte_tb();
reg [127:0] in;
wire [127:0]out;

subbyte sb(in,out);

initial begin
$monitor("input= %h ,output= %h",in,out);
in=128'h193de3bea0f4e22b9ac68d2ae9f84808;
#10;
in=128'ha49c7ff2689f352b6b5bea43026a5049;
#10;
in=128'haa8f5f0361dde3ef82d24ad26832469a;
#10;
$finish;
end
endmodule
