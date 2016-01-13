`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:39:35 11/04/2014 
// Design Name: 
// Module Name:    magnitude_wrapper 
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
module magnitude_wrapper(
	input aclk,
	input aresetn,
	
	input s_i_data_valid,
	output reg s_o_data_ready,
	input [31:0] s_i_data,
	
	output reg m_o_data_valid,
	input m_i_data_ready,
	output reg [31:0] m_o_data
    );

	// internal
	reg [31:0] o_data_temp;
	//reg start_calc;
	reg [15:0] data_real;
	reg [15:0] data_imag;
	//handshake
	reg start_calc;
	reg ack_calc;
	
	//*** MAGNITUDE ***
	always @ (posedge aclk)
		begin
			if (aresetn == 0) begin
				//m_o_data_valid = 1'b0;
				s_o_data_ready = 1'b0;
				start_calc = 1'b0;
			end
			
			if (ack_calc == 1'b1) begin
				start_calc = 0;
			end
			
			if ( (s_i_data_valid == 1'b1) && (ack_calc == 0)) begin
			
				// tell data is not valid since still need processing
				//m_o_data_valid = 1'b0;
								
				// assign to register, for operation
				//o_data_temp
				data_real = s_i_data[15:0];
				data_imag = s_i_data[31:16];
				// If directly use pair of Imag- and Real-part to calculate magnitude, ...
				// somehow may resulting in negative magnitude. Probably because "*" operation think it operates on unsigned items, ...
				// while negative item is very big (if casting to unsigned).
				// So to avoid the "fake negative result", just convert any negative in Imag- or Real-part to positive first, ...
				// by using "the two's complement".
				// This working since we don't care about Imag-/Real-part strangeness, onle care the correctness of Magnitude-part.
				if (data_real[15] == 1'b1) begin
					data_real = ~data_real + 16'd1;
				end
				if (data_imag[15] == 1'b1) begin
					data_imag = ~data_imag + 16'd1;
				end
				
				// hold the input
				s_o_data_ready = 1;
				
				// signal to start the calc
				start_calc = 1'b1;
			end
		end
	
	always @ (posedge aclk)
		begin
			if (aresetn == 0) begin
				ack_calc = 0;
			end
			
			if (start_calc == 1'b1) begin
				ack_calc = 1;
				
				//process
				o_data_temp = data_real*data_real + data_imag*data_imag;
				
			end
			else begin
				ack_calc = 0;
			end
		
		end

/*
	always @ (*)
		begin
				
			if (m_i_data_ready == 1'b1) begin
			
				// be with or without averaging, o_data_temp is always the value to be returned
				m_o_data = o_data_temp;
				
				// tell the data output is ready
				m_o_data_valid = 1'b1;
				
			end			
		end
*/

	always @ (posedge aclk)
		begin
			if (aresetn == 0) begin
				m_o_data_valid = 1'b0;
			end
			if (m_i_data_ready == 1'b1) begin
				if (ack_calc == 0) begin
					// output is not ready
					m_o_data_valid = 1'b0;
				end
				else begin
					// output is ready
					m_o_data_valid = 1'b1;
					m_o_data = o_data_temp;
				end
			end
		end

endmodule
