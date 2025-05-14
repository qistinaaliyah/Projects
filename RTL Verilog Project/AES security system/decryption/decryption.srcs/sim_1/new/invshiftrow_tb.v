`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2025 02:00:50 PM
// Design Name: 
// Module Name: invshiftrow_tb
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


module invshiftrow_tb();

    reg [127:0] state_in;      // Input state matrix
    wire [127:0] state_out;    // Output state matrix after Inverse ShiftRows

    // Instantiate the Inverse ShiftRows module
    invshiftrow uut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin
        // Test Vector 1 (This should be the output of ShiftRows)
        state_in = 128'hd4bf5d30b452aee011f1b841e51e2798; // Shifted state input
        #10;
        $display("Test Vector 1:");
        $display("Input : %h", state_in);
        $display("Output: %h", state_out);

        // Test Vector 2
        state_in = 128'ha0b1c2d3a1b2c3d0a2b3c0d1a3b0c1d2; // Another example state
        #10;
        $display("Test Vector 2:");
        $display("Input : %h", state_in);
        $display("Output: %h", state_out);

        // Finish simulation
        $stop;
    end

endmodule