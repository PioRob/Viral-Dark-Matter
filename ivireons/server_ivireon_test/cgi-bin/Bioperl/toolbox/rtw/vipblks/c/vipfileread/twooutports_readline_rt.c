/*
*  TWOOUTPORTS_READLINE_RT runtime function for VIPBLKS Read Binary File block
*
*  Copyright 1995-2007 The MathWorks, Inc.
*  $Revision: 1.1.6.1 $  $Date: 2009/03/30 23:47:53 $
*/
#include "vipfileread_rt.h"
#include <stdio.h>

EXPORT_FCN boolean_T MWVIP_twoOutports_ReadLine(void *fptrDW,
							 uint8_T *portAddr_1,
							 uint8_T *portAddr_2,
							 int32_T   *numLoops,
							 boolean_T *eofflag, 
							 int_T rows, 
							 int_T cols)
{
    int_T j;
    FILE **fptr = (FILE **) fptrDW;
	byte_T *portAddr1 = (byte_T *)portAddr_1;
	byte_T *portAddr2 = (byte_T *)portAddr_2;

	int_T rowsj = 0;
    for (j=0; j < cols; j++) {
        fread(&portAddr1[rowsj], 1, 1, fptr[0]);
        fread(&portAddr2[rowsj], 1, 1, fptr[0]);
        if (feof(fptr[0])) {
            numLoops[0]--;
            rewind(fptr[0]);
            eofflag[0] = 1;
            return 0;
        }
        rowsj  += rows;
    }
    return 1;
}

/* [EOF] twooutports_readline_rt.c */