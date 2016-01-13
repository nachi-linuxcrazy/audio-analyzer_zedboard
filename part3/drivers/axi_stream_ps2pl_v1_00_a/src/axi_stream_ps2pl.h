/*****************************************************************************
* Filename:          C:\workspace\es6051\FINAL3\EDK\drivers/axi_stream_ps2pl_v1_00_a/src/axi_stream_ps2pl.h
* Version:           1.00.a
* Description:       axi_stream_ps2pl () Driver Header File
* Date:              Wed Nov 12 05:31:16 2014 (by Create and Import Peripheral Wizard)
*****************************************************************************/

#ifndef AXI_STREAM_PS2PL_H
#define AXI_STREAM_PS2PL_H

#include "xstatus.h"

#include "fsl.h" 
#define write_into_fsl(val, id)  putfsl(val, id)
#define read_from_fsl(val, id)  getfsl(val, id)

/*
* A macro for accessing AXI4STREAM peripheral.
*
* This example driver writes all the data in the input arguments
* into the input AXI4STREAM bus through blocking writes. AXI4STREAM peripheral will
* automatically read from the AXI4STREAM bus. Once all the inputs
* have been written, the output from the AXI4STREAM peripheral is read
* into output arguments through blocking reads.
*
* Arguments:
*	 input_slot_id
*		 Compile time constant indicating AXI4STREAM (FSL) slot from
*		 which coprocessor read the input data. Defined in
*		 xparameters.h .
*	 output_slot_id
*		 Compile time constant indicating AXI4STREAM (FSL) slot into
*		 which the coprocessor write output data. Defined in
*		 xparameters.h .
*	 input_0    An array of unsigned integers. Array size is 128
*	 output_0   An array of unsigned integers. Array size is 128
*
* Caveats:
*    The output_slot_id and input_slot_id arguments must be
*    constants available at compile time. Do not pass
*    variables for these arguments.
*
*    Since this is a macro, using it too many times will
*    increase the size of your application. In such cases,
*    or when this macro is too simplistic for your
*    application you may want to create your own instance
*    specific driver function (not a macro) using the 
*    macros defined in this file and the slot
*    identifiers defined in xparameters.h .  Please see the
*    example code (axi_stream_ps2pl_selftest.c) for details.
*/

#define  axi_stream_ps2pl(\
		 input_slot_id,\
		 output_slot_id,\
		 input_0,      \
		 output_0       \
		 )\
{\
   int i;\
\
   for (i=0; i<128; i++)\
   {\
      write_into_fsl(input_0[i], input_slot_id);\
   }\
\
   for (i=0; i<128; i++)\
   {\
      read_from_fsl(output_0[i], output_slot_id);\
   }\
}

XStatus AXI_STREAM_PS2PL_SelfTest();

#endif 
