`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 08:01:55 PM
// Design Name: 
// Module Name: mixcol_tb
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


module mixcol_tb();

    reg [127:0] state_in;     // Input state matrix
    wire [127:0] state_out;   // Output state matrix after MixColumns

    // Instantiate the MixColumns Matrix Module
    mixcol uut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin
        // Test Vector 1
        state_in = 128'hd4bf5d30e0b452aeb84111f11e2798e5; // Input state
        #10;  // Wait for 10 time units
        $display("Input : %h", state_in);
        $display("Output: %h", state_out);

        // Test Vector 2
        state_in = 128'hb1f056638484d609c0895e8112153524; // Another example state
        #10;
        $display("Input : %h", state_in);
        $display("Output: %h", state_out);

        // Finish simulation
        $stop;
    end

endmodule
