//=============================================================================
// This is the behavioral control unit (CU) module for the cjbRISC_HMMIOP.
// Specifications: three internal busses, Harvard, memory mapped I/O-Ps.
// Chris Biancone, October 2021.
//=============================================================================
module cjbRISC_HMMIOP_CU_v
	(Reset, Clock, IW, SR_CNVZ, MARout, 
	RST_PC, LD_PC, CNT_PC, LD_IR, LD_R0, LD_R1, LD_R2, LD_R3,
	LD_SR, LD_MABR, LD_MAXR, LD_MAR, RW, 
	LD_IPDR, LD_OPDR, IB0_SEL, IB1_SEL, IB2_SEL, ALU_FS, push, pop, ipstksel, crtMCis);
//=============================================================================
// Input and output ports declarations
//=============================================================================
input Reset, Clock;
input [7:0] IW;
input [3:0] SR_CNVZ;
input [9:0] MARout;
output reg RST_PC, LD_PC, CNT_PC, LD_IR, LD_R0, LD_R1, LD_R2, LD_R3,
	LD_SR, LD_MABR, LD_MAXR, LD_MAR, RW, LD_IPDR, LD_OPDR, 
	push, pop, ipstksel;
output reg [1:0] IB0_SEL, IB1_SEL, IB2_SEL;
output reg [3:0] ALU_FS;
output reg [2:0] crtMCis;
//=============================================================================
// Internal wires declarations
//=============================================================================
reg [1:0] Rsd, Rs;
reg [2:0] MC;
reg [3:0] OpCode, IW_CNVZ;
reg carry, negative, overflow, zero;
//=============================================================================
// Machine cycles and instruction cycles parameters declarations:
//=============================================================================
parameter [2:0] MC0=3'b000, MC1=3'b001, MC2=3'b010, MC3=3'b011, MC4=3'b100;
parameter [3:0] ADD_IC=4'b0000, SUB_IC=4'b0001, INC_IC=4'b0010, DEC_IC=4'b0011, 
		XOR_IC=4'b0100, AND_IC=4'b0101, OR_IC=4'b0110, CPY_IC=4'b0111, 
		SHRA_IC =4'b1000, SHRL_IC=4'b1001, RRC_IC=4'b1010, LD_IC=4'b1011, 
		ST_IC=4'b1100, JUMP_IC=4'b1101, POP_IC=4'b1110, PUSH_IC=4'b1111;
//=============================================================================
// The CU is responsible for the generation of all necessary control signals. 
// It is implemented here using behavioral description. Each executed cycle is
// uniquely identified by two pieces of information: the current instruction 
// cycle (_IC) and current machine cycle (MCx).
// ALL control signals are repeated for every relevant combination. 
// In this way, the design is simply a copy/paste of the information captured 
// in the CST and ASM Chart.
//=============================================================================

always @ (posedge Clock) begin

OpCode = IW[7:4]; Rsd = IW[3:2]; Rs = IW[1:0];
IW_CNVZ = IW[3:0]; carry = SR_CNVZ[3]; negative = SR_CNVZ[2]; 
overflow = SR_CNVZ[1]; zero = SR_CNVZ[0];

if (Reset == 1) begin 
	RST_PC = 1'b1; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC0; MC = MC0; end
else begin
	case (MC)
//=============================================================================
		MC0: begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b1; LD_IR = 1'b1; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC0; MC = MC1; end
//=============================================================================
// Need this to transfer the IW to the CU!
//=============================================================================
		MC1: begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC1; MC = MC2; end
//=============================================================================
		MC2: begin
			case (OpCode)
//-----------------------------------------------------------------------------
		ADD_IC, SUB_IC, INC_IC, DEC_IC, XOR_IC, AND_IC, OR_IC, 
		SHRA_IC, SHRL_IC, RRC_IC: begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0;
				case (Rsd)
					2'b00 : begin
	LD_R0 = 1'b1; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0; end
					2'b01 : begin
	LD_R0 = 1'b0; LD_R1 = 1'b1; LD_R2 = 1'b0; LD_R3 = 1'b0; end
					2'b10 : begin
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b1; LD_R3 = 1'b0; end
					2'b11 : begin
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b1; end
				endcase
	LD_SR = 1'b1; ALU_FS = OpCode;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	// select ALU output on writeback bus
	IB0_SEL = Rsd; IB1_SEL = Rs; IB2_SEL = 2'b01;
	crtMCis = MC2; MC = MC0; end
//----------------------------------------------------------------
		CPY_IC: begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
				case (Rsd)
					2'b00 : begin
	LD_R0 = 1'b1; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0; end
					2'b01 : begin
	LD_R0 = 1'b0; LD_R1 = 1'b1; LD_R2 = 1'b0; LD_R3 = 1'b0; end
					2'b10 : begin
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b1; LD_R3 = 1'b0; end
					2'b11 : begin
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b1; end
				endcase
	LD_SR = 1'b1; ALU_FS = OpCode;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	// select RF0 output on writeback bus, set to Rs this time to allow copy
	// to different location
	IB0_SEL = Rs; IB1_SEL = 2'b00; IB2_SEL = 2'b01;
	crtMCis = MC2; MC = MC0; end
//-----------------------------------------------------------------------------
		LD_IC: begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b1; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b1; LD_MAXR = 1'b1; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = Rs; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC2; MC = MC3; end
//-----------------------------------------------------------------------------
		ST_IC: begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b1; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b1; LD_MAXR = 1'b1; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = Rs; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC2; MC = MC3; end
//-----------------------------------------------------------------------------
		JUMP_IC: begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b1; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b1; LD_MAXR = 1'b1; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC2; MC = MC3; end
//-----------------------------------------------------------------------------
		POP_IC : begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0;
				case (Rsd)
					2'b00 : begin
	LD_R0 = 1'b1; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0; end
					2'b01 : begin
	LD_R0 = 1'b0; LD_R1 = 1'b1; LD_R2 = 1'b0; LD_R3 = 1'b0; end
					2'b10 : begin
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b1; LD_R3 = 1'b0; end
					2'b11 : begin
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b1; end
				endcase	
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b1; ipstksel = 1'b1;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; IB2_SEL = 2'b11;
	crtMCis = MC2; MC = MC0; end
//-----------------------------------------------------------------------------
		PUSH_IC : begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b1; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = Rsd; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC2; MC = MC0; end
//-----------------------------------------------------------------------------
		default: begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC2; MC = MC0; end
			endcase end
//=============================================================================
		MC3: begin
			case (OpCode)
		LD_IC : begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b1; RW = 1'b0; 
	LD_IPDR = 1'b1; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC3; MC = MC4; end
//-----------------------------------------------------------------------------
		ST_IC : begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b1; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC3; MC = MC4; end
//-----------------------------------------------------------------------------
		JUMP_IC : begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b1; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC3; MC = MC4; end
//-----------------------------------------------------------------------------
		default: begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC3; MC = MC0; end
			endcase end
//=============================================================================
		MC4: begin
			case (OpCode)
//-----------------------------------------------------------------------------
		LD_IC : begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
				case (Rsd)
					2'b00 : begin
	LD_R0 = 1'b1; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0; end
					2'b01 : begin
	LD_R0 = 1'b0; LD_R1 = 1'b1; LD_R2 = 1'b0; LD_R3 = 1'b0; end
					2'b10 : begin
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b1; LD_R3 = 1'b0; end
					2'b11 : begin
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b1; end
				endcase	
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; 
	// MARout > 10'h3FD ? IB2 <= IPDR : IB2 <= DM
		if (MARout >= 10'h3FC) 
			IB2_SEL = 2'b11; 
		else 
			IB2_SEL = 2'b10;
	crtMCis = MC4; MC = MC0; end
//-----------------------------------------------------------------------------
		ST_IC : begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0;  
	LD_IPDR = 1'b0;  push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = Rsd; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	// output case
		if (MARout >= 10'h3FC) 	
			begin RW = 1'b0; LD_OPDR = 1'b1; end 
		else 							
			begin RW = 1'b1; LD_OPDR = 1'b0; end
	crtMCis = MC4; MC = MC0; end
//-----------------------------------------------------------------------------
		JUMP_IC : begin
			case (IW_CNVZ)
	4'b0000 : begin LD_PC = 1'b1; end
	4'b1000 : begin if (carry    == 1'b1) LD_PC = 1'b1; else LD_PC = 1'b0; end
	4'b0100 : begin if (negative == 1'b1) LD_PC = 1'b1; else LD_PC = 1'b0; end
	4'b0010 : begin if (overflow == 1'b1) LD_PC = 1'b1; else LD_PC = 1'b0; end
	4'b0001 : begin if (zero     == 1'b1) LD_PC = 1'b1; else LD_PC = 1'b0; end
	default : LD_PC = 1'b0; endcase
	RST_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC4; MC = MC0; end
//-----------------------------------------------------------------------------
		default: begin
	RST_PC = 1'b0; LD_PC = 1'b0; CNT_PC = 1'b0; LD_IR = 1'b0; 
	LD_R0 = 1'b0; LD_R1 = 1'b0; LD_R2 = 1'b0; LD_R3 = 1'b0;
	LD_SR = 1'b0; ALU_FS = 4'b0000;
	LD_MABR = 1'b0; LD_MAXR = 1'b0; LD_MAR = 1'b0; RW = 1'b0; 
	LD_IPDR = 1'b0; LD_OPDR = 1'b0; push = 1'b0; pop = 1'b0; ipstksel = 1'b0;
	IB0_SEL = 2'b00; IB1_SEL = 2'b00; IB2_SEL = 2'b00;
	crtMCis = MC4; MC = MC0; end
			endcase end
	endcase end 
	end
endmodule
