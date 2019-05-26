`timescale 1ns / 1ps

module loop_multplx
	#(parameter COUNT_WIDTH = 1, DATA_WIDTH = 32)
	(
	input wire [COUNT_WIDTH-1:0] count,
	input wire [DATA_WIDTH-1:0] in,
	input wire [DATA_WIDTH-1:0] loop,
	output reg [DATA_WIDTH-1:0] out
	);
	
	integer idx;
	
	always @(*)
	begin
		if(count == 0)
			out = in;
		else
			out = loop;
	end

endmodule
