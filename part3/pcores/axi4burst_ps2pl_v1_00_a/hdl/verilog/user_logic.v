//----------------------------------------------------------------------------
// user_logic.v - module
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
// Filename:          user_logic.v
// Version:           1.00.a
// Description:       User logic module.
// Date:              Thu Oct 30 13:06:24 2014 (by Create and Import Peripheral Wizard)
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

module user_logic
(
  // -- ADD USER PORTS BELOW THIS LINE ---------------
  // --USER ports added here 
  // -- ADD USER PORTS ABOVE THIS LINE ---------------

  // -- DO NOT EDIT BELOW THIS LINE ------------------
  // -- Bus protocol ports, do not add to or delete 
  Bus2IP_Clk,                     // Bus to IP clock
  Bus2IP_Resetn,                  // Bus to IP reset
  Bus2IP_Addr,                    // Bus to IP address bus
  Bus2IP_CS,                      // Bus to IP chip select for user logic memory selection
  Bus2IP_RNW,                     // Bus to IP read/not write
  Bus2IP_Data,                    // Bus to IP data bus
  Bus2IP_BE,                      // Bus to IP byte enables
  Bus2IP_RdCE,                    // Bus to IP read chip enable
  Bus2IP_WrCE,                    // Bus to IP write chip enable
  Bus2IP_Burst,                   // Bus to IP burst-mode qualifier
  Bus2IP_BurstLength,             // Bus to IP burst length
  Bus2IP_RdReq,                   // Bus to IP read request
  Bus2IP_WrReq,                   // Bus to IP write request
  IP2Bus_AddrAck,                 // IP to Bus address acknowledgement
  IP2Bus_Data,                    // IP to Bus data bus
  IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
  IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
  IP2Bus_Error,                   // IP to Bus error response
  Type_of_xfer                    // Transfer Type
  // -- DO NOT EDIT ABOVE THIS LINE ------------------
); // user_logic

// -- ADD USER PARAMETERS BELOW THIS LINE ------------
// --USER parameters added here 
// -- ADD USER PARAMETERS ABOVE THIS LINE ------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol parameters, do not add to or delete
parameter C_SLV_AWIDTH                   = 32;
parameter C_SLV_DWIDTH                   = 32;
parameter C_NUM_MEM                      = 1;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

// -- ADD USER PORTS BELOW THIS LINE -----------------
// --USER ports added here 
// -- ADD USER PORTS ABOVE THIS LINE -----------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol ports, do not add to or delete
input                                     Bus2IP_Clk;
input                                     Bus2IP_Resetn;
input      [C_SLV_AWIDTH-1 : 0]           Bus2IP_Addr;
input      [C_NUM_MEM-1 : 0]              Bus2IP_CS;
input                                     Bus2IP_RNW;
input      [C_SLV_DWIDTH-1 : 0]           Bus2IP_Data;
input      [C_SLV_DWIDTH/8-1 : 0]         Bus2IP_BE;
input      [C_NUM_MEM-1 : 0]              Bus2IP_RdCE;
input      [C_NUM_MEM-1 : 0]              Bus2IP_WrCE;
input                                     Bus2IP_Burst;
input      [7 : 0]                        Bus2IP_BurstLength;
input                                     Bus2IP_RdReq;
input                                     Bus2IP_WrReq;
output                                    IP2Bus_AddrAck;
output     reg [C_SLV_DWIDTH-1 : 0]           IP2Bus_Data;
output    reg                             IP2Bus_RdAck;
output                                    IP2Bus_WrAck;
output                                    IP2Bus_Error;
output                                    Type_of_xfer;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------
// Write Input
wire write_valid;

// Read output
wire read_valid;
wire output_data_valid;

// Output data from FFT
wire [31:0] output_data;

// Write and Read Acknowledgement signals
assign write_valid =   Bus2IP_CS & ~Bus2IP_RNW;
assign read_valid   =   Bus2IP_CS & Bus2IP_RNW;

// Address Acknowledgement signal
assign IP2Bus_AddrAck   =   Bus2IP_RdReq|Bus2IP_WrReq;
assign IP2Bus_Error     =   1'b0;  

// To drive output data every clock signal
always @(posedge Bus2IP_Clk)
begin
    if(read_valid & output_data_valid & ~IP2Bus_RdAck)
    begin
        IP2Bus_Data    <= output_data;
        IP2Bus_RdAck   <= 1'b1;
    end  
    else
        IP2Bus_RdAck   <= 1'b0;    
end


// Instantiate your top_wrapper module
signalproc_top signalproc(
	.I_CLOCK(Bus2IP_Clk),
	.I_RESETN(Bus2IP_Resetn),
	// as slave
	.S_I_DATA_VALID(write_valid),
	.S_O_DATA_READY(IP2Bus_WrAck),
	.S_I_DATA(Bus2IP_Data),
	// as master
	.M_O_DATA_VALID(output_data_valid),
	.M_I_DATA_READY(read_valid & ~IP2Bus_RdAck),
	.M_O_DATA(output_data)

    );	

endmodule
