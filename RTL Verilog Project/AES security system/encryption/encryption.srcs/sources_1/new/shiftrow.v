`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// AES ShiftRows Transformation
//////////////////////////////////////////////////////////////////////////////////

module shiftrow(
    input  [127:0] state_in,    // Input state matrix (128 bits)
    output [127:0] state_out    // Output state matrix after ShiftRows
);

    // Input byte mapping from state_in
    wire [7:0] s [0:15];
    assign {s[0], s[1], s[2], s[3],
            s[4], s[5], s[6], s[7],
            s[8], s[9], s[10], s[11],
            s[12], s[13], s[14], s[15]} = state_in;

    // ShiftRows transformation:
    // Original indices:
    //  [ 0,  4,  8, 12 ]  -> Row 0 (no shift)
    //  [ 1,  5,  9, 13 ]  -> Row 1 (shift by 1)
    //  [ 2,  6, 10, 14 ]  -> Row 2 (shift by 2)
    //  [ 3,  7, 11, 15 ]  -> Row 3 (shift by 3)

    assign state_out = {
        s[0],  s[5],  s[10], s[15], // Column 0: s00 s11 s22 s33
        s[4],  s[9],  s[14], s[3],  // Column 1: s10 s21 s32 s03
        s[8],  s[13], s[2],  s[7],  // Column 2: s20 s31 s02 s13
        s[12], s[1],  s[6],  s[11]  // Column 3: s30 s01 s12 s23
    };

endmodule
