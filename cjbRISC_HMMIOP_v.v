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
cjbRISC_HMMIOP_DP_v DP (.Reset (Reset), .Clock (Clock), .PB1 (PB1), .RST_PC (RST_PC),
    .LD_PC (LD_PC), .CNT_PC (CNT_PC), .LD_IR (LD_IR), .LD_R0 (LD_R0), .LD_R1 (LD_R1),
    .LD_R2 (LD_R2), .LD_R3 (LD_R3), .LD_SR (LD_SR), .LD_MABR (LD_MABR), .LD_MAXR (LD_MAXR),
    .LD_MAR (LD_MAR), .RW (RW), .LD_IPDR (LD_IPDR), .LD_OPDR (LD_OPDR), .push (push), .pop (pop),
    .ipstksel (ipstksel), .IB0_SEL (IB0_SEL), .IB1_SEL (IB1_SEL), .IB2_SEL (IB2_SEL), .SW (SW),
    .ALU_FS (ALU_FS), .LEDs (LEDs), .IW (IW), .SR_CNVZ (SR_CNVZ), .MARout (MARout));

// CU instance - described behaviorally at the lower hierarchical level
cjbRISC_HMMIOP_CU_v CU (.Reset (Reset), .Clock (Clock), .IW (IW), .SR_CNVZ (SR_CNVZ),
    .MARout (MARout), .RST_PC (RST_PC), .LD_PC (LD_PC), .CNT_PC (CNT_PC), .LD_IR (LD_IR),
    .LD_R0 (LD_R0), .LD_R1 (LD_R1), .LD_R2 (LD_R2), .LD_R3 (LD_R3), .LD_SR (LD_SR),
    .LD_MABR (LD_MABR), .LD_MAXR (LD_MAXR), .LD_MAR (LD_MAR), .RW (RW), .LD_IPDR (LD_IPDR),
    .LD_OPDR (LD_OPDR), .push (push), .pop (pop), .ipstksel (ipstksel), .IB0_SEL (IB0_SEL),
    .IB1_SEL (IB1_SEL), .IB2_SEL (IB2_SEL), .ALU_FS (ALU_FS), .crtMCis (crtMCis));

// ICdecode instance - described behaviorally at the lower hierarchical level
// COMMENT OUT WHEN COMPILING FOR FPGA IMPLEMENTATION
// for debugging in ModelSim only
cjb_IW2ASCII_v ICdecode (.IW (IW), .Reset (Reset), .Clock (Clock), .ICis (ICis));
// currently uncommented for simulation

endmodule