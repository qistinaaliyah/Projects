`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 07:59:49 PM
// Design Name: 
// Module Name: mixcol
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


module mixcol(
    input [127:0] state_in,    // Input state matrix (4 columns, 128 bits)
    output [127:0] state_out   // Output state matrix (4 columns, 128 bits)
);

    // Instantiate mix_columns for each column of the matrix
    mixcol_matrix col0 (
        .column_in(state_in[127:96]), // Column 0 (Most Significant)
        .column_out(state_out[127:96])
    );

    mixcol_matrix col1 (
        .column_in(state_in[95:64]), // Column 1
        .column_out(state_out[95:64])
    );

    mixcol_matrix col2 (
        .column_in(state_in[63:32]), // Column 2
        .column_out(state_out[63:32])
    );

    mixcol_matrix col3 (
        .column_in(state_in[31:0]), // Column 3 (Least Significant)
        .column_out(state_out[31:0])
    );
    
endmodule

module mixcol_matrix(
    input [31:0] column_in,   // Input column (4 bytes)
    output [31:0] column_out  // Output column (4 bytes)
);

    // Extract bytes from the input column
    wire [7:0] s0 = column_in[31:24];
    wire [7:0] s1 = column_in[23:16];
    wire [7:0] s2 = column_in[15:8];
    wire [7:0] s3 = column_in[7:0];

    // GF(2^8) multiplication
    function [7:0] gmul2(input [7:0] b);
        gmul2 = (b[7] == 1'b0) ? (b << 1) : ((b << 1) ^ 8'h1B);
    endfunction

    function [7:0] gmul3(input [7:0] b);
        gmul3 = gmul2(b) ^ b;
    endfunction

    // MixColumns transformations
    assign column_out[31:24] = gmul2(s0) ^ gmul3(s1) ^ s2 ^ s3; // 2*s0 + 3*s1 + s2 + s3
    assign column_out[23:16] = s0 ^ gmul2(s1) ^ gmul3(s2) ^ s3; // s0 + 2*s1 + 3*s2 + s3
    assign column_out[15:8]  = s0 ^ s1 ^ gmul2(s2) ^ gmul3(s3); // s0 + s1 + 2*s2 + 3*s3
    assign column_out[7:0]   = gmul3(s0) ^ s1 ^ s2 ^ gmul2(s3); // 3*s0 + s1 + s2 + 2*s3

endmodule
