/***************************************************************************************************
* File Name: cjb_8bit_sr_unit_v.v
*
* Description: Structural 8-bit Shift/Rotate Unit
*              Performs bianry shift or rotate operations on inputs
*
* Author: Chris Biancone, October 2021
***************************************************************************************************/

module cjb_8bit_sr_unit_v (Func_Sel, Operand_X, Operand_Y, Const_K, cin, SR_Result, SR_CNVZ);

input   [1:0] Func_Sel;
input   [7:0] Operand_X, Operand_Y;
input   [1:0] Const_K;
input         cin;
output  [7:0] SR_Result;
output  [3:0] SR_CNVZ;

// internal wires
wire  [7:0] shra, shra0, shra1, shra2, shra3;
wire  [7:0] shrl, shrl0, shrl1, shrl2, shrl3;
wire  [7:0] rrc, rrc0, rrc1, rrc2, rrc3;
wire        rrc_carry, carry0, carry1, carry2, carry3;

// shift/rotate mux
cjb_nbit_mux4to1_struc_v #(8) sr_mux (.d3 (Operand_Y), .d2 (rrc), .d1 (shrl), .d0 (shra),
    .s (Func_Sel[1:0]), .f (SR_Result));

// calculate how many bits to shift right arithmetic by using nested ternary
assign shra = Const_K[1] ? (Const_K[0] ? shra3 : shra2) : (Const_K[0] ? shra1 : shra0);

assign shra3 = {Operand_X[7], Operand_X[7], Operand_X[7], Operand_X[7], Operand_X[6], Operand_X[5],
                Operand_X[4], Operand_X[3]};
assign shra2 = {Operand_X[7], Operand_X[7], Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4],
                Operand_X[3], Operand_X[2]};
assign shra1 = {Operand_X[7], Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3],
                Operand_X[2], Operand_X[1]};
assign shra0 = {Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3], Operand_X[2],
                Operand_X[1], Operand_X[0]};

// similarly calculate for shift right logic
assign shrl = Const_K[1] ? (Const_K[0] ? shrl3 : shrl2) : (Const_K[0] ? shrl1 : shrl0);

assign shrl3 = {1'b0, 1'b0, 1'b0, Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4],
                Operand_X[3]};
assign shrl2 = {1'b0, 1'b0, Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3],
                Operand_X[2]};
assign shrl1 = {1'b0, Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3],
                Operand_X[2], Operand_X[1]};
assign shrl0 = {Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3], Operand_X[2],
                Operand_X[1], Operand_X[0]};

// again for rotate right through carry
assign rrc = Const_K[1] ? (Const_K[0] ? rrc3 : rrc2) : (Const_K[0] ? rrc1 : rrc0);

assign rrc3 = {Operand_X[1], Operand_X[0], cin, Operand_X[7], Operand_X[6], Operand_X[5],
               Operand_X[4], Operand_X[3]};
assign rrc2 = {Operand_X[0], cin, Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4],
               Operand_X[3], Operand_X[2]};
assign rrc1 = {cin, Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3],
               Operand_X[2], Operand_X[1]};
assign rrc0 = {Operand_X[7], Operand_X[6], Operand_X[5], Operand_X[4], Operand_X[3], Operand_X[2],
               Operand_X[1], Operand_X[0]};
// assign carry values (the ones not present in the respective rrc outputs above)
  assign rrc_carry = Const_K[1] ? (Const_K[0] ? carry3 : carry2) : (Const_K[0] ? carry1 : carry0);
    assign carry3 = {Operand_X[2]};
    assign carry2 = {Operand_X[1]};
    assign carry1 = {Operand_X[0]};
    assign carry0 = {cin};

// status bits
assign SR_CNVZ = {1'b0 | rrc_carry, SR_Result[7], 1'b0, ~| SR_Result};

endmodule