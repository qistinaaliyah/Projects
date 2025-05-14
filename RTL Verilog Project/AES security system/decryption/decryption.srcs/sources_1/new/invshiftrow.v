`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2025 02:00:14 PM
// Design Name: 
// Module Name: invshiftrow
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


module invshiftrow(
    input [127:0] state_in,    // Input state matrix (128 bits)
    output [127:0] state_out   // Output state matrix after Inverse ShiftRows
);

    // Inverse ShiftRows transformation applied **column-wise**
    // Column 0
    assign state_out[127:120] = state_in[127:120]; // s00 → s00
    assign state_out[95:88]   = state_in[95:88];   // s10 → s10
    assign state_out[63:56]   = state_in[63:56];   // s20 → s20
    assign state_out[31:24]   = state_in[31:24];   // s30 → s30

    // Column 1 (Right shift by 1)
    assign state_out[119:112] = state_in[23:16];   // s31 → s01
    assign state_out[87:80]   = state_in[119:112]; // s01 → s11
    assign state_out[55:48]   = state_in[87:80];   // s11 → s21
    assign state_out[23:16]   = state_in[55:48];   // s21 → s31

    // Column 2 (Right shift by 2)
    assign state_out[111:104] = state_in[47:40];   // s22 → s02
    assign state_out[79:72]   = state_in[15:8];    // s32 → s12
    assign state_out[47:40]   = state_in[111:104]; // s02 → s22
    assign state_out[15:8]    = state_in[79:72];   // s12 → s32

    // Column 3 (Right shift by 3)
    assign state_out[103:96]  = state_in[71:64];   // s13 → s03
    assign state_out[71:64]   = state_in[39:32];   // s23 → s13
    assign state_out[39:32]   = state_in[7:0];     // s33 → s23
    assign state_out[7:0]     = state_in[103:96];  // s03 → s33

endmodule

