`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2023 01:14:32
// Design Name: 
// Module Name: splitter
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


module splitter(
input [31:0] data_in,
output [7:0] d0,
output [7:0] d1,
output [7:0] d2,
output [7:0] d3
    );
    
    assign d0 = data_in[7:0];
    assign d1 = data_in[15:8];
    assign d2 = data_in[23:16];
    assign d3 = data_in[31:24];
endmodule
