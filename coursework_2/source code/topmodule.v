`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2023 23:27:00
// Design Name: 
// Module Name: topmodule
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


module topmodule(
input [7:0] dataA,
input [7:0] dataB,
input [7:0] dataC,
input [7:0] dataD,
input [7:0] dataE,
input [7:0] dataF,
input [7:0] dataG,
input [7:0] dataH,
input reset,
input clk,
input start,
output [17:0] dataout_final
);

//all port from the instatiation where the reg is input and wire is the output
wire [15:0] dataout_multiplier1;
wire [15:0] dataout_multiplier2;
wire [15:0] dataout_multiplier3;
wire [15:0] dataout_multiplier4;
wire [16:0] sum1;
wire [16:0] sum2;
wire [16:0] sum;
reg [15:0] A1;
reg [15:0] B1;
reg [15:0] C1;
reg [15:0] D1;
reg [16:0] A;
reg [16:0] B;
reg [17:0] datain;
wire [17:0] dataout_acc;

//all instatiation of the sub module into the top module   
multiplier_combine combine_i(
.dataA(dataA), .dataB(dataB), .dataC(dataC), .dataD(dataD),
.dataE(dataE),.dataF(dataF),.dataG(dataG),.dataH(dataH),
.reset(reset),.clk(clk), .dataout_multiplier1(dataout_multiplier1),
.dataout_multiplier2(dataout_multiplier2), .start(start),
.dataout_multiplier3(dataout_multiplier3), .dataout_multiplier4(dataout_multiplier4));

adder17_1 adder17_1i( 
  .A1(A1), .B1(B1), .sum1(sum1));
    
adder17_2 adder17_2i(
 .C1(C1), .D1(D1), .sum2(sum2));    

adder18 bits18_adder_i(
    .A(A), .B(B), .sum(sum));   
    
accumulator accumulator_i(
    .clk(clk), .reset(reset),
    .datain(datain), .dataout_acc(dataout_acc));

//register for the 17 bits adder output    
reg [16:0] dataout_add17_1;
reg [16:0] dataout_add17_2;      

//register for multiplier output
reg [15:0] dataoutmul1;
reg [15:0] dataoutmul2;
reg [15:0] dataoutmul3;
reg [15:0] dataoutmul4;

//register for 18 bits adder output
reg [17:0] dataout_add18;
//register for accumulator
reg [17:0] acc_reg;

    
always @ (posedge clk) begin
    if (reset) begin
    //if reset, all the registers value will be 0
    dataout_add17_1 = 0; dataout_add17_2 = 0; 
    dataoutmul1 = 0; dataoutmul2 = 0; dataoutmul3 = 0; dataoutmul4 = 0;
    
    //this part is where the value from different module
    //will be tansfered into the next module by following this flow:
    //multiplier_combine > adder17bits > adder18bits > accumulator
    end else begin
    dataoutmul1 [15:0] <= dataout_multiplier1;
    dataoutmul2 [15:0] <= dataout_multiplier2;
    dataoutmul3 [15:0] <= dataout_multiplier3;   
    dataoutmul4 [15:0] <= dataout_multiplier4;
    A1 <= dataoutmul1;
    B1 <= dataoutmul2;
    C1 <= dataoutmul3;
    D1 <= dataoutmul4;
    dataout_add17_1 [16:0] <= sum1;
    dataout_add17_2 [16:0] <= sum2;
    A <= dataout_add17_1;
    B <= dataout_add17_2;
    dataout_add18 [17:0] <= sum;
    datain <=  dataout_add18;
    acc_reg [17:0] <= dataout_acc;
    end
end
//assigning the accumulator register value into the output of the module
assign dataout_final = acc_reg;
endmodule
