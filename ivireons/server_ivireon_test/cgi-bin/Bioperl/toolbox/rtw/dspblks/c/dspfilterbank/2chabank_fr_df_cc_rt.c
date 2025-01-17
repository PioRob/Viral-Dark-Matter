/*
 *  2chabank_fr_df_cc_rt.c
 *
 *  Copyright 1995-2005 The MathWorks, Inc.
 *  $Revision: 1.3.2.4 $  $Date: 2005/12/22 18:29:25 $
 *
 * Please refer to dspfilterbank_rt.h
 * for comments and algorithm explanation.
 */

#include "dsp_rt.h"

#if (!defined(INTEGER_CODE) || !INTEGER_CODE) && defined(CREAL_T)

EXPORT_FCN void MWDSP_2ChABank_Fr_DF_CC(
    const creal32_T       *u,
          creal32_T       *filtLongOutputBase,
          creal32_T       *filtShortOutputBase,
          creal32_T       *tap0,
          creal32_T       *sums,
    const creal32_T *const filtLong,
    const creal32_T *const filtShort,
          int32_T         *tapIdx,
          int32_T         *phaseIdx,
    const int_T          numChans,
    const int_T          inFrameSize,
    const int_T          polyphaseFiltLenLong,
    const int_T          polyphaseFiltLenShort
)
{
    const int_T filtLenLong  = polyphaseFiltLenLong  << 1;
    const int_T outFrameSize = inFrameSize           >> 1;
    const int_T leftToDo     = polyphaseFiltLenLong - polyphaseFiltLenShort;
    const int_T dFactor      = 2;

    /* initialize local variables to rid compiler warnings */
    int_T      curPhaseIdx  = *phaseIdx;
    int_T      curTapIdx    = *tapIdx;
    int_T i, k;

    /* Each channel uses the same filter phase but accesses
     * its own state memory and input.
     */
    for (k = 0; k < numChans; k++) {

        /* make per channel copies of polyphase parameters common for
           all channels */
        const creal32_T *cffLong  = filtLong  + *phaseIdx * polyphaseFiltLenLong;
        const creal32_T *cffShort = filtShort + *phaseIdx * polyphaseFiltLenShort;
        int_T      curOutBufIdx = 0;

        curPhaseIdx  = *phaseIdx;
        curTapIdx    = *tapIdx;

        i = inFrameSize;
        while (i--) {

            /* filter current phase */
            creal32_T *mem = tap0 + curTapIdx;
            int_T    j   = polyphaseFiltLenShort;

            /* read input into TapDelayBuffer which is used by both short
               and long filters */
            *mem = *u++;

            /* perform filtering on current phase
             * process filtering with both short and long filter
             * short filter output is stored in location sums
             * long filter output is stored in location (sums+1)
             */
            while (j--) {
                sums->re  += (mem->re) * (cffShort->re) - (mem->im) * (cffShort->im);
                sums->im  += (mem->re) * (cffShort->im) + (mem->im) * (cffShort->re);
                sums++;
                cffShort++;
                sums->re  += (mem->re) * (cffLong->re) - (mem->im) * (cffLong->im);
                sums->im  += (mem->re) * (cffLong->im) + (mem->im) * (cffLong->re);
                sums--;
                cffLong++;
                if ((mem-=dFactor) < tap0) mem += filtLenLong;
            }
            /* finish filtering on long filter */
            j = leftToDo;
            sums++;     /* store long filter output in location (sums+1) */
            while (j--) {
                sums->re  += (mem->re) * (cffLong->re) - (mem->im) * (cffLong->im);
                sums->im  += (mem->re) * (cffLong->im) + (mem->im) * (cffLong->re);
                cffLong++;
                if ((mem-=dFactor) < tap0) mem += filtLenLong;
            }
            sums--;     /* restore sums pointer for short filter output */

            /* points to next TapDelayBuffer index
               (manages input circular TapDelayBuffer) */
            if ( (++curTapIdx) >= filtLenLong ) curTapIdx = 0;

            /* increment curPhaseIdx and
             * output to OutputBuffer ONLY WHEN all polyphase filters are executed
             * i.e. curPhaseIdx = dFactor
             */
            if ( (++curPhaseIdx) >= dFactor ) {

                /* calculate appropriate location for filter output */
                  creal32_T *filtShortOutput = filtShortOutputBase + curOutBufIdx;
                  creal32_T *filtLongOutput  = filtLongOutputBase  + curOutBufIdx;

                /* save *sums (short filter output) to  filtShortOutput
                 * save *(sums+1) (long filter output) to filtLongOutput
                 */
                *filtShortOutput = *sums++;
                *filtLongOutput  = *sums;

                /* reset sums to zero after transfering its content */
                sums->re  = sums->im  = 0.0f;
                sums--;
                sums->re  = sums->im  = 0.0f;

                /* reset curBufIdx and invert curBuf when finished with current frame */
                if ( (++curOutBufIdx) >= outFrameSize ) curOutBufIdx = 0;

                /* reset curPhaseIdx to zero
                   reset cffLong and cffShort to their respective base */
                curPhaseIdx = 0;
                cffLong     = filtLong;
                cffShort    = filtShort;
            }

        } /* inFrameSize */

        /* increment indices for next channel */
        filtShortOutputBase += outFrameSize;
        filtLongOutputBase  += outFrameSize;
        tap0                += filtLenLong;
        sums                += 2;

    } /* channel */

    /* save common per channel parameters for next function call */
    *phaseIdx     = curPhaseIdx;
    *tapIdx       = curTapIdx;
}

#endif /* !INTEGER_CODE && CREAL_T */

/* [EOF] 2chabank_fr_df_cc_rt.c */
