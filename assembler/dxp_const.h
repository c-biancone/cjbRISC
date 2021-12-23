/*===========================================================================*/
/*Contains the instruction mnemonic array of strings declaration and definition.*/
/*===========================================================================*/
/*The instruction mnemonic array of strings declaration*/
/*---------------------------------------------------------------------------*/
	const	char	*im[16];
/*---------------------------------------------------------------------------*/
/*The instruction mnemonic array of strings assignments*/
/*---------------------------------------------------------------------------*/
	im[0] = "ADD";	im[1] = "SUB"; 	im[2] = "INC";	im[3] = "DEC";
	im[4] = "XOR";	im[5] = "AND"; 	im[6] = "OR";	im[7] = "CPY";
	im[8] = "SHRA";	im[9] = "SHLL";	im[10] = "RRC";	im[11] = "LD";	
	im[12] = "ST";	im[13] = "JUMP"; im[14] = "POP"; im[15] = "PUSH"; //im[14] = "IN";	im[15] = "OUT"; 
/*---------------------------------------------------------------------------*/
/*The Rsd-field string array */
/*---------------------------------------------------------------------------*/
	const	char	*Rsd[4];
	Rsd[0] = "R0,"; Rsd[1] = "R1,"; Rsd[2] = "R2,"; Rsd[3] = "R3,";
/*---------------------------------------------------------------------------*/
/*The Rsd-field-value string array */
/*---------------------------------------------------------------------------*/
	const	char	*RsdFieldValue[4];
	RsdFieldValue[0] = "00"; RsdFieldValue[1] = "01"; 
	RsdFieldValue[2] = "10"; RsdFieldValue[3] = "11";
/*---------------------------------------------------------------------------*/
/*The Rs2-field string array */
/*---------------------------------------------------------------------------*/
	const	char	*Rs2[4];
	Rs2[0] = "R0;"; Rs2[1] = "R1;"; Rs2[2] = "R2;"; Rs2[3] = "R3;";
/*---------------------------------------------------------------------------*/
/*The Rs2-field-value string array */
/*---------------------------------------------------------------------------*/
	const	char	*Rs2FieldValue[4];
	Rs2FieldValue[0] = "00";	Rs2FieldValue[1] = "01"; 
	Rs2FieldValue[2] = "10";	Rs2FieldValue[3] = "11";
/*---------------------------------------------------------------------------*/
/*The mnemonic opcode string array */
/*---------------------------------------------------------------------------*/
	const	char	*OpCode[16];
OpCode[0] = "0000";	OpCode[1] = "0001"; OpCode[2] = "0010";	OpCode[3] = "0011";
OpCode[4] = "0100";	OpCode[5] = "0101"; OpCode[6] = "0110";	OpCode[7] = "0111";
OpCode[8] = "1000";	OpCode[9] = "1001";	OpCode[10] = "1010"; OpCode[11] = "1011";
OpCode[12] = "1100"; OpCode[13] = "1101"; OpCode[14] = "1110"; OpCode[15] = "1111"; 
/*---------------------------------------------------------------------------*/
/* the M[Rj-field string array */
/*---------------------------------------------------------------------------*/
	const	char	*mrj[4];
	mrj[0] = "M[R0,";
	mrj[1] = "M[R1,"; 
	mrj[2] = "M[R2,";
	mrj[3] = "M[R3,";

