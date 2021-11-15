/***************************************************************************************************
* File Name: cjbRISC_HMMIOP_v_FPGA.v
*
* Description: Structural top-level module for cjbRISC_HMMIOP
*              Instantiates the RISC processor DP, CU, and optional ICdecode modules
*
* Author: Chris Biancone, October 2021
***************************************************************************************************/

module cjbRISC_HMMIOP_v (Reset, Clock, PB1, SW, LEDs, ICis, crtMCis);

input           Reset, Clock, PB1;
input   [3:0]   SW;
output  [7:0]   LEDs;
output  [95:0]  ICis;
output  [2:0]   crtMCis;

// internal wires
wire  [7:0] IW;
wire  [3:0] SR_CNVZ, ALU_FS;
wire        RST_PC, LD_PC, CNT_PC, LD_IR, LD_R0, LD_R1, LD_R2, LD_R3, LD_SR, LD_MABR, LD_MAXR,
            LD_MAR, RW, LD_IPDR, LD_OPDR, push, pop, ipstksel;
wire  [1:0] IB0_SEL, IB1_SEL, IB2_SEL;
wire  [9:0] MARout;

// DP instance - described structurally at the lower hierarchical level
cjbRISC_HMMIOP_DP_v DP (Reset, Clock, PB1, SW, LEDs, IW, SR_CNVZ, MARout, RST_PC, LD_PC, CNT_PC,
    LD_IR, LD_R0, LD_R1, LD_R2, LD_R3, LD_SR, LD_MABR, LD_MAXR, LD_MAR, RW, LD_IPDR, LD_OPDR,
    IB0_SEL, IB1_SEL, IB2_SEL, ALU_FS, push, pop, ipstksel);

// CU instance - described behaviorally at the lower hierarchical level
cjbRISC_HMMIOP_CU_v CU (Reset, Clock, IW, SR_CNVZ, MARout, RST_PC, LD_PC, CNT_PC, LD_IR, LD_R0,
    LD_R1, LD_R2, LD_R3, LD_SR, LD_MABR, LD_MAXR, LD_MAR, RW, LD_IPDR, LD_OPDR, IB0_SEL, IB1_SEL,
    IB2_SEL, ALU_FS, push, pop, ipstksel, crtMCis);

// ICdecode instance - described behaviorally at the lower hierarchical level
// COMMENT OUT WHEN COMPILING FOR FPGA IMPLEMENTATION
// for debugging in ModelSim only
cjb_IW2ASCII_v ICdecode (IW, Reset, Clock, ICis); // currently uncommented for simulation

endmodule