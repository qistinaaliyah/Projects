`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2023 00:58:58
// Design Name: 
// Module Name: accumulator
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


module accumulator(
input clk,
input reset,
input [17:0] datain,
output [17:0] dataout_acc
);
    
    reg [17:0] data;
    
    always @(posedge clk) begin
        if (reset == 1) begin
        data <= 18'b0;
        end else begin
        data <= datain;
        end 
    end 
    assign dataout_acc = data;
endmodule

