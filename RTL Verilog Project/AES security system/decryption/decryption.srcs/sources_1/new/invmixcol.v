`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2025 02:10:10 PM
// Design Name: 
// Module Name: invmixcol
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


module invmixcol(
    input [127:0] state_in,    // Input state matrix (128 bits)
    output [127:0] state_out   // Output state matrix (128 bits)
);

    // Instantiate inv_mix_columns for each column
    invmixcolumn_sub col0 (
        .column_in(state_in[127:96]), // Column 0 (Most Significant)
        .column_out(state_out[127:96])
    );

    invmixcolumn_sub col1 (
        .column_in(state_in[95:64]), // Column 1
        .column_out(state_out[95:64])
    );

    invmixcolumn_sub col2 (
        .column_in(state_in[63:32]), // Column 2
        .column_out(state_out[63:32])
    );

    invmixcolumn_sub col3 (
        .column_in(state_in[31:0]), // Column 3 (Least Significant)
        .column_out(state_out[31:0])
    );

endmodule

module invmixcolumn_sub (
    input [31:0] column_in,   // Input column (4 bytes)
    output [31:0] column_out  // Output column (4 bytes)
);

    // Extract bytes from the input column
    wire [7:0] s0 = column_in[31:24];
    wire [7:0] s1 = column_in[23:16];
    wire [7:0] s2 = column_in[15:8];
    wire [7:0] s3 = column_in[7:0];

    // GF(2^8) multiplication functions
    function [7:0] gmul2(input [7:0] b);
        gmul2 = (b[7] == 1'b0) ? (b << 1) : ((b << 1) ^ 8'h1B);
    endfunction

    function [7:0] gmul3(input [7:0] b);
        gmul3 = gmul2(b) ^ b;
    endfunction

    function [7:0] gmul9(input [7:0] b);
        gmul9 = gmul2(gmul2(gmul2(b))) ^ b;
    endfunction

    function [7:0] gmulB(input [7:0] b);
        gmulB = gmul2(gmul2(gmul2(b))) ^ gmul2(b) ^ b;
    endfunction

    function [7:0] gmulD(input [7:0] b);
        gmulD = gmul2(gmul2(gmul2(b))) ^ gmul2(gmul2(b)) ^ b;
    endfunction

    function [7:0] gmulE(input [7:0] b);
        gmulE = gmul2(gmul2(gmul2(b))) ^ gmul2(gmul2(b)) ^ gmul2(b);
    endfunction

    // Inverse MixColumns transformations
    assign column_out[31:24] = gmulE(s0) ^ gmulB(s1) ^ gmulD(s2) ^ gmul9(s3);
    assign column_out[23:16] = gmul9(s0) ^ gmulE(s1) ^ gmulB(s2) ^ gmulD(s3);
    assign column_out[15:8]  = gmulD(s0) ^ gmul9(s1) ^ gmulE(s2) ^ gmulB(s3);
    assign column_out[7:0]   = gmulB(s0) ^ gmulD(s1) ^ gmul9(s2) ^ gmulE(s3);

endmodule
