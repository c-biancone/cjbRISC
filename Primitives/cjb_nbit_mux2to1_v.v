/***************************************************************************************************
* File Name: cjb_nbit_mux2to1_struc_v.v
*
* Description: Structural n-bit 2-to-1 multiplexor
*
* Author: Chris Biancone, November 2021
***************************************************************************************************/

module cjb_nbit_mux2to1_struc_v (d1, d0, s, f);

parameter       n = 8;

input	  [n-1:0] d1, d0;
input           s;
output  [n-1:0] f;

assign f = s ? d1 : d0; // ternary operator: conditional assignment

endmodule
