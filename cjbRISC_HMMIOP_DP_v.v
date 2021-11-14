//=============================================================================
// This is the structural data path (DP) module for the cjbRISC_HMMIOP.
// Specifications: three internal busses, Harvard, memory mapped I/O-Ps.
// Chris Biancone October 2021.
//=============================================================================
module cjbRISC_HMMIOP_DP_v
	(Reset, Clock, PB1, SW, LEDs, IW, SR_CNVZ, MARout,
	RST_PC, LD_PC, CNT_PC, LD_IR, LD_R0, LD_R1, LD_R2, LD_R3,
	LD_SR, LD_MABR, LD_MAXR, LD_MAR, RW,
	LD_IPDR, LD_OPDR, IB0_SEL, IB1_SEL, IB2_SEL, ALU_FS, push, pop, ipstksel);
//=============================================================================
// Input and output ports declarations
//=============================================================================
input Reset, Clock, PB1, RST_PC, LD_PC, CNT_PC, LD_IR,
	LD_R0, LD_R1, LD_R2, LD_R3, LD_SR,
	LD_MABR, LD_MAXR, LD_MAR, RW, LD_IPDR, LD_OPDR, push, pop, ipstksel;
input [1:0] IB0_SEL, IB1_SEL, IB2_SEL; // bus selects
input [3:0] SW, ALU_FS;
output [7:0] LEDs, IW;
output [3:0] SR_CNVZ;
output [9:0] MARout;
//=============================================================================
// Internal wires declarations
//=============================================================================
wire [7:0] IB0, IB1, IB2, // 2 data busses and write-back bus
			  R0out, R1out, R2out, R3out,
			  PMout, IRout, IPDRout,
			  DMout, ALU_Result, STKout, ipstkmuxout;
wire [9:0] PCout, MABRin, MAXRin, MABRout, MAXRout, MARin;
wire [3:0] ALU_CNVZ, SRout;
//==========IntBusMux==========================================================
// data busses
cjb_nbit_mux4to1_struc_v #8 IntBus0MUX (R3out, R2out, R1out, R0out, IB0_SEL, IB0);
cjb_nbit_mux4to1_struc_v #8 IntBus1MUX (R3out, R2out, R1out, R0out, IB1_SEL, IB1);
// write-back bus
cjb_nbit_mux4to1_struc_v #8 IntBus2MUX (ipstkmuxout, DMout, ALU_Result, IB0, IB2_SEL, IB2);
//==========RF=================================================================
// These are the 4x8-bit registers of the register file
// Selectable outputs to 2 data busses
//==========RF=================================================================
cjb_nbit_reg_v #8 R0 (IB2, LD_R0, Reset, Clock, R0out);
cjb_nbit_reg_v #8 R1 (IB2, LD_R1, Reset, Clock, R1out);
cjb_nbit_reg_v #8 R2 (IB2, LD_R2, Reset, Clock, R2out);
cjb_nbit_reg_v #8 R3 (IB2, LD_R3, Reset, Clock, R3out);
//==========ALUext=============================================================
// SR and the ALU form the extended ALU
// No temporary X, Y, or Const_K registers needed due to 3-bus architecture
//==========ALUext=============================================================
//cjb_nbit_reg_v #8 TXR (IB, LD_TXR, Reset, Clock, TXRout);
//cjb_nbit_reg_v #8 TYR (IB, LD_TYR, Reset, Clock, TYRout);
//cjb_nbit_reg_v #2 TKR (IRout[1:0], LD_TK, Reset, Clock, TKout);
cjb_8bit_alu_struc_v ALU (.Func_Sel (ALU_FS), .Operand_X (IB0), .Operand_Y (IB1),
								  .Const_K (IW[1:0]), .cin (SRout[3]), // carry from SR
								  .ALU_Result (ALU_Result), .ALU_CNVZ (ALU_CNVZ));
cjb_nbit_reg_v #4 SR (ALU_CNVZ, LD_SR, Reset, Clock, SRout);
assign SR_CNVZ = SRout;
//==========PM-Interface=======================================================
// PC, PM, and IR;
// PM is driven by ~Clock to register the address and save a cycle.
//==========PM-Interface=======================================================
cjb_nbit_cntup_v #10 PC (MARout, LD_PC, RST_PC, CNT_PC, Clock, PCout);
cjb_PM_HMMIOP_v PM (PCout, ~Clock, PMout);
cjb_nbit_reg_v #8 IR (PMout, LD_IR, Reset, Clock, IRout);
assign IW = IRout;
//==========DM-Interface=======================================================
// Address arithmetic and DM;
// DM is driven by ~Clock to register the address, din, and rw and save a cycle.
//==========DM-Interface=======================================================
// cond: if instruction == JUMP
assign MABRin = (IRout[7:4] == 4'b1101) ? {PMout[7], PMout[7], PMout} : {PMout, 2'b00};
assign MAXRin = (IRout[7:4] == 4'b1101) ? PCout : {IB2[7], IB2[7], IB2};
cjb_nbit_reg_v #10 MABR (MABRin, LD_MABR, Reset, Clock, MABRout);
cjb_nbit_reg_v #10 MAXR (MAXRin, LD_MAXR, Reset, Clock, MAXRout);
assign MARin = MABRout + MAXRout;
cjb_nbit_reg_v #10 MAR (MARin, LD_MAR, Reset, ~Clock, MARout);
cjb_DM_HMMIOP_v DM (MARout, ~Clock, IB2, RW, DMout);
//==========I/O-Ps-Interface===================================================
// Input and output data registers
//==========I/O-Ps-Interface===================================================
cjb_nbit_reg_v #8 IPDR ({3'b000, PB1, SW}, LD_IPDR, Reset, Clock, IPDRout);
cjb_nbit_reg_v #8 OPDR (IB2, LD_OPDR, Reset, Clock, LEDs);
//==========HW-Stack===========================================================
// The HW-Stack and IP-Stack outputs mux; need this mux because there are now
// 5 sources for the write-back bus;
//==========HW-Stack===========================================================
cjb_nbit_4loc_stack_v #8 hwstack (push, pop, Reset, Clock, IB2, STKout);
cjb_nbit_mux2to1_struc_v #8 ipstkmux (STKout, IPDRout, ipstksel, ipstkmuxout);
//=============================================================================
endmodule
