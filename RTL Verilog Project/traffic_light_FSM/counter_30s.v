`timescale 1ns / 1ps


module counter_30s(
 input clk_out,
 input reset,
 output timer_30s
    );
   
  reg timer30s_reg = 0;
  clockdivider timer_30(clk_out, count);
  reg [8:0] counter = 0;

  
  always @ (posedge clk_out or posedge reset)
    begin
    if (reset)
    begin
    counter <= 0; 
    timer30s_reg = 0;
    end
    else begin
    if (counter == 449) begin
    counter<= 0;
    timer30s_reg = 0;
    end else begin
    counter <= counter+1; 
    timer30s_reg = 1;
    end
end
end

assign timer_30s = timer30s_reg;
endmodule