
`timescale 1 ns / 1 ps

	module firMainAXI #
	(
		// Users to add parameters here
		parameter FIR_DATA_WIDTH = 32,
		parameter FIR_COEF_WIDTH = 18,
		parameter FIR_COEF_MAG = 16,
        parameter FIR_DSP_NR = 32, 
        // User parmaters end

		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_ADDR_WIDTH	= 16
    )
	(
		// Users to add ports here
        input wire fir_clk,
        input wire [FIR_DATA_WIDTH-1 : 0] fir_in,
        output reg [FIR_DATA_WIDTH-1 : 0] fir_out,
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

    localparam ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	// Addresses' bases in 32/64 bit addressing
	localparam FIR_OFFSET_COEFS = 8;
	localparam FIR_OFFSET_SAMPLES = 128;
	//reverse order xD
	localparam PROG_NAME = "_RIF";
	localparam PROG_VER = "2MT";

	//Switches:
	localparam SWITCH_CON_EST = 0;
	localparam SWITCH_FIR_EN = 1;
	localparam SWITCH_FIR_UPDATE = 2;
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

	reg signed [FIR_COEF_WIDTH-1 : 0] coefs [FIR_DSP_NR-1 : 0];

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
			for(idx = 0; idx < FIR_DSP_NR; idx = idx + 1) begin
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
		// for(idx = 0; idx < FIR_DSP_NR; idx = idx + 1) begin
		// 	if(idx + FIR_OFFSET_COEFS == axi_araddr) begin
		// 		reg_data_out = coefs[idx]; //WARN:sign bit might not be shifted properly
		// 	end
		// end	   
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

	//Combinational
	assign leds_out[7:0] = switches[7:0];
	/////////////

	localparam SUM_WIDTH = FIR_DATA_WIDTH + FIR_COEF_MAG; /*at the end, sum is shortened by COEFMAG to XW length,
    so there is little reason to add more registers*/

    wire signed [SUM_WIDTH-1:0] dsp_con_sum [FIR_DSP_NR:0]; //+1 because of beg and end, ex: ---DSP---DSP---DSP--- || note: 3 DSPs and 4 wires
    wire signed [FIR_DATA_WIDTH-1:0] dsp_con_x [FIR_DSP_NR:0]; //same as above

    assign dsp_con_sum[0] = 0;//sum starting with 0
    assign dsp_con_x[0] = fir_in;//input pipeline beginning

    always @(posedge fir_clk) begin
    	if(switches[SWITCH_FIR_EN] == 1'b0) begin
    		fir_out <= fir_in;
    	end else begin
    		fir_out[FIR_DATA_WIDTH-1:0] <= dsp_con_sum[FIR_DSP_NR][SUM_WIDTH-1: SUM_WIDTH - FIR_DATA_WIDTH]; 
    		//output shift by coefficients' magnitude
    		//same as [FIR_COEF_MAG + FIR_DATA_WIDTH - 1 : FIR_COEF_MAG] 
    	end
    end
    // Generating fir taps (DSP blocks + shifting registers) -- whole magic is performed in taps,
    // all that must be done outside is proper wiring.
    genvar k; 
    generate
    	for(k = 0; k < FIR_DSP_NR; k = k + 1) begin
    		firtap #(
    		.XW(FIR_DATA_WIDTH),
    		.COEFW(FIR_COEF_WIDTH),
    		.OUTW(SUM_WIDTH)
    		) inst_tap(
    		.clk(fir_clk),
    		.inX(dsp_con_x[k]),
    		.outX(dsp_con_x[k+1]),
    		.inCoef(coefs[k]),
    		.acc(dsp_con_sum[k]),
    		.out(dsp_con_sum[k+1])
    		);
    	end
    endgenerate


    /////////////////////

    always @(*) begin
    	coefs_max_nr = FIR_DSP_NR;
    	info_1 = PROG_NAME;
    	info_2 = PROG_VER; 
    end
	// User logic ends

	endmodule