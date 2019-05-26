`timescale 1ns / 1ps

module coef_multplx
	#(parameter COEFW = 18, AW = 7, TM = 2, CW = 1, COUNT_SHIFT = 2)
	(
	input wire clkw,
	input wire clkr,
	input wire [CW-1:0] counter_in,
	output reg [CW-1:0] counter_out,
	input wire signed [COEFW-1:0] coef_write,
	input wire [AW-1:0] coef_write_addr,
	input wire coef_write_en,
	output wire signed [COEFW-1:0] coef_out
    );
	
	localparam AWEXT = 10-AW;
	localparam AREXT = 10-CW;
	
	BRAM_SDP_MACRO #(
	.BRAM_SIZE("18Kb"), 
	.DEVICE("7SERIES"),
	.WRITE_WIDTH(COEFW),
	// Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
	.READ_WIDTH(COEFW),
	// Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
	.DO_REG(1),
	.INIT_FILE ("NONE"),
	.SIM_COLLISION_CHECK ("ALL"),
	.WRITE_MODE("WRITE_FIRST")
	) coef_bram_inst (
	.DO(coef_out),
	.DI(coef_write),
	.RDADDR({{AREXT{1'b0}},counter_in}), // Input read address, width defined by read port depth
	.RDCLK(clkr),
	.RDEN(1'b1),
	.REGCE(1'b1),
	.RST(1'b0),
	.WE(4'b1111),
	.WRADDR({{AWEXT{1'b0}}, coef_write_addr}),
	.WRCLK(clkw),
	.WREN(coef_write_en)
	);

	shiftby #(.BY(COUNT_SHIFT), .WIDTH(CW))
	shift_sum_count 
	(.in(counter_in), .out(counter_out), .clk(clkr));

endmodule
