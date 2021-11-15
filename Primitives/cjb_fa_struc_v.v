/***************************************************************************************************
* File Name: cjb_fa_struc_v.v
*
* Description: Structural 1-bit Full Adder
*
* Author: Chris Biancone, October 2021
***************************************************************************************************/

module cjb_fa_struc_v (cin, x, y, sum, cout);

input   cin, x, y;
output  sum, cout;
wire    z1, z2, z3;

  // structural block
  xor (sum, x, y, cin);
  and (z1, x, y);
  and (z2, x, cin);
  and (z3, y, cin);
  or  (cout, z1, z2, z3);

endmodule