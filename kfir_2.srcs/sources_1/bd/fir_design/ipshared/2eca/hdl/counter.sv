`timescale 1ns / 1ps

module counter
	#(parameter COUNT_WIDTH = 1, MODULO = 2)
	(
		input wire clk,
		output wire [COUNT_WIDTH-1:0] count
	);
	if(2**COUNT_WIDTH < MODULO)
		$fatal(2,"Fatal elab. error: invalid parameters values 2^%d < %d in counter", COUNT_WIDTH, MODULO);
	
	reg [COUNT_WIDTH-1:0] icount = 0;
	assign count = icount;
	
	always @(posedge clk) 
	begin
		if(icount == MODULO - 1)
			icount <= 32'b0;
		else
			icount <= icount + 1;
	end
endmodule