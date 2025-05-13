`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 08:15:27 PM
// Design Name: 
// Module Name: keyexpansion_tb
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


module keyexpansion_tb();

    reg clk, rst;
    reg [127:0] k1;
    wire [127:0] round_key_0, round_key_1, round_key_2, round_key_3, round_key_4;
    wire [127:0] round_key_5, round_key_6, round_key_7, round_key_8, round_key_9, round_key_10;

    // Instantiate DUT
    keyexpansion_encrypt uut (
        .clk(clk),
        .rst(rst),
        .input_key(k1),
        .round_key_0(round_key_0),
        .round_key_1(round_key_1),
        .round_key_2(round_key_2),
        .round_key_3(round_key_3),
        .round_key_4(round_key_4),
        .round_key_5(round_key_5),
        .round_key_6(round_key_6),
        .round_key_7(round_key_7),
        .round_key_8(round_key_8),
        .round_key_9(round_key_9),
        .round_key_10(round_key_10)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        k1 = 128'h00000000000000000000000000000000;

        #15;
        rst = 0; // release reset

        // Wait for 15 clock cycles for all keys to be generated
        repeat (15) @(posedge clk);

        $display("Round Key  0: %h", round_key_0);
        $display("Round Key  1: %h", round_key_1);
        $display("Round Key  2: %h", round_key_2);
        $display("Round Key  3: %h", round_key_3);
        $display("Round Key  4: %h", round_key_4);
        $display("Round Key  5: %h", round_key_5);
        $display("Round Key  6: %h", round_key_6);
        $display("Round Key  7: %h", round_key_7);
        $display("Round Key  8: %h", round_key_8);
        $display("Round Key  9: %h", round_key_9);
        $display("Round Key 10: %h", round_key_10);

        $finish;
    end

endmodule

