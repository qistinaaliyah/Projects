`timescale 1ns / 1ps


module counter_3s(
  input clk_out,
  input reset,
  output timer_3s
    );
   
  reg timer3s_reg = 0;
  clockdivider timer_3(clk_out, count);
  reg [5:0] counter = 0;

  
  always @ (posedge clk_out or posedge reset)
    begin
    if (reset)
    begin
    counter <= 0; 
    timer3s_reg = 0;
    end
    else begin
    if (counter == 44) begin
    counter<= 0;
    timer3s_reg = 0;
    end else begin
    counter <= counter+1; 
    timer3s_reg = 1;
    end
end
end

assign timer_3s = timer3s_reg;
endmodule
