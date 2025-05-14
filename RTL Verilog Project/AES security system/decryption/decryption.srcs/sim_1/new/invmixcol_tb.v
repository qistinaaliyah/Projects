`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2025 02:11:49 PM
// Design Name: 
// Module Name: invmixcol_tb
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


module invmixcol_tb();

    reg [127:0] state_in;
    wire [127:0] state_out;

    // Instantiate Inverse MixColumns Module
    invmixcol uut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin
        // Test Vector 1 (Example after MixColumns)
        state_in = 128'h046681e5e0cb199a48f8d37a28062277;
        #10;
        $display("Test Vector 1:");
        $display("Input : %h", state_in);
        $display("Output: %h", state_out);

        // Test Vector 2
        state_in = 128'h00112233445566778899aabbccddeeff; // Another example
        #10;
        $display("Test Vector 2:");
        $display("Input : %h", state_in);
        $display("Output: %h", state_out);

        // Finish simulation
        $stop;
    end

endmodule