/***************************************************************************************************
* File Name: cjb_8bit_arith_unit_v.v
*
* Description: Structural 8-bit Arithmetic Unit
*              Instantiates the add-sub unit along with its necessary multiplexor
*
* Author: Chris Biancone, October 2021
***************************************************************************************************/

module cjb_8bit_arith_unit_v (Func_Sel, Operand_X, Operand_Y, Const_K, Arith_Result, Arith_CNVZ);

input   [1:0] Func_Sel;
input   [7:0] Operand_X, Operand_Y;
input   [1:0] Const_K;
output  [7:0] Arith_Result;
output  [3:0] Arith_CNVZ;

// Internal signals declarations
wire  [7:0] Int_Result;
wire  [7:0] yselect;
wire        overflow, cout;

// The adder-subtractor and the yselect mux
cjb_8bit_addsub_struc_v addersub (.cin (Func_Sel[0]), .x (Operand_X), .y (yselect),
    .sum(Int_Result), .cout (cout), .overflow (overflow));

cjb_nbit_mux2to1_struc_v #(8) yselect_mux (.d1 ({6'b000000, Const_K}), .d0 (Operand_Y),
    .s (Func_Sel[1]), .f (yselect));

// final output and status bits assignments
assign Arith_Result = Int_Result[7:0];
assign Arith_CNVZ = {cout, Int_Result[7], overflow, ~| Int_Result};

endmodule