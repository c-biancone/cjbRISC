/***************************************************************************************************
* File Name: cjb_8bit_addsub_struc_v.v
*
* Description: Structural 8-bit ALU Add-Subtract Subunit
*              Instantiates full adders and handles carry and overflow bits
*
* Author: Chris Biancone, October 2021
***************************************************************************************************/

module cjb_8bit_addsub_struc_v (cin, x, y, sum, cout, overflow);

input         cin;
input   [7:0] x, y;
output  [7:0] sum;
output        cout, overflow;

// internal wires
wire    [8:0] c;
wire    [7:0] y1sc;

// take in carry and create 2's complement representation of y-input
assign c[0] = cin;
assign y1sc = {8{cin}} ^ y; // replication operator

// instantiate 8 stages of full adder; 1 for each bit
cjb_fa_struc_v  stage0 (.cin (c[0]), .x (x[0]), .y (y1sc[0]), .sum (sum[0]), .cout (c[1]));
cjb_fa_struc_v  stage1 (.cin (c[1]), .x (x[1]), .y (y1sc[1]), .sum (sum[1]), .cout (c[2]));
cjb_fa_struc_v  stage2 (.cin (c[2]), .x (x[2]), .y (y1sc[2]), .sum (sum[2]), .cout (c[3]));
cjb_fa_struc_v  stage3 (.cin (c[3]), .x (x[3]), .y (y1sc[3]), .sum (sum[3]), .cout (c[4]));
cjb_fa_struc_v  stage4 (.cin (c[4]), .x (x[4]), .y (y1sc[4]), .sum (sum[4]), .cout (c[5]));
cjb_fa_struc_v  stage5 (.cin (c[5]), .x (x[5]), .y (y1sc[5]), .sum (sum[5]), .cout (c[6]));
cjb_fa_struc_v  stage6 (.cin (c[6]), .x (x[6]), .y (y1sc[6]), .sum (sum[6]), .cout (c[7]));
cjb_fa_struc_v  stage7 (.cin (c[7]), .x (x[7]), .y (y1sc[7]), .sum (sum[7]), .cout (c[8]));

// calculate carry out and overflow status bit values
assign cout = c[8];
assign overflow = c[7] ^ c[8];

endmodule