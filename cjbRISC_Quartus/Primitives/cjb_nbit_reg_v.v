/***************************************************************************************************
* File Name: cjb_nbit_reg_v.v
*
* Description: Behavioral n-bit simple register
*
* Author: Chris Biancone, October 2021
***************************************************************************************************/

module cjb_nbit_reg_v (d, ld, reset, clock, q);

parameter           n = 4;

input       [n-1:0] d;
input               ld, reset, clock;
output reg  [n-1:0] q;

// register description
always @(posedge clock)
  if (reset == 1'b1) q = 0;
  else if (ld == 1'b1) q = d;
  else q = q;

endmodule
