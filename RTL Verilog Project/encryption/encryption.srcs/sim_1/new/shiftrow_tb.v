`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 07:53:20 PM
// Design Name: 
// Module Name: shiftrow_tb
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


module shiftrow_tb();
  reg [127:0] state_in;      // Input state matrix
    wire [127:0] state_out;    // Output state matrix after ShiftRows

    // Instantiate the ShiftRows module
    shiftrow uut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin
        // Test Vector 1
        state_in = 128'hd4bf5d30e0b452aeb84111f11e2798e5; // Input state
        #10;  // Wait for 10 time units
        $display("Test Vector 1:");
        $display("Input : %h", state_in);
        $display("Output: %h", state_out);

        // Test Vector 2
        state_in = 128'ha0b0c0d0a1b1c1d1a2b2c2d2a3b3c3d3; // Another example state
        #10;
        $display("Test Vector 2:");
        $display("Input : %h", state_in);
        $display("Output: %h", state_out);

        // Finish simulation
        $stop;
    end

endmodule
