`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2023 22:34:31
// Design Name: 
// Module Name: multiplier1
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


module multiplier1(
  input [7:0] vector1,
  input [7:0] vector2,
  output  [15:0] result1
);

reg [7:0] tmp_a;
reg [7:0] tmp_b;
reg [15:0] tmp_result;

always @ (vector1 or vector2) begin
  tmp_a = vector1;
  tmp_b = vector2;
  tmp_result = tmp_a * tmp_b;
end

assign result1 = tmp_result;

endmodule