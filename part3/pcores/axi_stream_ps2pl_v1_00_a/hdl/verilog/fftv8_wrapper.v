`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:27:16 11/04/2014 
// Design Name: 
// Module Name:    fftv8_wrapper 
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
module fftv8_wrapper(
	input		aclk,
	input		aresetn,
	
	input		[31:0] s_axis_data_tdata,
	input		s_axis_data_tvalid,
	output		s_axis_data_tready,
	input		s_axis_data_tlast,
	
	output		[31:0] m_axis_data_tdata,
	output		m_axis_data_tvalid,
	input		m_axis_data_tready,
	output		m_axis_data_tlast
	);

	// wire up the FFT output for later to assign to wrapper's output
	wire wire_s_axis_data_tready;
	wire [31:0] wire_m_axis_data_tdata;
	wire wire_m_axis_data_tvalid;
	wire wire_m_axis_data_tlast;
	
	// loop back from ready to valid
	wire wire_axis_config_valid2ready;
	
	// instantiate FFT IP Core
	fftv8_fixp16_scaled fft (
		.aclk(aclk), // input aclk
		.aresetn(aresetn), // input aresetn
		
		.s_axis_config_tdata(16'b0000000000000001), // input [15 : 0] s_axis_config_tdata
		.s_axis_config_tvalid(wire_axis_config_valid2ready), // input s_axis_config_tvalid
		.s_axis_config_tready(wire_axis_config_valid2ready), // output s_axis_config_tready
		
		.s_axis_data_tdata(s_axis_data_tdata), // input [31 : 0] s_axis_data_tdata
		.s_axis_data_tvalid(s_axis_data_tvalid), // input s_axis_data_tvalid
		.s_axis_data_tready(wire_s_axis_data_tready), // output s_axis_data_tready
		.s_axis_data_tlast(s_axis_data_tlast),
		
		.m_axis_data_tdata(wire_m_axis_data_tdata), // output [31 : 0] m_axis_data_tdata
		.m_axis_data_tvalid(wire_m_axis_data_tvalid), // output m_axis_data_tvalid
		.m_axis_data_tready(m_axis_data_tready), // input m_axis_data_tready
		.m_axis_data_tlast(wire_m_axis_data_tlast),
		
		.event_frame_started(), // output event_frame_started
		.event_tlast_unexpected(), // output event_tlast_unexpected
		.event_tlast_missing(), // output event_tlast_missing
		.event_status_channel_halt(), // output event_status_channel_halt
		.event_data_in_channel_halt(), // output event_data_in_channel_halt
		.event_data_out_channel_halt() // output event_data_out_channel_halt
	);
	
	// assign the wired output as wrapper's output
	assign	s_axis_data_tready = wire_s_axis_data_tready;
	assign	m_axis_data_tdata = wire_m_axis_data_tdata;
	assign	m_axis_data_tvalid = wire_m_axis_data_tvalid;
	assign	m_axis_data_tlast = wire_m_axis_data_tlast;
	
endmodule
