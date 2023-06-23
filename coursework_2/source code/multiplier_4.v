`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2023 22:44:31
// Design Name: 
// Module Name: multiplier_4
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


module multiplier_4(
 input [7:0] vector7,
  input [7:0] vector8,
  output [15:0] result4
);
reg [7:0] tmp_a;
reg [7:0] tmp_b;
reg [15:0] tmp_result;

always @ (vector7 or vector8) begin
  tmp_a = vector7;
  tmp_b = vector8;
  tmp_result = tmp_a * tmp_b;
end

assign result4 = tmp_result;
endmodule