`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2023 22:37:45
// Design Name: 
// Module Name: multiplier_2
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


module multiplier_2(
  input [7:0] vector3,
  input [7:0] vector4,
  output [15:0] result2
);

reg [7:0] tmp_a;
reg [7:0] tmp_b;
reg [15:0] tmp_result;

always @ (vector3 or vector4) begin
  tmp_a = vector3;
  tmp_b = vector4;
  tmp_result = tmp_a * tmp_b;
end

assign result2 = tmp_result;


endmodule