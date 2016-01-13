//----------------------------------------------------------------------------
// axi_stream_ps2pl - module
//----------------------------------------------------------------------------
// IMPORTANT:
// DO NOT MODIFY THIS FILE EXCEPT IN THE DESIGNATED SECTIONS.
//
// SEARCH FOR --USER TO DETERMINE WHERE CHANGES ARE ALLOWED.
//
// TYPICALLY, THE ONLY ACCEPTABLE CHANGES INVOLVE ADDING NEW
// PORTS AND GENERICS THAT GET PASSED THROUGH TO THE INSTANTIATION
// OF THE USER_LOGIC ENTITY.
//----------------------------------------------------------------------------
//
// ***************************************************************************
// ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
// **                                                                       **
// ** Xilinx, Inc.                                                          **
// ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
// ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
// ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
// ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
// ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
// ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
// ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
// ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
// ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
// ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
// ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
// ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
// ** FOR A PARTICULAR PURPOSE.                                             **
// **                                                                       **
// ***************************************************************************
//
//----------------------------------------------------------------------------
// Filename:          axi_stream_ps2pl
// Version:           1.00.a
// Description:       Example Axi Streaming core (Verilog).
// Date:              Wed Nov 12 05:31:16 2014 (by Create and Import Peripheral Wizard)
// Verilog Standard:  Verilog-2001
//----------------------------------------------------------------------------
// Naming Conventions:
//   active low signals:                    "*_n"
//   clock signals:                         "clk", "clk_div#", "clk_#x"
//   reset signals:                         "rst", "rst_n"
//   generics:                              "C_*"
//   user defined types:                    "*_TYPE"
//   state machine next state:              "*_ns"
//   state machine current state:           "*_cs"
//   combinatorial signals:                 "*_com"
//   pipelined or register delay signals:   "*_d#"
//   counter signals:                       "*cnt*"
//   clock enable signals:                  "*_ce"
//   internal version of output port:       "*_i"
//   device pins:                           "*_pin"
//   ports:                                 "- Names begin with Uppercase"
//   processes:                             "*_PROCESS"
//   component instantiations:              "<ENTITY_>I_<#|FUNC>"
//----------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
//
//
// Definition of Ports
// ACLK              : Synchronous clock
// ARESETN           : System reset, active low
// S_AXIS_TREADY  : Ready to accept data in
// S_AXIS_TDATA   :  Data in 
// S_AXIS_TLAST   : Optional data in qualifier
// S_AXIS_TVALID  : Data in is valid
// M_AXIS_TVALID  :  Data out is valid
// M_AXIS_TDATA   : Data Out
// M_AXIS_TLAST   : Optional data out qualifier
// M_AXIS_TREADY  : Connected slave device is ready to accept data out
//
////////////////////////////////////////////////////////////////////////////////

//----------------------------------------
// Module Section
//----------------------------------------
module axi_stream_ps2pl 
	(
		// ADD USER PORTS BELOW THIS LINE 
		// -- USER ports added here 
		// ADD USER PORTS ABOVE THIS LINE 

		// DO NOT EDIT BELOW THIS LINE ////////////////////
		// Bus protocol ports, do not add or delete. 
		ACLK,
		ARESETN,
		S_AXIS_TREADY,
		S_AXIS_TDATA,
		S_AXIS_TLAST,
		S_AXIS_TVALID,
		M_AXIS_TVALID,
		M_AXIS_TDATA,
		M_AXIS_TLAST,
		M_AXIS_TREADY
		// DO NOT EDIT ABOVE THIS LINE ////////////////////
	);

// ADD USER PORTS BELOW THIS LINE 
// -- USER ports added here 
// ADD USER PORTS ABOVE THIS LINE 

input                                     ACLK;
input                                     ARESETN;
output                                    S_AXIS_TREADY;
input      [31 : 0]                       S_AXIS_TDATA;
input                                     S_AXIS_TLAST;
input                                     S_AXIS_TVALID;
output                                    M_AXIS_TVALID;
output     [31 : 0]                       M_AXIS_TDATA;
output                                    M_AXIS_TLAST;
input                                     M_AXIS_TREADY;

// ADD USER PARAMETERS BELOW THIS LINE 
// --USER parameters added here 
// ADD USER PARAMETERS ABOVE THIS LINE


signalproc_top signalproc(
	.I_CLOCK(ACLK),
	.I_RESETN(ARESETN),
	// as slave
	.S_I_DATA_VALID(S_AXIS_TVALID),
	.S_O_DATA_READY(S_AXIS_TREADY),
	.S_I_DATA(S_AXIS_TDATA),
	.S_I_DATA_TLAST(S_AXIS_TLAST),
	// as master
	.M_O_DATA_VALID(M_AXIS_TVALID),
	.M_I_DATA_READY(M_AXIS_TREADY),
	.M_O_DATA(M_AXIS_TDATA),
	.M_O_DATA_TLAST(M_AXIS_TLAST)

    );

endmodule
