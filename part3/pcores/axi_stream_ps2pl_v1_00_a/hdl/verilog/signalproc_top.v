`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:55:20 11/04/2014 
// Design Name: 
// Module Name:    signalproc_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module signalproc_top(
	input		I_CLOCK,
	input		I_RESETN,
	// as slave
	input		S_I_DATA_VALID,
	output		S_O_DATA_READY,
	input		[31:0] S_I_DATA,
	input		S_I_DATA_TLAST,
	// as master
	output		M_O_DATA_VALID,
	input		M_I_DATA_READY,
	output		[31:0] M_O_DATA,
	output		M_O_DATA_TLAST

    );

	// wiring
	
	
	fftv8_wrapper fft(
		.aclk(I_CLOCK),
		.aresetn(I_RESETN),
	
		.s_axis_data_tdata(S_I_DATA),
		.s_axis_data_tvalid(S_I_DATA_VALID),
		.s_axis_data_tready(S_O_DATA_READY),
		.s_axis_data_tlast(S_I_DATA_TLAST),
	
		.m_axis_data_tdata(M_O_DATA),
		.m_axis_data_tvalid(M_O_DATA_VALID),
		.m_axis_data_tready(M_I_DATA_READY),
		.m_axis_data_tlast(M_O_DATA_TLAST)
	);
	

endmodule
