/*
 * sfuntmpl_basic.c: Basic 'C' template for a level 2 S-function.
 *
 *  -------------------------------------------------------------------------
 *  | See matlabroot/simulink/src/sfuntmpl_doc.c for a more detailed template |
 *  -------------------------------------------------------------------------
 *
 * Copyright 1990-2009 The MathWorks, Inc.
 * $Revision: 1.1.6.6 $
 */


/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function
 * (i.e. replace sfuntmpl_basic with the name of your S-function).
 */

#define S_FUNCTION_NAME  sfun_user_fxp_StorageContainCatProbe
#define S_FUNCTION_LEVEL 2

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */

#include <math.h>
#include "simstruc.h"
#include "fixedpoint.h"


/* Error handling
 * --------------
 *
 * You should use the following technique to report errors encountered within
 * an S-function:
 *
 *       ssSetErrorStatus(S,"Error encountered due to ...");
 *       return;
 *
 * Note that the 2nd argument to ssSetErrorStatus must be persistent memory.
 * It cannot be a local variable. For example the following will cause
 * unpredictable errors:
 *
 *      mdlOutputs()
 *      {
 *         char msg[256];         {ILLEGAL: to fix use "static char msg[256];"}
 *         sprintf(msg,"Error due to %s", string);
 *         ssSetErrorStatus(S,msg);
 *         return;
 *      }
 *
 * See matlabroot/simulink/src/sfuntmpl_doc.c for more details.
 */

/*====================*
 * S-function methods *
 *====================*/

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{
       
    ssSetNumSFcnParams(S, 0);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        return;
    }

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

    if (!ssSetNumInputPorts(S, 1)) return;
    ssSetInputPortWidth(S, 0, 1);
    ssSetInputPortRequiredContiguous(S, 0, true); /*direct input signal access*/
    /*
     * Set direct feedthrough flag (1=yes, 0=no).
     * A port has direct feedthrough if the input is used in either
     * the mdlOutputs or mdlGetTimeOfNextVarHit functions.
     * See matlabroot/simulink/src/sfuntmpl_directfeed.txt.
     */
    
    
   if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, 14);
   
   ssSetInputPortDataType(S,0,DYNAMICALLY_TYPED);
   ssSetInputPortDirectFeedThrough(S,0,1);

   ssSetInputPortRequiredContiguous(S,0,1);
   ssSetInputPortReusable(S,0,1);
    
        
    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);

    ssSetOptions(S, 0);
    ssFxpSetU32BitRegionCompliant(S, 1);
}



/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    This function is used to specify the sample time(s) for your
 *    S-function. You must register the same number of sample times as
 *    specified in ssSetNumSampleTimes.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
    ssSetModelReferenceSampleTimeDefaultInheritance(S);
}



/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector, ssGetY(S).
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    int i;
    double *y  = ssGetOutputPortSignal(S,0);
    fxpStorageContainerCategory StorageContainerCategory;
    DTypeId dataTypeId = ssGetInputPortDataType(S,0);
    int IsFxpFltApiCompat = ssGetDataTypeIsFxpFltApiCompat(S,dataTypeId);     
    
    for (i = 0; i < 14 ; i++){
        y[i] = 0;
    }
   
    if (IsFxpFltApiCompat){
        
        y[13] = 1;
        StorageContainerCategory = ssGetDataTypeStorageContainCat(S,dataTypeId);

        switch (StorageContainerCategory) {
            
          case FXP_STORAGE_INT8:
            y[0] = 1;
            break;

          case FXP_STORAGE_UINT8:
            y[1] = 1;
            break;

          case FXP_STORAGE_INT16:
            y[2] = 1;
            break;

          case FXP_STORAGE_UINT16:
            y[3] = 1;
            break; 

          case FXP_STORAGE_INT32:
            y[4] = 1;
            break;

          case FXP_STORAGE_UINT32:
            y[5] = 1;
            break;

          case FXP_STORAGE_CHUNKARRAY:
            y[6] = 1;
            break;

          case FXP_STORAGE_OTHER_SINGLE_WORD:
            y[7] = 1;
            break;

          case FXP_STORAGE_MULTIWORD:
            y[8] = 1;
            break;

          case FXP_STORAGE_UNKNOWN:
            y[9] = 1;
            break;

          case FXP_STORAGE_SINGLE:
            y[10] = 1;
            break;

          case FXP_STORAGE_DOUBLE:
            y[11] = 1;
            break;

          case FXP_STORAGE_SCALEDDOUBLE:
            y[12] = 1;
            break;
        
        }

    }
    else
    {
        y[13] = 0;
    }

}

/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 */
static void mdlTerminate(SimStruct *S)
{
}


/*======================================================*
 * See sfuntmpl_doc.c for the optional S-function methods *
 *======================================================*/

/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#include "fixedpoint.c"
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
