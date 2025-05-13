`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2025 02:08:21 PM
// Design Name: 
// Module Name: addroundkey_decrypt_tb
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


module addroundkey_decrypt_tb();
    reg [127:0] state_in;       // Input state matrix
    reg [127:0] round_key;      // Round key
    wire [127:0] state_out;     // Output state matrix after AddRoundKey

    // Instantiate the AddRoundKey module
    addroundkey_decrypt uut (
        .state_in(state_in),
        .round_key(round_key),
        .state_out(state_out)
    );

    initial begin
        // Test Vector 1
        state_in = 128'hd4bf5d30e0b452aeb84111f11e2798e5; // Example input state
        round_key = 128'h2b7e151628aed2a6abf7158809cf4f3c; // Example round key
        #10;  // Wait for 10 time units
        $display("Test Vector 1:");
        $display("State In : %h", state_in);
        $display("Round Key: %h", round_key);
        $display("State Out: %h", state_out);

        // Test Vector 2
        state_in = 128'h046681e5e0cb199a48f8d37a2806264c; // Another example state
        round_key = 128'ha0fafe1788542cb123a339392a6c7605; // Another example round key
        #10;
        $display("Test Vector 2:");
        $display("State In : %h", state_in);
        $display("Round Key: %h", round_key);
        $display("State Out: %h", state_out);

        // Finish simulation
        $stop;
    end

endmodule