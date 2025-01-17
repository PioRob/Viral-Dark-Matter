/* MWDSP_Sort_Ins_Val_S32 Function to sort an input array of real
 * int32_Tfor Sort block in Signal Processing Blockset
 *
 *  Implement Insertion sort-by-value algorithm
 *
 *  Copyright 1995-2005 The MathWorks, Inc.
 *  $Revision: 1.1.6.3 $  $Date: 2005/12/22 18:33:44 $
 */

#include "dspsrt_rt.h"

/* insertion sort in-place by value */
EXPORT_FCN void MWDSP_Sort_Ins_Val_S32(int32_T *a, int_T n )
{
    int32_T t0 = a[0];
    int_T i;
    for (i=1; i<n; i++) {
        int32_T t1 = a[i];
        if (t0 > t1) {
            int_T j;
            a[i] = t0;
            for (j=i-1; j>0; j--) {
                int32_T t2 = a[j-1];
                if (t2 > t1) {
                    a[j] = t2;
                } else {
                    break;
                }
            }
            a[j] = t1;
        } else {
            t0 = t1;
        }
    }
}

/* [EOF] */
