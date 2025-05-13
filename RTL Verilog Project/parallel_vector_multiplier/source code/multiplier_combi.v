`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2023 22:57:27
// Design Name: 
// Module Name: multiplier_combine
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


module multiplier_combine(
input [7:0] dataA,
input [7:0] dataB,
input [7:0] dataC,
input [7:0] dataD,
input [7:0] dataE,
input [7:0] dataF,
input [7:0] dataG,
input [7:0] dataH,
input reset,
input start,
input clk,
output [15:0] dataout_multiplier1,
output [15:0] dataout_multiplier2,
output [15:0] dataout_multiplier3,
output [15:0] dataout_multiplier4
);


reg [7:0] vector1;
reg [7:0] vector2;
reg [7:0] vector3;
reg [7:0] vector4;
reg [7:0] vector5;
reg [7:0] vector6;
reg [7:0] vector7;
reg [7:0] vector8;
wire [15:0] result1;
wire [15:0] result2;
wire [15:0] result3;
wire [15:0] result4;

multiplier1 multiplier_i(
.vector1(vector1), .vector2(vector2), .result1(result1)
);

multiplier_2 multiplier2_i(
.vector3(vector3), .vector4(vector4), .result2(result2)
);

multiplier_3 multiplier3_i(
.vector5(vector5), .vector6(vector6), .result3(result3)
);

multiplier_4 multiplier4_i(
.vector7(vector7), .vector8(vector8), .result4(result4)
);

reg [7:0] dataA_reg;
reg [7:0] dataB_reg;
reg [7:0] dataC_reg;
reg [7:0] dataD_reg;
reg [7:0] dataE_reg;
reg [7:0] dataF_reg;
reg [7:0] dataG_reg;
reg [7:0] dataH_reg;
reg [15:0] dataout1;
reg [15:0] dataout2;
reg [15:0] dataout3;
reg [15:0] dataout4;

always @ (posedge clk) begin
    if (reset && start == 0) begin
    dataA_reg = 0; dataB_reg = 0; dataC_reg = 0; dataD_reg = 0;
    dataE_reg = 0; dataF_reg = 0; dataG_reg = 0; dataH_reg = 0;
    dataout1 = 0; dataout2 = 0; dataout3 = 0; dataout4 = 0;
    end 
    else begin       
             dataA_reg[7:0] <= dataA; 
             dataB_reg[7:0] <= dataB; 
             vector1 <= dataA_reg;
             vector2 <= dataB_reg;
             dataout1 <= result1;
             
             dataC_reg[7:0] <= dataC; 
             dataD_reg[7:0] <= dataD; 
             vector3 <= dataC_reg;
             vector4 <= dataD_reg;
             dataout2 <= result2;
             
             dataE_reg[7:0] <= dataE; 
             dataF_reg[7:0] <= dataF; 
             vector5 <= dataE_reg;
             vector6 <= dataF_reg;
             dataout3 <= result3;
             
             dataG_reg[7:0] <= dataG; 
             dataH_reg[7:0] <= dataH; 
             vector7 <= dataG_reg;
             vector8 <= dataH_reg;
             dataout4 <= result4;

        end
  end
 assign dataout_multiplier1 = dataout1;
 assign dataout_multiplier2 = dataout2;
 assign dataout_multiplier3 = dataout3;
 assign dataout_multiplier4 = dataout4;
endmodule

