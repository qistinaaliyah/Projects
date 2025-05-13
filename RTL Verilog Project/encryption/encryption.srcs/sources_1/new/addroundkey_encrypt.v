`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 08:07:57 PM
// Design Name: 
// Module Name: addroundkey_encrypt
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


module addroundkey_encrypt(
  input [127:0] state_in,    // Input state matrix (128 bits)
  input [127:0] round_key,   // Round key (128 bits)
  output [127:0] state_out   // Output state matrix after AddRoundKey
);

    assign state_out = state_in ^ round_key;
    
endmodule
    

