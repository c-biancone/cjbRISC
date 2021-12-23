#include <stdio.h>
#include <stdlib.h>

/*===========================================================================*/
/* IF dxpDEBUG != 0, code segments between #if dxpDEBUG and #endif will be
compiled.  If dxpDEBUG == 0 ==> not.  Useful to eliminate printf's used for 
debugging purposes in the final release version.*/
/*===========================================================================*/
/*===========================================================================*/
/* The dxp_get_fname gets the assembly source file (asf) name, opens it,
checks if it exists, and returns the pointer to it. */
/*===========================================================================*/
FILE *dxp_get_fname();
/*===========================================================================*/
/* The step1_syntax_check subroutine checks for the correct structure of the 
assembly source code file and for syntax errors at the beginning of each line 
of code */
/*===========================================================================*/
void step1_syntax_check(FILE *in1_fname, FILE *out1_fname, FILE *out2_fname, \
			FILE *out3_fname, const char *crt_im[33]);
/*===========================================================================*/
/* The step2_assembly subroutine assembles each instrcution into the machine 
language instruction word format */
/*===========================================================================*/
void step2_assembly(FILE *int1_fname, FILE *int2_fname, \
				FILE *int3_fname, FILE *out1_fname, const char *crt_im[16], \
				const char *crt_opcode[16], \
				const char *crt_ri[4], const char *crt_rifv[4], \
				const char *crt_rj[4], const char *crt_rjfv[4], \
				const char *crt_mrj[4]);
void dxp_int2binstr(int crt_int, int str_len, char *ret_str);


