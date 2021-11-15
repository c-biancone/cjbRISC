/***************************************************************************************************
* File Name: cjb_nbit_mux4to1_struc_v.v
*
* Description: Structural n-bit 4-to-1 multiplexor
*
* Author: Chris Biancone, November 2021
***************************************************************************************************/

module cjb_nbit_mux4to1_struc_v (d3, d2, d1, d0, s, f);

parameter       n = 8;

input	  [n-1:0] d3, d2, d1, d0;
input   [1:0]   s;
output  [n-1:0] f;
wire    [n-1:0] f1, f0;

// instantiate 3 2-to-1 MUXes to form 4-to-1
cjb_nbit_mux2to1_struc_v stage0 (.d1 (d1), .d0 (d0), .s (s[0]), .f (f0));
cjb_nbit_mux2to1_struc_v stage1 (.d1 (d3), .d0 (d2), .s (s[0]), .f (f1));
cjb_nbit_mux2to1_struc_v stage2 (.d1 (f1), .d0 (f0), .s (s[1]), .f (f));

endmodule
