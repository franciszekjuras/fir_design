
`timescale 1 ns / 1 ps

	module firMainAXI #
	(
		// Users to add parameters here
		parameter FIR_DATA_WIDTH = 14,
		parameter FIR_COEF_WIDTH = 18,
		parameter FIR_COEF_MAG = 0,
		parameter FIR_DSP_NR = 4, 
		parameter FIR_TM = 2,

		// User parmaters end

		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_ADDR_WIDTH	= 16
	)
	(
		// Users to add ports here
		input wire fir_clk,
		input wire signed [FIR_DATA_WIDTH-1 : 0] fir_in,
		output reg signed [FIR_DATA_WIDTH-1 : 0] fir_out,
		output wire [7:0] leds_out,
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

	localparam FIR_COEFS_NR = FIR_TM * FIR_DSP_NR;

	localparam ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	// Addresses' bases in 32/64 bit addressing
	localparam FIR_OFFSET_COEFS = 8;
	localparam FIR_OFFSET_DEBUG = 128;
	//reverse order xD
	localparam PROG_NAME = "_RIF";
	localparam PROG_VER = "2MT";

	//Switches:
	localparam SWITCH_CON_EST = 0;
	localparam SWITCH_FIR_EN = 1;
	localparam SWITCH_FIR_UPDATE = 2;
	localparam SWITCH_FIR_SNAP = 5;
	localparam SWITCH_FIR_DEBUG_1 = 6;
	localparam SWITCH_FIR_DEBUG_2 = 7;
	//Debug switches:

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

	// Registers connected to AXI
	//read-only
/*0*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] info_1;
/*1*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] info_2; //TODO: add extra info,
/*2*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] coefs_max_nr;
/*3*/    //reg [C_S_AXI_DATA_WIDTH-1 : 0] unused;
	//write|read
/*4*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] switches;
/*5*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] coefs_crr_nr;
/*6*/    //reg [C_S_AXI_DATA_WIDTH-1 : 0] unused;
/*7*/    //reg [C_S_AXI_DATA_WIDTH-1 : 0] unused;

	reg signed [FIR_COEF_WIDTH-1 : 0] coefs [FIR_COEFS_NR];

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
			for(idx = 0; idx < FIR_COEFS_NR; idx = idx + 1) begin
				if(idx + FIR_OFFSET_COEFS == axi_awaddr)
					coefs[idx] <= {S_AXI_WDATA[C_S_AXI_DATA_WIDTH-1],S_AXI_WDATA[FIR_COEF_WIDTH-2 : 0]};
			end

			case(axi_awaddr)
				4: switches <= S_AXI_WDATA;
				5: coefs_crr_nr <= S_AXI_WDATA;
				//6: unused <= S_AXI_WDATA;
				//7: unused <= S_AXI_WDATA;
			endcase
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
		0 : reg_data_out = info_1;
		1 : reg_data_out = info_2;
		2 : reg_data_out = coefs_max_nr;
		// 3 : reg_data_out = unused;
		4 : reg_data_out = switches;
		5 : reg_data_out = coefs_crr_nr;
		// 6 : reg_data_out = unused;
		// 7 : reg_data_out = unused;
		default : reg_data_out = 0;
		endcase
		/*IF COEFS STATUS IS NECESSARY*/
		for(idx = 0; idx < (DEBUG_LENGTH*DEBUG_DEPTH); idx = idx + 1) begin
			if(idx + FIR_OFFSET_DEBUG == axi_araddr) begin
				reg_data_out = debug_block[idx]; //WARN:sign bit might not be shifted properly
			end
		end	   
	end

	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_rdata  <= 0;
		end else begin 
			if (reg_rden)
				axi_rdata <= reg_data_out;
		end
	end    

	//-----------------------------------------------------//
	//------------------------LOGIC------------------------//
	//-----------------------------------------------------//

	//LEDS
	assign leds_out[7:0] = switches[7:0];

	//COUNTER
	localparam COUNT_WIDTH = $clog2(FIR_TM);
	wire [COUNT_WIDTH-1:0] count;

	counter #(
	.COUNT_WIDTH(COUNT_WIDTH),
	.MODULO(FIR_TM)) 
	inst_counter (
	.clk(fir_clk),
	.count(count));

	//counter connections wiring
	wire [COUNT_WIDTH-1:0] dsp_con_count [FIR_DSP_NR + 1];
	assign dsp_con_count[0] = count;


	/*---Partial sums and samples wirings---*/
	localparam SUM_WIDTH = FIR_DATA_WIDTH + FIR_COEF_MAG; /*at the end, sum is shortened by COEFMAG to XW length,
	so there is little reason to add more registers*/

	wire signed [SUM_WIDTH-1:0] dsp_con_sum [FIR_DSP_NR:0]; //+1 because of beg and end, ex: ---DSP---DSP---DSP--- || note: 3 DSPs and 4 wires
	wire signed [FIR_DATA_WIDTH-1:0] dsp_con_x [FIR_DSP_NR:0]; //same as above
	
	wire signed [SUM_WIDTH-1:0] sum_loop_end;
	wire signed [FIR_DATA_WIDTH-1:0] data_loop_end;
	/*---------------------------------------*/

	/*---Loop shift (synchronization)... and multiplexing---*/
	localparam LOOP_FEEDBACK_SYNC = FIR_TM + 1 - (FIR_DSP_NR%FIR_TM);

	shiftby #(.BY(LOOP_FEEDBACK_SYNC), .WIDTH(FIR_DATA_WIDTH))
	shift_data_loop
	(.in(dsp_con_x[FIR_DSP_NR]), .out(data_loop_end), .clk(fir_clk));

	shiftby #(.BY(LOOP_FEEDBACK_SYNC), .WIDTH(SUM_WIDTH))
	shift_sum_loop
	(.in(dsp_con_sum[FIR_DSP_NR]), .out(sum_loop_end), .clk(fir_clk));

	/*---...and samples multiplexing...---*/
	loop_multplx #(
	.COUNT_WIDTH(COUNT_WIDTH),
	.DATA_WIDTH(FIR_DATA_WIDTH)	
	) 
	inst_in_multplx (
	.count(count),
	.in(fir_in),
	.loop(data_loop_end),
	.out(dsp_con_x[0])
	);

	/*---...and sum multiplexing (with synchronization)---*/
	localparam DSP_PIPELINE_DIFF = 1; // difference in registers from samples multiplexer
	// to first summation in dsp block (so fresh sample would contribute to fresh 0 sum)
	wire [COUNT_WIDTH-1:0] sum_count;
	shiftby #(.BY(DSP_PIPELINE_DIFF), .WIDTH(COUNT_WIDTH))
	shift_sum_count 
	(.in(count), .out(sum_count), .clk(fir_clk));

	loop_multplx #(
	.COUNT_WIDTH(COUNT_WIDTH),
	.DATA_WIDTH(SUM_WIDTH)	
	) 
	inst_sum_multplx (
	.count(sum_count),
	.in(0),
	.loop(sum_loop_end),
	.out(dsp_con_sum[0])
	);
	/*--------------------------------------*/

	/*----------------------------------------------------------------------------------*/
	/*Generating fir taps (DSP blocks + shifting registers + coefficients' multiplexers)*/
	/*----------------------------------------------------------------------------------*/

	/*---Coefficients' wiring---*/

	reg signed [FIR_COEF_WIDTH-1 : 0] coefs_pack [FIR_DSP_NR][FIR_TM];
	genvar i_cp, j_cp;
	for(i_cp = 0; i_cp < FIR_DSP_NR; i_cp = i_cp + 1) begin
		for(j_cp = 0; j_cp < FIR_TM; j_cp = j_cp + 1) begin
			assign coefs_pack[i_cp][j_cp] = coefs[FIR_DSP_NR * j_cp + i_cp];
		end
	end

	wire signed [FIR_COEF_WIDTH-1 : 0] coef_crr [FIR_DSP_NR];
	/*---------------------------------------*/

	/*----------------Fir taps---------------*/
	generate
		for(genvar k = 0; k < FIR_DSP_NR; k = k + 1) begin
			firtap #(
			.XW(FIR_DATA_WIDTH),
			.COEFW(FIR_COEF_WIDTH),
			.OUTW(SUM_WIDTH),
			.SAMPLE_SHIFT(1),
			.SUM_SHIFT(1+FIR_TM)
			) inst_tap(
			.clk(fir_clk),
			.inX(dsp_con_x[k]),
			.outX(dsp_con_x[k+1]),
			.inCoef(coef_crr[k]),
			.inSum(dsp_con_sum[k]),
			.outSum(dsp_con_sum[k+1])
			);
		end
	endgenerate
	/*--------------------------------------*/

	/*---Coefficients' multiplexing---*/
	generate
		for(genvar l = 0; l < FIR_DSP_NR; l = l+1) begin
			coef_multplx #(
			.COEFW(FIR_COEF_WIDTH),
			.TM(FIR_TM),
			.CW(COUNT_WIDTH)
			) inst_coef_multplx(
			.clk(fir_clk),
			.counter_in(dsp_con_count[l]),
			.counter_out(dsp_con_count[l+1]),
			.coef_pack(coefs_pack[l]),
			.coef_out(coef_crr[l])
			);
		end
	endgenerate
	/*---------------------------------*/

	/*---Output selection and shift---*/
	reg signed [FIR_DATA_WIDTH-1:0]sum_loop_out;
	reg [SUM_WIDTH-1:0]sum_loop_out_debug;
	always @(posedge fir_clk) begin
		if(sum_count == 0)
			sum_loop_out[FIR_DATA_WIDTH-1:0] <= sum_loop_end[SUM_WIDTH-1: SUM_WIDTH - FIR_DATA_WIDTH];
	end
	/*--------------------------------*/

	/*---Fir switch on/off---*/
	always @(*)
	begin
		case (switches[SWITCH_FIR_EN])
			1'b0	:	fir_out = fir_in;
			1'b1	:	fir_out = sum_loop_out;
			default	:	fir_out = 0;
		endcase
	end
	/*-----------------------*/

	/*-----Fir info------*/
	always @(*) begin
		coefs_max_nr = FIR_COEFS_NR;
		info_1 = PROG_NAME;
		info_2 = PROG_VER; 
	end
	/*-------------------*/
	
	localparam DEBUG_DSP_STAGES = 0;
	localparam DEBUG_DSP_FIRST = 0;
	if(((DEBUG_DSP_STAGES * 3) + 2 + 1) > DEBUG_DEPTH)
		$error(1, "Fatal elab. error: DEBUG_DEPTH must be at least %d.", ((DEBUG_DSP_STAGES * 3) + 1));
	if((DEBUG_DSP_STAGES + DEBUG_DSP_FIRST) > FIR_DSP_NR)
		$error(1, "Fatal elab. error: DEBUG_DSP_STAGES + DEBUG_DSP_FIRST must be smaller or equal to FIR_DSP_NR = %d.", FIR_DSP_NR);
	// generate
	// 	for(genvar gva = 0; gva < 5; gva = gva + 1)
	// 	begin
	// 		assign debug_in[gva * 3] = dsp_con_sum[gva];
	// 		assign debug_in[(gva * 3) + 1] = dsp_con_x[gva];
	// 		assign debug_in[(gva * 3) + 2] = coef_crr[gva];
	// 	end		
	// endgenerate



	//assign debug_in[0] = dsp_con_sum[0 + DEBUG_DSP_FIRST];
	// assign debug_in[1] = dsp_con_x[0 + DEBUG_DSP_FIRST];
	// assign debug_in[2] = coef_crr[0 + DEBUG_DSP_FIRST];
	// assign debug_in[3] = dsp_con_sum[1 + DEBUG_DSP_FIRST];
	// assign debug_in[4] = dsp_con_x[1 + DEBUG_DSP_FIRST];
	// assign debug_in[5] = coef_crr[1 + DEBUG_DSP_FIRST];	
	// assign debug_in[6] = dsp_con_sum[2 + DEBUG_DSP_FIRST];
	// assign debug_in[7] = dsp_con_x[2 + DEBUG_DSP_FIRST];
	// assign debug_in[8] = coef_crr[2 + DEBUG_DSP_FIRST];	
	// assign debug_in[9] = dsp_con_sum[3 + DEBUG_DSP_FIRST];
	// assign debug_in[10] = dsp_con_x[3 + DEBUG_DSP_FIRST];
	// assign debug_in[11] = coef_crr[3 + DEBUG_DSP_FIRST];	
	// assign debug_in[12] = dsp_con_sum[4 + DEBUG_DSP_FIRST];
	// assign debug_in[13] = dsp_con_x[4 + DEBUG_DSP_FIRST];
	// assign debug_in[14] = coef_crr[4 + DEBUG_DSP_FIRST];	
	// assign debug_in[15] = dsp_con_sum[5 + DEBUG_DSP_FIRST];
	// assign debug_in[16] = dsp_con_x[5 + DEBUG_DSP_FIRST];
	// assign debug_in[17] = coef_crr[5 + DEBUG_DSP_FIRST];	
	// assign debug_in[18] = dsp_con_sum[6 + DEBUG_DSP_FIRST];
	// assign debug_in[19] = dsp_con_x[6 + DEBUG_DSP_FIRST];
	// assign debug_in[20] = coef_crr[6 + DEBUG_DSP_FIRST];	
	// assign debug_in[21] = dsp_con_sum[7 + DEBUG_DSP_FIRST];
	// assign debug_in[22] = dsp_con_x[7 + DEBUG_DSP_FIRST];
	// assign debug_in[23] = coef_crr[7 + DEBUG_DSP_FIRST];	
	// assign debug_in[24] = dsp_con_sum[8 + DEBUG_DSP_FIRST];
	// assign debug_in[25] = dsp_con_x[8 + DEBUG_DSP_FIRST];
	// assign debug_in[26] = coef_crr[8 + DEBUG_DSP_FIRST];	
	// assign debug_in[27] = dsp_con_sum[9 + DEBUG_DSP_FIRST];
	// assign debug_in[28] = dsp_con_x[9 + DEBUG_DSP_FIRST];
	// assign debug_in[29] = coef_crr[9 + DEBUG_DSP_FIRST];
	// assign debug_in[30] = dsp_con_sum[10 + DEBUG_DSP_FIRST];

	assign debug_in[0] = fir_in;
	assign debug_in[(DEBUG_DSP_STAGES*3)+1] = sum_loop_end;
	assign debug_in[(DEBUG_DSP_STAGES*3)+2] = sum_loop_out;
	//assign debug_in[(DEBUG_DSP_STAGES*3)+3] = fir_in;


	/////////////////////


	// User logic ends

	localparam DEBUG_LENGTH = 100;
	localparam DEBUG_DEPTH = 3;

	wire [C_S_AXI_DATA_WIDTH-1:0] debug_in [DEBUG_DEPTH];
	reg [C_S_AXI_DATA_WIDTH-1:0] debug [DEBUG_DEPTH][DEBUG_LENGTH];
	wire [C_S_AXI_DATA_WIDTH-1:0] debug_block [DEBUG_LENGTH*DEBUG_DEPTH];

	reg fir_snap; 
	xpm_cdc_single fir_snap_cdc (
		.src_clk(S_AXI_ACLK),
		.src_in(switches[SWITCH_FIR_SNAP]),
		.dest_clk(fir_clk),
		.dest_out(fir_snap)
	);

	genvar m, n;
	generate
		for(m = 0; m < DEBUG_DEPTH; m = m + 1)
		begin
			always @(posedge fir_clk)
			begin
				if(fir_snap)
				begin
					debug[m][0] <= debug_in[m];
					for(int k = 1; k < DEBUG_LENGTH; k = k + 1) begin
			            debug[m][k] <= debug[m][k-1];
			        end
			    end
			end
			for(n = 0; n < DEBUG_LENGTH; n = n + 1)
			begin
				assign debug_block[n+(DEBUG_LENGTH*m)] = debug[m][n];
			end
		end		
	endgenerate



	endmodule