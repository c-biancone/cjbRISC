/*===========================================================================*/
/* The step2_assembly subroutine checks for the correct structure and syntax
of every line of the assembly source code file and assembles the machine code 
in the *.mif output file.
(c) Dorin Patru April 2021 */
/*===========================================================================*/

#include "dxp_asm.h" /* Contains stdio.lib and std.lib */
#include <string.h>
void step2_assembly(int1_fname, int2_fname, \
				int3_fname, out1_fname, crt_im, crt_opcode, \
				crt_ri, crt_rifv, crt_rj, crt_rjfv, crt_mrj)
/*---------------------------------------------------------------------------*/
/* Parameter types declarations. */
/*---------------------------------------------------------------------------*/
FILE *int1_fname; FILE *int2_fname; FILE *int3_fname; FILE	*out1_fname;
	const char *crt_im[16]; const char *crt_opcode[16]; \
	const char *crt_ri[4]; const char *crt_rifv[4]; const char *crt_rj[4]; \
	const char *crt_rjfv[4]; const char *crt_mrj[4];
	{
/*---------------------------------------------------------------------------*/
/* Local declarations:
/*---------------------------------------------------------------------------*/
	FILE	*prev_line;
	char	crt_line[81], crt_iw0[17], crt_char[6], crt_iw1_string[18];
	char	*endptr;
	int		crt_val, test, crt_mif_addrs = 0, crt_jca = 0, crt_iw1 = 0, crt_jao = 0;
/*---------------------------------------------------------------------------*/
/*Temporary storage for the syllables currently expected and analyzed*/
/*---------------------------------------------------------------------------*/
	char	first_syllable[20], second_syllable[20], \
			third_syllable[20], fourth_syllable[20], fifth_syllable[20]; 
	int		Aeff = 0, code_line_number = 0, asf_line_number = 0;
	int	i=0, j=0, k=0, match1 = 0, match2 = 0, match3 = 0, match4 = 0;
#define dxpDEBUG = 1;
#define ErrorMnemonic	printf("\nError: Unexpected mnemonic in line %3u", asf_line_number);
#define ErrorRifield	printf("\nError: Unexpected Ri field in line %3u", asf_line_number);
#define ErrorRjfieldConst	printf("\nError: Unexpected Rj field constant in line %3u", asf_line_number);
#define ErrorRjfield	printf("\nError: Unexpected Rj field in line %3u", asf_line_number);
#define ErrorJCAfield	printf("\nError: Unexpected JCA field in line %3u", asf_line_number);
#define ErrorMRjfield	printf("\nError: Unexpected MRj field in line %3u", asf_line_number);
#define ErrorCondField	printf("\nError: Unexpected Jump Condition field in line %3u", asf_line_number);
/*---------------------------------------------------------------------------*/
/*The "symbol table" for the JUMP and CALL addresses*/
/*---------------------------------------------------------------------------*/
	struct {char jca_label[20]; int jca_num;} jca[10];			
/*---------------------------------------------------------------------------*/
/* Print the header of the dxp.mif file */
/*---------------------------------------------------------------------------*/
	fprintf(out1_fname, "--Program Memory Initialization File \
	\n--Created by dxp_asm \
	\nWIDTH = 8; \
	\nDEPTH = 1024; \
	\nADDRESS_RADIX = HEX;	%% Can be HEX, BIN or DEC %% \
	\nDATA_RADIX = BIN;	%% Can be HEX, BIN or DEC %% \
	\n\nCONTENT BEGIN\n\n");
/*---------------------------------------------------------------------------*/
/* Read the code.txt file and assemble into *.mif*/
/*---------------------------------------------------------------------------*/
	while (crt_line[0] != '\n')
		{
/*---------------------------------------------------------------------------*/
/* Read the entire NEXT line from code.txt
/*---------------------------------------------------------------------------*/
		fgets(crt_line, 81, int1_fname); ++code_line_number;
		if (crt_line[0] == '\n') { printf("\nDone assembly!"); break; }
/*---------------------------------------------------------------------------*/
/* Debugging message:
/*---------------------------------------------------------------------------*/
#ifdef dxpDEBUG
		test = strlen(crt_line); printf("\nThe length is:= %3u", test);
		printf("\n\nParsing code line %3u:\n %s\n", code_line_number, crt_line);
#endif
/*---------------------------------------------------------------------------*/
/* Initialize syllables to the N/A string
/*---------------------------------------------------------------------------*/
		strcpy(first_syllable, "N/A"); strcpy(second_syllable, "N/A");
		strcpy(third_syllable, "N/A"); strcpy(fourth_syllable, "N/A");
		strcpy(fifth_syllable, "N/A");
/*---------------------------------------------------------------------------*/
/* Split the current line into parts, i.e. SYLLABLES (Words)
/*---------------------------------------------------------------------------*/
		sscanf(crt_line, "%3u %s %s %s %s %s", &asf_line_number, &first_syllable, \
		&second_syllable, &third_syllable, &fourth_syllable, &fifth_syllable);
#ifdef dxpDEBUG
		printf("\n asf_line_number is := %3u", asf_line_number);
		printf("\n \t first_syllable is := %s", first_syllable);
		printf("\n \t \t second_syllable is := %s", second_syllable);
		printf("\n \t \t \t third_syllable is := %s", third_syllable);
		printf("\n \t \t \t \t fourth_syllable is := %s", fourth_syllable);
		printf("\n \t \t \t \t \t fifth_syllable is := %s\n", fifth_syllable);
#endif
	match1 = 0;	match2 = 0; match3 = 0;	match4 = 0;	//++i;
/*===========================================================================
JUMP Label Check and Update
===========================================================================*/
	if (first_syllable[0] == '@')
		{
			strcat(first_syllable, ";");
/*---------------------------------------------------------------------------*/
/* Store the current label and associated mif file address
/*---------------------------------------------------------------------------*/
			strcpy(jca[crt_iw1].jca_label, first_syllable);
			jca[crt_iw1].jca_num = crt_mif_addrs;
			++crt_iw1;
/*---------------------------------------------------------------------------*/
/* Transfer syllables for assembly
/*---------------------------------------------------------------------------*/
			strcpy(first_syllable, second_syllable);
			strcpy(second_syllable, third_syllable);
			strcpy(third_syllable, fourth_syllable);
			strcpy(fourth_syllable, fifth_syllable);			
		}
/*===========================================================================
ADD, SUB, XOR, AND, OR, CPY
===========================================================================*/
	i = 0;
	while(i != 8)	{
		if (strcmp(first_syllable, crt_im[i]) == 0)
/*---------------------------------------------------------------------------*/
/* If the mnemonic matches concatenate the OpCode field to the IW.
/*---------------------------------------------------------------------------*/
		{ strcpy(crt_iw0, crt_opcode[i]); match1 = 1; k = 0;
/*---------------------------------------------------------------------------*/
/* Determine Rsd and concatenate to the IW, else exit with an error.
/*---------------------------------------------------------------------------*/
			while (k < 4)	{
				if (strcmp(second_syllable, crt_ri[k]) == 0)
				{ strcat(crt_iw0, crt_rifv[k]); match2 = 1; } ++k; } k = 0;
			if (match2 == 0) { ErrorRifield; break; } 
/*---------------------------------------------------------------------------*/
/* Determine Rs2 and concatenate to the IW, else exit with an error.
/*---------------------------------------------------------------------------*/
			while (k < 4) {
				if (strcmp(third_syllable, crt_rj[k]) == 0)
				{ strcat(crt_iw0, crt_rjfv[k]);	match3 = 1; } ++k; }
			if (match3 == 0) { ErrorRjfield; break; }
/*---------------------------------------------------------------------------*/
/* Printf for debugging purposes.
/*---------------------------------------------------------------------------*/
#ifdef dxpDEBUG
		printf("%04x : %s; %% %s %s %s %% \n", \
	crt_mif_addrs, crt_iw0, first_syllable, second_syllable, third_syllable);
#endif
/*---------------------------------------------------------------------------*/
/* FPrintf the IW to the *.mif file.
/*---------------------------------------------------------------------------*/
		fprintf(out1_fname, "%04x : %s; %% %s %s %s %% \n", \
	crt_mif_addrs, crt_iw0, first_syllable, second_syllable, third_syllable);
			++crt_mif_addrs;	}	
/*---------------------------------------------------------------------------*/
/* Manipulate i to skip over OpCodes 2 (INC) and 3 (DEC).
/*---------------------------------------------------------------------------*/
	if (i == 1) { i = 4; } else { ++i; }	}
/*===========================================================================
INC, DEC, SHRA, SHxL, RxC, IN or POP, OUT or PUSH
===========================================================================*/
	i = 2;
	while(i != 16)	{		
	if (strcmp(first_syllable, crt_im[i]) == 0)
/*---------------------------------------------------------------------------*/
/* If the mnemonic matches concatenate the OpCode field to the IW.
/*---------------------------------------------------------------------------*/
		{ strcpy(crt_iw0, crt_opcode[i]); match1 = 1; k = 0; 
/*---------------------------------------------------------------------------*/
/* Determine Rsd and concatenate to the IW, else exit with an error.
/*---------------------------------------------------------------------------*/
			while (k < 4)
			{ if (strcmp(second_syllable, crt_ri[k]) == 0)
				{ strcat(crt_iw0, crt_rifv[k]); match2 = 1; } ++k; }
			if (match2 == 0) { ErrorRifield; } k = 0;
/*---------------------------------------------------------------------------*/
/* Determine the value of K and concatenate to IW: read in ASCII characters,
 convert to long integer with strtol, then convert int to binary string for 
 the *mif file, and concatenate to IW; else exit with an error.
/*---------------------------------------------------------------------------*/
			crt_val = strtol(third_syllable, &endptr, 16);
			if (crt_val > 4) { ErrorRjfieldConst; break; } k = 0;
			dxp_int2binstr(crt_val, 2, crt_char); 
			strcat(crt_iw0, crt_char); 
/*---------------------------------------------------------------------------*/
/* Printf for debugging purposes.
/*---------------------------------------------------------------------------*/
#ifdef dxpDEBUG
		printf("%04x : %s; %% %s %s %s %% \n", \
	crt_mif_addrs, crt_iw0, first_syllable, second_syllable, third_syllable);
#endif
/*---------------------------------------------------------------------------*/
/* FPrintf the IW to the *.mif file.
/*---------------------------------------------------------------------------*/
		fprintf(out1_fname, "%04x : %s; %% %s %s %s %% \n", \
	crt_mif_addrs, crt_iw0, first_syllable, second_syllable, third_syllable);
		++crt_mif_addrs;	}
	if (i == 3) { i = 8; } else if (i == 10) { i = 14; } else { ++i; }	}
/*===========================================================================
LD and ST
===========================================================================*/
	i = 11;
	while(i != 13)	{ 
	if (strcmp(first_syllable, crt_im[i]) == 0)
/*---------------------------------------------------------------------------*/
/* If the mnemonic matches concatenate the OpCode field to the IW.
/*---------------------------------------------------------------------------*/
		{ strcpy(crt_iw0, crt_opcode[i]); match1 = 1; k = 0;
/*---------------------------------------------------------------------------*/
/* Determine Rsd and concatenate to the IW, else exit with an error.
/*---------------------------------------------------------------------------*/
			while (k < 4)
			{ if (strcmp(second_syllable, crt_ri[k]) == 0)
				{ strcat(crt_iw0, crt_rifv[k]); match2 = 1; } ++k; }
			if (match2 == 0) { ErrorRifield; break; } k = 0;
/*---------------------------------------------------------------------------*/
/* Determine Ra and concatenate to the IW, else exit with an error.
/*---------------------------------------------------------------------------*/
			while (k < 4)
			{ if (strcmp(third_syllable, crt_mrj[k]) == 0)
				{ strcat(crt_iw0, crt_rjfv[k]); match3 = 1;	break; } ++k; }
			if (match3 == 0) { ErrorMRjfield; break; }
/*---------------------------------------------------------------------------*/
/* Printf for debugging purposes.
/*---------------------------------------------------------------------------*/
#ifdef dxpDEBUG
		printf("%04x : %s; %% %s %s %s %% \n", \
	crt_mif_addrs, crt_iw0, first_syllable, second_syllable, third_syllable);
#endif
/*---------------------------------------------------------------------------*/
/* FPrintf the IW to the *.mif file.
/*---------------------------------------------------------------------------*/
		fprintf(out1_fname, "%04x : %s; %% %s %s %s %% \n", \
	crt_mif_addrs, crt_iw0, first_syllable, second_syllable, third_syllable);
		++crt_mif_addrs;
/*---------------------------------------------------------------------------*/
/* Determine the value of the address offset and insert into *.mif file.
/*---------------------------------------------------------------------------*/
			k = 0;
			crt_val = strtol(fourth_syllable, &endptr, 16);
			dxp_int2binstr(crt_val, 8, crt_char);
/*---------------------------------------------------------------------------*/
/* Printf for debugging purposes.
/*---------------------------------------------------------------------------*/
#ifdef dxpDEBUG
		printf("%04x : %s; %% %s %% \n", \
	crt_mif_addrs, crt_char, fourth_syllable);
#endif
/*---------------------------------------------------------------------------*/
/* FPrintf the IW to the *.mif file.
/*---------------------------------------------------------------------------*/
		fprintf(out1_fname, "%04x : %s; %% %s %% \n", \
	crt_mif_addrs, crt_char, fourth_syllable);
			++crt_mif_addrs;	} ++i; 	}
/*===========================================================================
JUMP U - unconditional, C - if C=1, N - if N=1, V - if V=1, Z - if Z=1
===========================================================================*/
		i = 13;
		if (strcmp(first_syllable, crt_im[i]) == 0)
/*---------------------------------------------------------------------------*/
/* If the mnemonic matches concatenate the OpCode field to the IW.
/*---------------------------------------------------------------------------*/
		{ strcpy(crt_iw0, crt_opcode[i]); match1 = 1; k = 0;
/*---------------------------------------------------------------------------*/
/* Determine the kind of JUMP and complete the IW.
/*---------------------------------------------------------------------------*/
	if 		(second_syllable[0] == 'U') { strcat(crt_iw0, "0000"); match2 = 1;}
	else if (second_syllable[0] == 'C') { strcat(crt_iw0, "1000"); match2 = 1;}
	else if (second_syllable[0] == 'N') { strcat(crt_iw0, "0100"); match2 = 1;}
	else if (second_syllable[0] == 'V') { strcat(crt_iw0, "0010"); match2 = 1;}
	else if (second_syllable[0] == 'Z') { strcat(crt_iw0, "0001"); match2 = 1;}
	else	{ ErrorCondField; break; }
/*---------------------------------------------------------------------------*/
/* Printf for debugging purposes.
/*---------------------------------------------------------------------------*/
#ifdef dxpDEBUG
		printf("%04x : %s; %% %s %s %% \n", \
	crt_mif_addrs, crt_iw0, first_syllable, second_syllable);
#endif
/*---------------------------------------------------------------------------*/
/* FPrintf the IW to the *.mif file.
/*---------------------------------------------------------------------------*/
		fprintf(out1_fname, "%04x : %s; %% %s %s %% \n", \
	crt_mif_addrs, crt_iw0, first_syllable, second_syllable);
		++crt_mif_addrs;
/*---------------------------------------------------------------------------*/
/* Deteremine the jump address offset relative to the current PC value.
/*---------------------------------------------------------------------------*/
	if (third_syllable[0] != '@') { ErrorJCAfield; break; }
		while (k < 10)
		{ if (strcmp(third_syllable, jca[k].jca_label) == 0)
			{ crt_jao = jca[k].jca_num - (crt_mif_addrs);
			dxp_int2binstr(crt_jao, 8, crt_char); match3 = 1; break; } ++k;	}
		if (match3 == 0) { printf("\n this is a forward jump \n"); 
											strcpy(crt_char, "xxxxxxxx"); }
/*---------------------------------------------------------------------------*/
/* Printf for debugging purposes.
/*---------------------------------------------------------------------------*/
#ifdef dxpDEBUG
		printf("%04x : %s; %% %s %% \n", \
	crt_mif_addrs, crt_char, third_syllable);
#endif
/*---------------------------------------------------------------------------*/
/* FPrintf the IW to the *.mif file.
/*---------------------------------------------------------------------------*/
		fprintf(out1_fname, "%04x : %s; %% %s %% \n", \
	crt_mif_addrs, crt_char, third_syllable);
		++crt_mif_addrs;
/* Implement here the JUMP forward */
		}
		if (match1 == 0) { ErrorMnemonic; break; }	}
/*---------------------------------------------------------------------------*/
/* Initialize the remaining locations in the *.mif file to 0.
/*---------------------------------------------------------------------------*/
		fprintf(out1_fname, \
"[ %04x .. 3FF ] : 00000000; %% Fill the remaining locations with 0 %% \n END; \n", crt_mif_addrs);	
	return;
}	

