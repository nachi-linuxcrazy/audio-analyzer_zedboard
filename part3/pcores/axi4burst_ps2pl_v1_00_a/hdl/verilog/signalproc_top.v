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
	output	S_O_DATA_READY,
	input		[31:0] S_I_DATA,
	// as master
	output	M_O_DATA_VALID,
	input		M_I_DATA_READY,
	output	[31:0] M_O_DATA

    );

	// wiring
	wire [31:0] wire_fft_data;
	wire wire_fft_data_valid;
	wire wire_fft_data_ready;
	
	// internal
	reg s_i_config_valid;
	wire s_o_config_ready;
	reg [15:0] s_i_config_data;
	
	//
	always @ (posedge I_CLOCK)
		begin
			if (s_o_config_ready == 1'b1) begin
				s_i_config_valid = 1'b1;
				s_i_config_data = 16'b0000000000000001;
			end
		end

	fftv8_wrapper fft(
		.aclk(I_CLOCK),
		.aresetn(I_RESETN),
	
		.s_axis_config_tdata(s_i_config_data),
		.s_axis_config_tvalid(s_i_config_valid),
		.s_axis_config_tready(s_o_config_ready),
	
		.s_axis_data_tdata(S_I_DATA),
		.s_axis_data_tvalid(S_I_DATA_VALID),
		.s_axis_data_tready(S_O_DATA_READY),
		.s_axis_data_tlast(1'b0),
	
		.m_axis_data_tdata(wire_fft_data),
		.m_axis_data_tvalid(wire_fft_data_valid),
		.m_axis_data_tready(wire_fft_data_ready),
		.m_axis_data_tlast()
	);
	
	magnitude_wrapper magnitude(
		.aclk(I_CLOCK),
		.aresetn(I_RESETN),
	
		.s_i_data_valid(wire_fft_data_valid),
		.s_o_data_ready(wire_fft_data_ready),
		.s_i_data(wire_fft_data),
		
		.m_o_data_valid(M_O_DATA_VALID),
		.m_i_data_ready(M_I_DATA_READY),
		.m_o_data(M_O_DATA)
	);

endmodule
