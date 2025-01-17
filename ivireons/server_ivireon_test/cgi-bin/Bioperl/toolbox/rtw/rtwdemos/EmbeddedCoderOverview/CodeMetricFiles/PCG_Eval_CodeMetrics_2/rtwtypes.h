/* Copyright 2007 The MathWorks, Inc. */
/*
 * File: rtwtypes.h
 *
 * Definitions required by Real-Time Workshop generated code.
 *
 * Real-Time Workshop version: 6.6
 * Generated on: 2007-02-01 11:58:59
 */

#ifndef __RTWTYPES_H__
#define __RTWTYPES_H__
#ifndef TRUE
# define TRUE                          (1U)
#endif

#ifndef FALSE
# define FALSE                         (0U)
#endif

#ifndef __TMWTYPES__
#define __TMWTYPES__
#include <limits.h>

/*=======================================================================*
 * Target hardware information
 *   Device type: 32-bit Embedded Processor
 *   Number of bits:     char:   8    short:   16    int:  32
 *                       long:  32      native word size:  32
 *   Byte ordering: Unspecified
 *   Signed integer division rounds to: Undefined
 *   Shift right on a signed integer as arithmetic shift: on
 *=======================================================================*/

/*=======================================================================*
 * Fixed width word size data types:                                     *
 *   int8_T, int16_T, int32_T     - signed 8, 16, or 32 bit integers     *
 *   uint8_T, uint16_T, uint32_T  - unsigned 8, 16, or 32 bit integers   *
 *   real32_T, real64_T           - 32 and 64 bit floating point numbers *
 *=======================================================================*/
typedef signed char int8_T;
typedef unsigned char uint8_T;
typedef short int16_T;
typedef unsigned short uint16_T;
typedef int int32_T;
typedef unsigned int uint32_T;
typedef float real32_T;
typedef double real64_T;

/*===========================================================================*
 * Generic type definitions: real_T, time_T, boolean_T, char_T, int_T,       *
 *                           uint_T and byte_T.                              *
 *===========================================================================*/
typedef double real_T;
typedef double time_T;
typedef unsigned char boolean_T;
typedef int int_T;
typedef unsigned int uint_T;
typedef char char_T;
typedef char_T byte_T;

/*=======================================================================*
 * Min and Max:                                                          *
 *   int8_T, int16_T, int32_T     - signed 8, 16, or 32 bit integers     *
 *   uint8_T, uint16_T, uint32_T  - unsigned 8, 16, or 32 bit integers   *
 *=======================================================================*/
#define MAX_int8_T                     ((int8_T)(127))
#define MIN_int8_T                     ((int8_T)(-128))
#define MAX_uint8_T                    ((uint8_T)(255U))
#define MIN_uint8_T                    ((uint8_T)(0U))
#define MAX_int16_T                    ((int16_T)(32767))
#define MIN_int16_T                    ((int16_T)(-32768))
#define MAX_uint16_T                   ((uint16_T)(65535U))
#define MIN_uint16_T                   ((uint16_T)(0U))
#define MAX_int32_T                    ((int32_T)(2147483647))
#define MIN_int32_T                    ((int32_T)(-2147483647-1))
#define MAX_uint32_T                   ((uint32_T)(0xFFFFFFFFU))
#define MIN_uint32_T                   ((uint32_T)(0U))

/* Logical type definitions */
#if !defined(__cplusplus) && !defined(__true_false_are_keywords)
# ifndef false
# define false                         (0U)
# endif

# ifndef true
# define true                          (1U)
# endif
#endif

/*
 * Real-Time Workshop assumes the code is compiled on a target using a 2's compliment representation
 * for signed integer values.
 */
#if ((SCHAR_MIN + 1) != -SCHAR_MAX)
#error "This code must be compiled using a 2's complement representation for signed integer values"
#endif

/*
 * Maximum length of a MATLAB identifier (function/variable/model)
 * including the null-termination character. Referenced by
 * rt_logging.c and rt_matrx.c.
 */
#define TMW_NAME_LENGTH_MAX            64

/* This ID is used to detect inclusion of an incompatible rtwtypes.h */
#define RTWTYPES_ID_C08S16I32L32N32F1
#else                                  /* __TMWTYPES__ */
#define TMWTYPES_PREVIOUSLY_INCLUDED
#endif                                 /* __TMWTYPES__ */

/* Block D-Work pointer type */
typedef void * pointer_T;

/* Simulink specific types */
#ifndef __SIMSTRUC_TYPES_H__
#define __SIMSTRUC_TYPES_H__

/* States of an enabled subsystem */
typedef enum {
  SUBSYS_DISABLED = 0,
  SUBSYS_ENABLED = 2,
  SUBSYS_BECOMING_DISABLED = 4,
  SUBSYS_BECOMING_ENABLED = 8,
  SUBSYS_TRIGGERED = 16
} CondStates;

/* Trigger directions: falling, either, and rising */
typedef enum {
  FALLING_ZERO_CROSSING = -1,
  ANY_ZERO_CROSSING = 0,
  RISING_ZERO_CROSSING = 1
} ZCDirection;

/* Previous state of a trigger signal */
typedef enum {
  NEG_ZCSIG = -1,
  ZERO_ZCSIG = 0,
  POS_ZCSIG = 1,
  ZERO_RISING_EV_ZCSIG = 100,          /* zero and had a rising event  */
  ZERO_FALLING_EV_ZCSIG = 101,         /* zero and had a falling event */
  UNINITIALIZED_ZCSIG = INT_MAX
} ZCSigState;

/* Current state of a trigger signal */
typedef enum {
  FALLING_ZCEVENT = -1,
  NO_ZCEVENT = 0,
  RISING_ZCEVENT = 1
} ZCEventType;

/* Enumeration of built-in data types */
typedef enum {
  SS_DOUBLE = 0,                       /* real_T    */
  SS_SINGLE = 1,                       /* real32_T  */
  SS_INT8 = 2,                         /* int8_T    */
  SS_UINT8 = 3,                        /* uint8_T   */
  SS_INT16 = 4,                        /* int16_T   */
  SS_UINT16 = 5,                       /* uint16_T  */
  SS_INT32 = 6,                        /* int32_T   */
  SS_UINT32 = 7,                       /* uint32_T  */
  SS_BOOLEAN = 8                       /* boolean_T */
} BuiltInDTypeId;

#define SS_NUM_BUILT_IN_DTYPE          ((int_T)SS_BOOLEAN+1)

typedef int_T DTypeId;

#endif                                 /* __SIMSTRUC_TYPES_H__ */
#endif                                 /* __RTWTYPES_H__ */
