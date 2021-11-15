/***************************************************************************************************
* File Name: cjb_8bit_const_unit_v.v
*
* Description: Structural 8-bit Constant-Output Unit
*              Selects predetermined values to output
*
* Author: Chris Biancone, October 2021
***************************************************************************************************/

module cjb_8bit_const_unit_v (Func_Sel, Const_Result, Const_CNVZ);

input [1:0] Func_Sel;
output [7:0] Const_Result;
output [3:0] Const_CNVZ;

// the const_mux instance - no other logic here
cjb_nbit_mux4to1_struc_v #(8) const_mux (.d3 (8'b11111111), .d2 (8'b10101010), .d1 (8'b01010101),
    .d0 (8'b00000000), .s (Func_Sel[1:0]), .f (Const_Result));

// 
assign Const_CNVZ = {1'b0, Const_Result[7], 1'b0, ~| Const_Result};

endmodule