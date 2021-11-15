/***************************************************************************************************
* File Name: cjb_nbit_4loc_stack_v.v
*
* Description: Behavioral 4-location 8-bit hardware stack
*              To be used with "push" and "pop" instructions in the RISC processor
*
* Author: Chris Biancone, October 2021
***************************************************************************************************/

module cjb_nbit_4loc_stack_v (push, pop, reset, clock, din, dout);

// Input and output ports
parameter           n = 8;

input               push, pop, reset, clock;
input       [n-1:0] din;
output reg  [n-1:0] dout;

// Internal registered signals
reg [n-1:0] tos, tos1, tos2, tos3;

// Behavioral description
always @(posedge clock) begin
  if (reset) begin tos = 8'h00; tos1 = 8'h00; tos2 = 8'h00; tos3 = 8'h00; end
  else if (push) begin tos3 = tos2; tos2 = tos1; tos1 = tos; tos = din; dout = din; end
  else if (pop) begin dout = tos; tos = tos1; tos1 = tos2; tos2 = tos3; tos3 = 8'h00; end
  else begin tos = tos; tos1 = tos1; tos2 = tos2; tos3 = tos3; dout = tos; end
end

endmodule
