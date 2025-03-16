`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2023 23:26:00
// Design Name: 
// Module Name: adder17_2
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


module adder17_2(
input [15:0] C1, 
input [15:0] D1,  
output [16:0] sum2
);

    assign sum2 = C1 + D1;
    
endmodule