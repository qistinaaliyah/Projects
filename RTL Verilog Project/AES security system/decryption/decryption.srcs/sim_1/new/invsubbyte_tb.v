`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2025 02:05:31 PM
// Design Name: 
// Module Name: invsubbyte_tb
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


module invsubbyte_tb();
reg [127:0] in;
wire [127:0]out;

invsubbyte isb(in,out);

initial begin
$monitor("input= %h ,output= %h",in,out);
in=128'hd42711aee0bf98f1b8b45de51e415230;
#10;

$finish;
end

endmodule