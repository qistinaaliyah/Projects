`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2023 01:17:22
// Design Name: 
// Module Name: binary_conversion
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


module binary_conversion(
input [17:0] input_data,
input clk,
output reg [31:0] output_data
);

always @(posedge clk) begin
    output_data = {14'b0, input_data}; //pad with 14 zeros on the left
end

endmodule
