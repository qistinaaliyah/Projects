`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2023 22:42:49
// Design Name: 
// Module Name: multiplier_3
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


module multiplier_3(
 input [7:0] vector5,
  input [7:0] vector6,
  output [15:0] result3
);

reg [7:0] tmp_a;
reg [7:0] tmp_b;
reg [15:0] tmp_result;

always @ (vector5 or vector6) begin
  tmp_a = vector5;
  tmp_b = vector6;
  tmp_result = tmp_a * tmp_b;
end

assign result3 = tmp_result;

endmodule
