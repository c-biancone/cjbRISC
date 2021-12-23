/*===========================================================================*/
/* The step1_syntax_check subroutine checks for the correct structure of the 
assembly source code file and for syntax errors at the beginning of each line 
of code */
/*===========================================================================*/
/* Includes stdio.lib and std.lib */
/*---------------------------------------------------------------------------*/
#include "dxp_asm.h" 
/*---------------------------------------------------------------------------*/
void step1_syntax_check(in1_fname, out1_fname, out2_fname, out3_fname, crt_im)
/*---------------------------------------------------------------------------*/
/* Parameter types declarations. */
/*---------------------------------------------------------------------------*/
	FILE *in1_fname; FILE *out1_fname; FILE *out2_fname; FILE *out3_fname;
	const	char	*crt_im[16]; /*Current Instruction Mnemonic*/
	{
/*---------------------------------------------------------------------------*/
/* Local constants and variables declarations. */
/*---------------------------------------------------------------------------*/
	char	crt_line[81];
	char	crt_syllable[20], nxt_syllable[20]; /*Temporary storage for the 
								syllables currently expected and analyzed*/
	int		asf_line_number = 0; /*assembly source file line number*/
	int		i, j, k, match;
/*---------------------------------------------------------------------------*/
/*#define dxpDEBUG - printf for debugging purposes*/
/*---------------------------------------------------------------------------*/
#define dxpDEBUG = 1;
/*---------------------------------------------------------------------------*/
/* Read the first line, which is expected to be a comment, i.e. should start with ; */	
/*---------------------------------------------------------------------------*/
	fgets(crt_line, 81, in1_fname);
#ifdef dxpDEBUG
	printf("\nParsing line %3u: %s", asf_line_number, crt_line);
#endif
	sscanf(crt_line, "%s", &crt_syllable);
	if (crt_syllable[0] == ';')
		{
#ifdef dxpDEBUG
		printf("   Line %3u is a comment ... OK!  Ignoring the rest of the line.", asf_line_number);
#endif
		}
	else
		{
#ifdef dxpDEBUG
		printf("\nExpecting line %3u to be a comment, i.e. the first character to be <;> ! \
		Ignoring the rest of the line.", asf_line_number);
#endif
		}
/*---------------------------------------------------------------------------*/
/* Read the next lines; expect more comments or the beginning of the directives segment */	
/*---------------------------------------------------------------------------*/
	i = 0;
	while ((strcmp(crt_syllable, ".directives;")) && (i != 20))
		{
		fgets(crt_line, 81, in1_fname);
		++asf_line_number;
#ifdef dxpDEBUG
		printf("\nParsing line %3u: %s", asf_line_number, crt_line);
#endif
		sscanf(crt_line, "%s", &crt_syllable);
		++i;
		if (crt_syllable[0] == ';')
			{
#ifdef dxpDEBUG
		printf("   This line seems to be a comment.  Ignoring the rest of the line.");
#endif
			}
		else if (!strcmp(crt_syllable, ".directives;"))
			{
#ifdef dxpDEBUG
		printf("   Reached the beginning of the .directives segment on line %3u.", asf_line_number);
#endif
			}
		else
			{
		printf("   Syntax Error in line %3u - expecting .directives;", asf_line_number);
			}
	} /*End of first while loop*/
/*---------------------------------------------------------------------------*/
/* Read the next lines; expect more comments, .equ directives or the end of the directives segment */
/*---------------------------------------------------------------------------*/
	i = 0;
	while ((strcmp(crt_syllable, ".enddirectives;")) && (i != 20))
		{
		fgets(crt_line, 81, in1_fname);
		++asf_line_number;
#ifdef dxpDEBUG
		printf("\nParsing line %3u: %s", asf_line_number, crt_line);
#endif
		sscanf(crt_line, "%s", &crt_syllable);
		++i;
		if (crt_syllable[0] == ';')
			{
#ifdef dxpDEBUG
		printf("   This line seems to be a comment.  Ignoring the rest of the line.");
#endif
			}
		else if (!strcmp(crt_syllable, ".equ"))
			{
#ifdef dxpDEBUG
		printf("   The beginning of this line is OK!  Saving it in the dir.txt file.");
#endif
		fprintf(out1_fname, "%3u   %s", asf_line_number, crt_line);
			}
		else if (!strcmp(crt_syllable, ".enddirectives;"))
			{
#ifdef dxpDEBUG
		printf("   Reached the end of the .directives segment on line %3u.", asf_line_number);
#endif
			}
		else
			{
		printf("   Syntax Error in line %3u - expecting .equ or ;", asf_line_number);
			}
	
	}/*End of second while loop*/
/*---------------------------------------------------------------------------*/
/* Read the next lines; expect more comments or the beginning of the .const segment */	
/*---------------------------------------------------------------------------*/
	i = 0;
	while ((strcmp(crt_syllable, ".constants;")) && (i != 20))
		{
		fgets(crt_line, 81, in1_fname);
		++asf_line_number;
#ifdef dxpDEBUG
		printf("\nParsing line %3u: %s", asf_line_number, crt_line);
#endif
		sscanf(crt_line, "%s", &crt_syllable);
		++i;
		if (crt_syllable[0] == ';')
			{
#ifdef dxpDEBUG
		printf("   This line seems to be a comment.  Ignoring the rest of the line.");
#endif
			}
		else if (!strcmp(crt_syllable, ".constants;"))
			{
#ifdef dxpDEBUG
		printf("   Reached the beginning of the .constants segment on line %3u.", asf_line_number);
#endif
			}
		else
			{
		printf("   Syntax Error in line %3u - expecting .constants;", asf_line_number);
			}
	}/*End of third while loop*/
/*---------------------------------------------------------------------------*/
/* Read the next lines; expect more comments, .word directives or the end of the .constants segment */
/*---------------------------------------------------------------------------*/
	i = 0;
	while ((strcmp(crt_syllable, ".endconstants;")) && (i != 20))
		{
		fgets(crt_line, 81, in1_fname);
		++asf_line_number;
#ifdef dxpDEBUG
		printf("\nParsing line %3u: %s", asf_line_number, crt_line);
#endif
		sscanf(crt_line, "%s", &crt_syllable);
		++i;
		if (crt_syllable[0] == ';')
			{
#ifdef dxpDEBUG
		printf("   This line seems to be a comment.  Ignoring the rest of the line.");
#endif
			}
		else if (!strcmp(crt_syllable, ".word"))
			{
#ifdef dxpDEBUG
		printf("   The beginning of this line is OK!  Saving it in the const.txt file.");
#endif
		fprintf(out2_fname, "%3u   %s", asf_line_number, crt_line);
			}
		else if (!strcmp(crt_syllable, ".endconstants;"))
			{
#ifdef dxpDEBUG
		printf("   Reached the end of the .constants segment on line %3u.", asf_line_number);
#endif
			}
		else
			{
		printf("   Syntax Error in line %3u - expecting .word or ;", asf_line_number);
			}
	
	}/*End of the fourth while loop*/
/*---------------------------------------------------------------------------*/
/* Read the next lines; expect more comments or the beginning of the .code segment */	
/*---------------------------------------------------------------------------*/
	i = 0;
	while ((strcmp(crt_syllable, ".code;")) && (i != 20))
		{
		fgets(crt_line, 81, in1_fname);
		++asf_line_number;
#ifdef dxpDEBUG
		printf("\nParsing line %3u: %s", asf_line_number, crt_line);
#endif
		sscanf(crt_line, "%s", &crt_syllable);
		++i;
		if (crt_syllable[0] == ';')
			{
#ifdef dxpDEBUG
		printf("   This line seems to be a comment.  Ignoring the rest of the line.");
#endif
			}
		else if (!strcmp(crt_syllable, ".code;"))
			{
#ifdef dxpDEBUG
		printf("   Reached the beginning of the .code segment on line %3u.", asf_line_number);
#endif
			}
		else
			{
		printf("   Syntax Error in line %3u - expecting .code;", asf_line_number);
			}
	}/*End of fifth while loop*/
/*---------------------------------------------------------------------------*/
/* Read the next lines; expect more comments, instruction mnemonics,
 or the end of the .code segment.  For debugging purposes limit this section to 100 lines. */
/*---------------------------------------------------------------------------*/
	i = 0;
/*---------------------------------------------------------------------------*/
/*While the .endcode keyboard has not been read AND 1000 lines of assembly
have not been read AND the EOF has not been reached, continue ...
/*---------------------------------------------------------------------------*/
	while ((strcmp(crt_syllable, ".endcode;")) && (i != 1000) && EOF)
		{
/*---------------------------------------------------------------------------*/
/*Read the next line - maximum 80 characters plus the EOF character.
/*---------------------------------------------------------------------------*/
		fgets(crt_line, 81, in1_fname);
		++asf_line_number;
#ifdef dxpDEBUG
		printf("\nParsing line %3u: %s", asf_line_number, crt_line);
#endif
		sscanf(crt_line, "%s %s", &crt_syllable, &nxt_syllable);
		++i; match = 0; j = 0;
/*---------------------------------------------------------------------------*/
/*Check to see if current syllable is a valid instruction mnemonic; if yes,
save the line in the code.txt file.*/
/*---------------------------------------------------------------------------*/
		while ( j < 16 ) 
			{
				if (strcmp(crt_syllable, crt_im[j]) == 0)
				{
#ifdef dxpDEBUG
	printf("   The beginning of this line is OK!  Saving it in the code.txt file.");
#endif
	fprintf(out3_fname, "%3u   %s", asf_line_number, crt_line);
	match = 1;
				}
			++j;
			}/*End of inner while loop*/
/*---------------------------------------------------------------------------*/
/*Check to see if the line starts with a label followed by a valid 
instruction mnemonic*/
/*---------------------------------------------------------------------------*/
		k = 0;
		if (crt_syllable[0] == '@')
			{
			while ( k < 16 ) 
				{
				if (strcmp(nxt_syllable, crt_im[k]) == 0)
					{
#ifdef dxpDEBUG
	printf("   The beginning of this line is OK!  Saving it in the code.txt file.");
#endif
	fprintf(out3_fname, "%3u   %s", asf_line_number, crt_line);
	match = 1;
					}
				++k;		
			}/*End of second inner while loop*/
		}/*End of if construct*/
/*---------------------------------------------------------------------------*/
/*Check to see if line is a comment - ignore it.
/*---------------------------------------------------------------------------*/
		if (crt_syllable[0] == ';')
			{
#ifdef dxpDEBUG
		printf("   This line seems to be a comment.  Ignoring the rest of the line.");
#endif
			}
		else if (!strcmp(crt_syllable, ".endcode;"))
			{
#ifdef dxpDEBUG
		printf("   Reached the end of the .code segment on line %3u.", asf_line_number);
#endif
			}
		else if (match != 1)
			{
		printf("   Syntax Error in line %3u - expecting instruction mnemonic, \
		<.label:>, <.endcode;>, or <;>", asf_line_number);
			}
	}/*End of sixth while loop*/
	fprintf(out3_fname, "\n");
	return;
}

