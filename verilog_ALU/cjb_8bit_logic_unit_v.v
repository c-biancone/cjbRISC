/***************************************************************************************************
* File Name: cjb_8bit_logic_unit_v.v
*
* Description: Structural 8-bit Logic Unit
*              Performs logical &, |, ^ operations on inputs
*
* Author: Chris Biancone, October 2021
***************************************************************************************************/

module cjb_8bit_logic_unit_v (Func_Sel, Operand_X, Operand_Y, Const_K, Logic_Result, Logic_CNVZ);

input   [1:0] Func_Sel;
input   [7:0] Operand_X, Operand_Y;
input   [1:0] Const_K;
output  [7:0] Logic_Result;
output  [3:0] Logic_CNVZ;

// internal signals declarations
wire [7:0] or_result, and_result, xor_result;

// logic_mux instance
cjb_nbit_mux4to1_struc_v #(8) logic_mux (.d3 (Operand_X), .d2 (or_result), .d1 (and_result),
    .d0 (xor_result), .s (Func_Sel[1:0]), .f (Logic_Result));

// outputs assignment
assign xor_result = Operand_X ^ Operand_Y;
assign and_result = Operand_X & Operand_Y;
assign or_result = Operand_X | Operand_Y;

// status bits
assign Logic_CNVZ = {1'b0, Logic_Result[7], 1'b0, ~| Logic_Result};

endmodule