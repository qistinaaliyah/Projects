`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2023 21:38:46
// Design Name: 
// Module Name: clockdivider
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


module clockdivider(
input clk_in,
output clk_out
);
    
   reg [31:0] count = 0;
  
   always @ (posedge clk_in)
   begin
   count = count+1;
   end
   assign clk_out = count[23];
   
endmodule