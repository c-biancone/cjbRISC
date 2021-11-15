/***************************************************************************************************
* File Name: cjb_nbit_cntup_v.v
*
* Description: Behavioral n-bit up-counter
*              To be used as a generator for machine cycles in the RISC processor
*
* Author: Chris Biancone, October 2021
***************************************************************************************************/

module cjb_nbit_cntup_v (d, ld, reset, cntup, clock, q);

parameter n = 8;

input       [n-1:0] d;
input               ld, reset, cntup, clock;
output reg  [n-1:0] q;

// behavioral n-bit register instantiation
always @(posedge clock)
  if (reset == 1'b1) q = 0;
  else if (ld == 1'b1) q = d;
  else if (cntup == 1'b1)
    q <= q + 1'b1;
  else q = q;

endmodule
