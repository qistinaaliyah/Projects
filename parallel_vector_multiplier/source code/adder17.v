`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2023 23:24:09
// Design Name: 
// Module Name: adder17
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


module adder17_1(
input [15:0] A1, 
input [15:0] B1,  
output [16:0] sum1
);

    assign sum1 = A1 + B1;
    
endmodule