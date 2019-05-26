
`timescale 1 ns / 1 ps

	module firMainAXI #
	(
		// Users to add parameters here
		parameter FIR_DSP_NR = 40, 
		parameter TM = 16,
		parameter INPUT_DATA_WIDTH = 14,
		parameter OUTPUT_DATA_WIDTH = 14,
		parameter FIR_COEF_WIDTH = 18,
		parameter FIR_COEF_MAG = 17,
		parameter SRC_COEF_WIDTH = 18,
		parameter SRC_COEF_MAG = 17,
		parameter SRC_DSP_NR = 10,
		parameter FIR_IN_WIDTH_EXT = 0,
		parameter UPSAMP_IN_WIDTH_EXT = 0,
		// User parmaters end

		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_ADDR_WIDTH	= 16
	)
	(
		// Users to add ports here
		input wire flt_clk,
		input wire signed [INPUT_DATA_WIDTH-1 : 0] flt_in,
		output reg signed [OUTPUT_DATA_WIDTH-1 : 0] flt_out,
		output wire [7:0] axi_leds,
		// User ports ends
		
		input wire  S_AXI_ACLK,
		input wire  S_AXI_ARESETN,
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		input wire [2 : 0] S_AXI_AWPROT,
		input wire  S_AXI_AWVALID,
		output wire  S_AXI_AWREADY,
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		input wire  S_AXI_WVALID,
		output wire  S_AXI_WREADY,
		output wire [1 : 0] S_AXI_BRESP,
		output wire  S_AXI_BVALID,
		input wire  S_AXI_BREADY,
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		input wire [2 : 0] S_AXI_ARPROT,
		input wire  S_AXI_ARVALID,
		output wire  S_AXI_ARREADY,
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		output wire [1 : 0] S_AXI_RRESP,
		output wire  S_AXI_RVALID,
		input wire  S_AXI_RREADY
	);
	
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits addressing
	// ADDR_LSB = 3 for 64 bits addressing

	// Widths:
	localparam DWSAMP_DATA_WIDTH = INPUT_DATA_WIDTH;
	localparam FIR_DATA_WIDTH = DWSAMP_DATA_WIDTH + FIR_IN_WIDTH_EXT;
	localparam UPSAMP_DATA_WIDTH = FIR_DATA_WIDTH + UPSAMP_IN_WIDTH_EXT;

	localparam FIR_COEFS_NR = TM * FIR_DSP_NR;
	localparam SRC_COEFS_NR = TM * SRC_DSP_NR;

	localparam ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam BRAM_ADDR_WIDTH = 9;
	localparam DSP_ADDR_WIDTH = C_S_AXI_ADDR_WIDTH - BRAM_ADDR_WIDTH - ADDR_LSB; //22-9-2=11
	// Addresses' bases in 32/64 bit addressing
	localparam FIR_COEFS_BASE = 1;
	localparam UPSAMP_COEFS_BASE = 256;
	localparam DWSAMP_COEFS_BASE = 320;
	localparam FIR_DEBUG_OFFSET = 32;
	//reverse order xD
	localparam PROG_NAME = " RIF";
	localparam PROG_VER = "12.3";
	localparam PROG_STAT = "VED ";

	//Switches:
	localparam SWITCH_CON_EST = 0;
	localparam SWITCH_FIR_EN = 1;
	localparam SWITCH_FIR_SNAP = 5;

	integer idx;

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH - ADDR_LSB -1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH - ADDR_LSB -1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;
	wire	 reg_rden;
	wire	 reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	reg	 aw_en;

	// I/O Connections assignments
	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;

	// addr separation
	wire [DSP_ADDR_WIDTH-1:0] axi_dsp_addr;
	reg [BRAM_ADDR_WIDTH-1:0] axi_bram_addr;
	reg signed [FIR_COEF_WIDTH-1:0] fir_coef_datain;
	reg signed [SRC_COEF_WIDTH-1:0] src_coef_datain;
	reg fir_bram_en [FIR_DSP_NR];
	reg ups_bram_en [SRC_DSP_NR];
	reg dws_bram_en [SRC_DSP_NR];

	assign axi_dsp_addr = axi_awaddr[BRAM_ADDR_WIDTH+DSP_ADDR_WIDTH-1:BRAM_ADDR_WIDTH];
	always @( posedge S_AXI_ACLK ) begin
		axi_bram_addr <= axi_awaddr[BRAM_ADDR_WIDTH-1:0];
	end

	always @( posedge S_AXI_ACLK ) begin
		fir_coef_datain <= {S_AXI_WDATA[C_S_AXI_DATA_WIDTH-1],S_AXI_WDATA[FIR_COEF_WIDTH-2:0]};
	end
	always @( posedge S_AXI_ACLK ) begin
		src_coef_datain <= {S_AXI_WDATA[C_S_AXI_DATA_WIDTH-1],S_AXI_WDATA[SRC_COEF_WIDTH-2:0]};
	end
	

	// Registers connected to AXI

/*20*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] axi_switches;
/*21*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] fir_coef_crrnr;
/*23*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] dbg_axi_write_address;
/*24*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] dbg_axi_write_data;

	reg signed [FIR_COEF_WIDTH-1 : 0] dbg_fir_coefs [1*TM]; //debug

	/*Dozen of boring AXI4-lite procedures*/
	always @( posedge S_AXI_ACLK ) begin
	if ( S_AXI_ARESETN == 1'b0 ) begin
		axi_awready <= 1'b0;
		aw_en <= 1'b1;
		end else begin    
		if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
			axi_awready <= 1'b1;
			aw_en <= 1'b0;
			end else if (S_AXI_BREADY && axi_bvalid) begin
				aw_en <= 1'b1;
				axi_awready <= 1'b0;
			end else begin
				axi_awready <= 1'b0;
			end
		end 
	end       

	always @( posedge S_AXI_ACLK )begin
		if ( S_AXI_ARESETN == 1'b0 )
			axi_awaddr <= 0;
		else begin    
			if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
				axi_awaddr <= S_AXI_AWADDR[C_S_AXI_ADDR_WIDTH-1 : ADDR_LSB];
		end 
	end       

	always @( posedge S_AXI_ACLK )begin
		if ( S_AXI_ARESETN == 1'b0 )
			axi_wready <= 1'b0;
		else begin    
			if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en) 
				axi_wready <= 1'b1;
			else
				axi_wready <= 1'b0;
		end 
	end       

	assign reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	//-----------------------------------------------------//
	//--------------------WRITE MAPPING--------------------//
	//-----------------------------------------------------//

	always @( posedge S_AXI_ACLK ) begin: write_data
		if (reg_wren & S_AXI_ARESETN) begin
			dbg_axi_write_address <= axi_awaddr;
			dbg_axi_write_data <= S_AXI_WDATA;
			for(idx = 0; idx < FIR_DSP_NR; idx = idx + 1) begin
				if(idx + FIR_COEFS_BASE == axi_dsp_addr)
					fir_bram_en[idx] <= 1'b1;
			end

			for(idx = 0; idx < SRC_DSP_NR; idx = idx + 1) begin
				if(idx + UPSAMP_COEFS_BASE == axi_dsp_addr)
					ups_bram_en[idx] <= 1'b1;
			end

			for(idx = 0; idx < SRC_DSP_NR; idx = idx + 1) begin
				if(idx + DWSAMP_COEFS_BASE == axi_dsp_addr)
					dws_bram_en[idx] <= 1'b1;
			end

			case(axi_awaddr)
				20: axi_switches <= S_AXI_WDATA;
				21: fir_coef_crrnr <= S_AXI_WDATA;
			endcase
		end else begin
			for(idx = 0; idx < FIR_DSP_NR; idx = idx + 1) begin
				fir_bram_en[idx] <= 1'b0;
			end
			for(idx = 0; idx < SRC_DSP_NR; idx = idx + 1) begin
				ups_bram_en[idx] <= 1'b0;
				dws_bram_en[idx] <= 1'b0;
			end
		end
	end    

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_bvalid  <= 0;
			axi_bresp   <= 2'b0;
		end else begin    
			if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID) begin
				axi_bvalid <= 1'b1;
				axi_bresp  <= 2'b0; // 'OKAY' response 
			end else begin
				if (S_AXI_BREADY && axi_bvalid)
					axi_bvalid <= 1'b0; 
			end
		end
	end   

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_arready <= 1'b0;
			axi_araddr  <= 32'b0;
		end else begin    
			if (~axi_arready && S_AXI_ARVALID) begin
				axi_arready <= 1'b1;
				axi_araddr  <= S_AXI_ARADDR[C_S_AXI_ADDR_WIDTH-1 : ADDR_LSB];
			end else begin
				axi_arready <= 1'b0;
			end
		end 
	end

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_rvalid <= 0;
			axi_rresp  <= 0;
		end else begin    
			if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
				axi_rvalid <= 1'b1;
				axi_rresp  <= 2'b0; // 'OKAY' response
			end else if (axi_rvalid && S_AXI_RREADY) begin
				axi_rvalid <= 1'b0;
			end                
		end
	end 

	//-----------------------------------------------------//
	//---------------------READ MAPPING--------------------//
	//-----------------------------------------------------//

	assign reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	always @(*)
	begin
		// Address decoding for reading registers
		case ( axi_araddr )
		0 : reg_data_out = PROG_NAME;
		1 : reg_data_out = PROG_VER;
		2 : reg_data_out = PROG_STAT;

		4 : reg_data_out = FIR_COEFS_NR;
		5 : reg_data_out = SRC_COEFS_NR;
		//6 : reg_data_out = SRC_COEFS_NR;

		8 : reg_data_out = TM;
		9 : reg_data_out = FIR_DSP_NR;
		10: reg_data_out = SRC_DSP_NR; //ups
		//11: reg_data_out = SRC_DSP_NR; //dws

		12: reg_data_out = FIR_COEF_MAG;
		13: reg_data_out = SRC_COEF_MAG;

		16: reg_data_out = FIR_COEFS_BASE;
		17: reg_data_out = UPSAMP_COEFS_BASE;
		18: reg_data_out = DWSAMP_COEFS_BASE;
		19: reg_data_out = BRAM_ADDR_WIDTH;

		20 : reg_data_out = axi_switches;
		21 : reg_data_out = fir_coef_crrnr;
		22 : reg_data_out = dbg_axi_write_address;
		23 : reg_data_out = dbg_axi_write_data;

		24 : reg_data_out = FIR_DEBUG_OFFSET;

		default : reg_data_out = 0;
		endcase
		// debug
		for(idx = 0; idx < (1*TM); idx = idx + 1) begin
			if(idx + FIR_DEBUG_OFFSET == axi_araddr) begin
				reg_data_out = dbg_fir_coefs[idx];
			end
		end	   
		// debug end
	end

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_rdata  <= 0;
		end else begin 
			if (reg_rden)
				axi_rdata <= reg_data_out;
		end
	end    
	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
	/*------------------------------------------------------------*/
	/*---------------------------LOGIC----------------------------*/
	/*------------------------------------------------------------*/
	/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

	//LEDS
	assign axi_leds[7:0] = axi_switches[7:0];

	localparam DSP_SHIFT = 2; //time shift between dsp blocks
	localparam COEF_MULTPLX_LATENCY = 2;
	localparam MULT_IN_LATENCY = 1;
	localparam ACC_IN_LATENCY = 1;

	/*------------------------------------------------------------*/
	/*------------------------FIR COUNTER-------------------------*/
	/*------------------------------------------------------------*/

	localparam COUNT_WIDTH = $clog2(TM);

	wire [COUNT_WIDTH-1:0] flt_count;
	counter #(
	.COUNT_WIDTH(COUNT_WIDTH),
	.MODULO(TM)) 
	flt_count_inst (
	.clk(flt_clk),
	.count(flt_count));


	/*------------------------------------------------------------*/
	/*------------------------DOWNSAMPLER-------------------------*/
	/*------------------------------------------------------------*/

	reg signed [DWSAMP_DATA_WIDTH-1:0] dws_in;
	always @(posedge flt_clk) begin
			dws_in <= flt_in;
	end

	/*---Partial sums and samples wirings---*/
	localparam DWSAMP_SUM_WIDTH = DWSAMP_DATA_WIDTH + SRC_COEF_MAG; /*at the end, sum is shortened by COEFMAG to XW length,
	so there is little reason to add more registers*/
	wire signed [DWSAMP_SUM_WIDTH-1:0] dws_sum_con [SRC_DSP_NR:0]; //+1 because of beg and end, ex: ---DSP---DSP---DSP--- || note: 3 DSPs and 4 wires
	wire signed [DWSAMP_DATA_WIDTH-1:0] dws_sample_con [SRC_DSP_NR:0]; //same as above
	wire signed [SRC_COEF_WIDTH-1 : 0] dws_coef_crr [SRC_DSP_NR];
	//starting pipeline values
	assign dws_sample_con[0] = dws_in;
	assign dws_sum_con[0] = 0;

	
	/*-----------------------------------------------------------*/
	/*Generating downsampler taps (DSP blocks + shifting registers)*/
	/*-----------------------------------------------------------*/


	/*----------------Downsampler taps---------------*/
	generate
		for(genvar k = 0; k < SRC_DSP_NR; k = k + 1) begin
			firtap #(
			.XW(DWSAMP_DATA_WIDTH),
			.COEFW(SRC_COEF_WIDTH),
			.OUTW(DWSAMP_SUM_WIDTH),
			.SAMPLE_SHIFT(DSP_SHIFT+TM),
			.SUM_SHIFT(DSP_SHIFT)
			) dws_tap_inst(
			.clk(flt_clk),
			.inX(dws_sample_con[k]),
			.outX(dws_sample_con[k+1]),
			.inCoef(dws_coef_crr[k]),
			.inSum(dws_sum_con[k]),
			.outSum(dws_sum_con[k+1])
			);
		end
	endgenerate
	/*--------------------------------------*/

	/*---Coefficients' multiplexing---*/
	wire [COUNT_WIDTH-1:0] dws_coef_count;
		assign dws_coef_count = flt_count;

	wire [COUNT_WIDTH-1:0] dws_coef_count_con [SRC_DSP_NR + 1];
		assign dws_coef_count_con[0] = dws_coef_count;

	generate
		for(genvar s = 0; s < SRC_DSP_NR; s = s+1) begin
			coef_multplx #(
			.COEFW(SRC_COEF_WIDTH),
			.AW(BRAM_ADDR_WIDTH),
			.TM(TM),
			.CW(COUNT_WIDTH),
			.COUNT_SHIFT(DSP_SHIFT) //should be equal to min(SAMPLE_SHIFT, SUM_SHIFT)
			) dws_coef_multplx_inst(
			.clkw(S_AXI_ACLK),
			.clkr(flt_clk),
			.counter_in(dws_coef_count_con[s]),
			.counter_out(dws_coef_count_con[s+1]),
			.coef_write(src_coef_datain),
			.coef_write_addr(axi_bram_addr),
			.coef_write_en(dws_bram_en[s]),
			.coef_out(dws_coef_crr[s])
			);
		end
	endgenerate

	/*---Downsampler output---*/
	wire [COUNT_WIDTH-1:0] dws_endacc_count;
	localparam DWS_ENDACC_LATENCY = COEF_MULTPLX_LATENCY + MULT_IN_LATENCY; //(3)
	shiftby #(.BY(DWS_ENDACC_LATENCY), .WIDTH(COUNT_WIDTH))
	dws_endacc_count_shift
	(.in(dws_coef_count_con[SRC_DSP_NR]), .out(dws_endacc_count), .clk(flt_clk));

	wire signed [DWSAMP_SUM_WIDTH-1:0] dws_endacc_in;
	wire signed [DWSAMP_SUM_WIDTH-1:0] dws_endacc_loop;
	wire signed [DWSAMP_SUM_WIDTH-1:0] dws_endacc_out;

	assign dws_endacc_in = dws_sum_con[SRC_DSP_NR];

	loop_multplx #(
	.COUNT_WIDTH(COUNT_WIDTH),
	.DATA_WIDTH(DWSAMP_SUM_WIDTH)	
	) 
	dws_endacc_multplx_inst (
	.count(dws_endacc_count),
	.in(0),
	.loop(dws_endacc_out),
	.out(dws_endacc_loop)
	);


	ADDSUB_MACRO #(
	.DEVICE("7SERIES"),
	.LATENCY(1),//0-2
	.WIDTH(DWSAMP_SUM_WIDTH)
	// Input / output bus width, 1-48
	) dws_endacc_inst (
	.RESULT(dws_endacc_out),
	.A(dws_endacc_in),
	.ADD_SUB(1'b1),
	.B(dws_endacc_loop),
	.CARRYIN(1'b0),
	.CE(1'b1),
	.CLK(flt_clk),
	.RST(1'b0)
	);

	reg signed [DWSAMP_SUM_WIDTH-1:0] dws_out;

	always @(posedge flt_clk) begin
		if(dws_endacc_count == 0)
			dws_out <= dws_endacc_out;
	end

	/*------------------------------------------------------------*/
	/*------------------------MAIN FILTER-------------------------*/
	/*------------------------------------------------------------*/

	wire signed [FIR_DATA_WIDTH-1:0] fir_in;
	assign fir_in = dws_out[DWSAMP_SUM_WIDTH-1:DWSAMP_SUM_WIDTH-FIR_DATA_WIDTH];
	//counter connections wiring

	wire [COUNT_WIDTH-1:0] fir_coef_count;
	assign fir_coef_count = flt_count;
	wire [COUNT_WIDTH-1:0] fir_sample_count;
	shiftby #(.BY(COEF_MULTPLX_LATENCY), .WIDTH(COUNT_WIDTH)) fir_sample_count_shift
	(.in(fir_coef_count), .out(fir_sample_count), .clk(flt_clk));

	wire [COUNT_WIDTH-1:0] fir_coef_count_con [FIR_DSP_NR + 1];
	assign fir_coef_count_con[0] = fir_coef_count;


	/*---Partial sums and samples wirings---*/ 
	localparam FIR_SUM_WIDTH = FIR_DATA_WIDTH + FIR_COEF_MAG; /*at the end, sum is shortened by COEFMAG to XW length,
	so there is little reason to add more registers*/

	wire signed [FIR_SUM_WIDTH-1:0] fir_sum_con [FIR_DSP_NR:0]; //+1 because of beg and end, ex: ---DSP---DSP---DSP--- || note: 3 DSPs and 4 wires
	wire signed [FIR_DATA_WIDTH-1:0] fir_sample_con [FIR_DSP_NR:0]; //same as above
	
	wire signed [FIR_SUM_WIDTH-1:0] fir_sum_loopend;
	wire signed [FIR_DATA_WIDTH-1:0] fir_sample_loopend;
	/*---------------------------------------*/

	/*----Loop shift (synchronization)----*/
	localparam LOOP_FEEDBACK_SYNC = TM + 1 - ((DSP_SHIFT*FIR_DSP_NR)%TM);

	shiftby #(.BY(LOOP_FEEDBACK_SYNC), .WIDTH(FIR_DATA_WIDTH))
	fir_sample_loop_sync
	(.in(fir_sample_con[FIR_DSP_NR]), .out(fir_sample_loopend), .clk(flt_clk));

	shiftby #(.BY(LOOP_FEEDBACK_SYNC), .WIDTH(FIR_SUM_WIDTH))
	fir_sum_loop_sync
	(.in(fir_sum_con[FIR_DSP_NR]), .out(fir_sum_loopend), .clk(flt_clk));

	/*---...and samples multiplexing...---*/

	loop_multplx #(
	.COUNT_WIDTH(COUNT_WIDTH),
	.DATA_WIDTH(FIR_DATA_WIDTH)	
	) 
	fir_in_multplx_inst (
	.count(fir_sample_count),
	.in(fir_in),
	.loop(fir_sample_loopend),
	.out(fir_sample_con[0])
	);

	/*---...and sum multiplexing----------*/

	localparam DSP_PIPELINE_DIFF = MULT_IN_LATENCY; // difference in registers from samples multiplexer
	// to first summation in fir block (so fresh sample would contribute to fresh 0 sum)
	wire [COUNT_WIDTH-1:0] fir_sum_count;
	shiftby #(.BY(DSP_PIPELINE_DIFF), .WIDTH(COUNT_WIDTH))
	fir_sum_count_shift 
	(.in(fir_sample_count), .out(fir_sum_count), .clk(flt_clk));

	loop_multplx #(
	.COUNT_WIDTH(COUNT_WIDTH),
	.DATA_WIDTH(FIR_SUM_WIDTH)	
	) 
	fir_sum_multplx_inst (
	.count(fir_sum_count),
	.in(0),
	.loop(fir_sum_loopend),
	.out(fir_sum_con[0])
	);
	/*--------------------------------------*/

	/*----------------------------------------------------------------------------------*/
	/*Generating fir taps (DSP blocks + shift registers + coefficients' multiplexers)*/
	/*----------------------------------------------------------------------------------*/

	/*---Coefficients' wiring---*/
	wire signed [FIR_COEF_WIDTH-1 : 0] fir_coef_crr [FIR_DSP_NR];
	/*---------------------------------------*/

	/*----------------Fir taps---------------*/
	generate
		for(genvar k = 0; k < FIR_DSP_NR; k = k + 1) begin
			firtap #(
			.XW(FIR_DATA_WIDTH),
			.COEFW(FIR_COEF_WIDTH),
			.OUTW(FIR_SUM_WIDTH),
			.SAMPLE_SHIFT(DSP_SHIFT+TM),
			.SUM_SHIFT(DSP_SHIFT)
			) fir_tap_inst(
			.clk(flt_clk),
			.inX(fir_sample_con[k]),
			.outX(fir_sample_con[k+1]),
			.inCoef(fir_coef_crr[k]),
			.inSum(fir_sum_con[k]),
			.outSum(fir_sum_con[k+1])
			);
		end
	endgenerate
	/*--------------------------------------*/

	/*---Coefficients' multiplexing---*/
	generate
		for(genvar l = 0; l < FIR_DSP_NR; l = l+1) begin
			coef_multplx #(
			.COEFW(FIR_COEF_WIDTH),
			.AW(BRAM_ADDR_WIDTH),
			.TM(TM),
			.CW(COUNT_WIDTH),
			.COUNT_SHIFT(DSP_SHIFT) //should be equal to min(SAMPLE_SHIFT, SUM_SHIFT)
			) fir_coef_multplx_inst(
			.clkw(S_AXI_ACLK),
			.clkr(flt_clk),
			.counter_in(fir_coef_count_con[l]),
			.counter_out(fir_coef_count_con[l+1]),
			.coef_write(fir_coef_datain),
			.coef_write_addr(axi_bram_addr),
			.coef_write_en(fir_bram_en[l]),
			.coef_out(fir_coef_crr[l])
			);
		end
	endgenerate

	/*---------------------------------*/

	/*---FIR output---*/

	reg signed [FIR_SUM_WIDTH-1:0] fir_out;

	always @(posedge flt_clk) begin
		if(fir_sum_count == 0)
			fir_out <= fir_sum_loopend;//[FIR_SUM_WIDTH-1: FIR_SUM_WIDTH - UPSAMP_DATA_WIDTH];
	end

	/*------------------------------------------------------------*/
	/*-------------------------UPSAMPLER--------------------------*/
	/*------------------------------------------------------------*/

	wire [COUNT_WIDTH-1:0] ups_coef_count;
	assign ups_coef_count = flt_count;

	wire [COUNT_WIDTH-1:0] ups_sample_count;
	shiftby #(.BY(COEF_MULTPLX_LATENCY-1), .WIDTH(COUNT_WIDTH)) //-1 because of synchronous ups_in assignment
	ups_sample_count_shift
	(.in(ups_coef_count), .out(ups_sample_count), .clk(flt_clk));

	reg signed [UPSAMP_DATA_WIDTH-1:0] ups_in;
	always @(posedge flt_clk) begin
		if(ups_sample_count == 0)
			ups_in <= fir_out[FIR_SUM_WIDTH-1: FIR_SUM_WIDTH - UPSAMP_DATA_WIDTH];
	end

	/*---Partial sums and samples wirings---*/
	localparam UPSAMP_SUM_WIDTH = UPSAMP_DATA_WIDTH + SRC_COEF_MAG; /*at the end, sum is shortened by COEFMAG to XW length,
	so there is little reason to add more registers*/
	wire signed [UPSAMP_SUM_WIDTH-1:0] ups_sum_con [SRC_DSP_NR:0]; //+1 because of beg and end, ex: ---DSP---DSP---DSP--- || note: 3 DSPs and 4 wires
	wire signed [UPSAMP_DATA_WIDTH-1:0] ups_sample_con [SRC_DSP_NR:0]; //same as above
	wire signed [SRC_COEF_WIDTH-1 : 0] ups_coef_crr [SRC_DSP_NR];
	//starting pipeline values
	assign ups_sample_con[0] = ups_in;
	assign ups_sum_con[0] = 0;

	
	/*-----------------------------------------------------------*/
	/*Generating upsampler taps (DSP blocks + shifting registers)*/
	/*-----------------------------------------------------------*/



	/*----------------Upsampler taps---------------*/
	generate
		for(genvar k = 0; k < SRC_DSP_NR; k = k + 1) begin
			firtap #(
			.XW(UPSAMP_DATA_WIDTH),
			.COEFW(SRC_COEF_WIDTH),
			.OUTW(UPSAMP_SUM_WIDTH),
			.SAMPLE_SHIFT(DSP_SHIFT+TM),
			.SUM_SHIFT(DSP_SHIFT)
			) ups_tap_inst(
			.clk(flt_clk),
			.inX(ups_sample_con[k]),
			.outX(ups_sample_con[k+1]),
			.inCoef(ups_coef_crr[k]),
			.inSum(ups_sum_con[k]),
			.outSum(ups_sum_con[k+1])
			);
		end
	endgenerate
	/*--------------------------------------*/

	/*---Coefficients' multiplexing---*/

	wire [COUNT_WIDTH-1:0] ups_coef_count_con [SRC_DSP_NR + 1];
		assign ups_coef_count_con[0] = ups_coef_count;

	generate
		for(genvar t = 0; t < SRC_DSP_NR; t = t+1) begin
			coef_multplx #(
			.COEFW(SRC_COEF_WIDTH),
			.AW(BRAM_ADDR_WIDTH),
			.TM(TM),
			.CW(COUNT_WIDTH),
			.COUNT_SHIFT(DSP_SHIFT) //should be equal to min(SAMPLE_SHIFT, SUM_SHIFT)
			) ups_coef_multplx_inst(
			.clkw(S_AXI_ACLK),
			.clkr(flt_clk),
			.counter_in(ups_coef_count_con[t]),
			.counter_out(ups_coef_count_con[t+1]),
			.coef_write(src_coef_datain),
			.coef_write_addr(axi_bram_addr),
			.coef_write_en(ups_bram_en[t]),
			.coef_out(ups_coef_crr[t])
			);
		end
	endgenerate

	/*---Upsampler output---*/
	wire signed [UPSAMP_SUM_WIDTH-1:0] ups_out;
	assign ups_out = ups_sum_con[SRC_DSP_NR]; 


	/*------------------------------------------------------------*/
	/*----------------------FILTER OUTPUT-------------------------*/
	/*------------------------------------------------------------*/

	/*---Filter switch on/off---*/
	always @(*)
	begin
		case (axi_switches[SWITCH_FIR_EN])
			1'b0	:	flt_out = flt_in; //may cause overload if flt_in is wider than flt_out
			1'b1	:	flt_out = ups_out[UPSAMP_SUM_WIDTH-1: UPSAMP_SUM_WIDTH - OUTPUT_DATA_WIDTH];
			default	:	flt_out = 0;
		endcase
	end
	/*-----------------------*/

	//debug

	always @(posedge flt_clk) begin
		for(idx = 0; idx < TM; idx = idx + 1) begin
			if(axi_switches[SWITCH_FIR_SNAP] && (idx == fir_sum_count)) begin
				dbg_fir_coefs[idx] <= flt_in;
			end
		end
	end

endmodule
