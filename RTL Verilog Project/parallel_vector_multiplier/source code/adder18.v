`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2023 00:49:22
// Design Name: 
// Module Name: adder18
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


module adder18(
input [16:0] A, 
input [16:0] B,  
output [17:0] sum
    
    );

    assign sum = A + B;
    
endmodule