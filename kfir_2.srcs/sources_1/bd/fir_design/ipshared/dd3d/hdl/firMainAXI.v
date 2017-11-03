
`timescale 1 ns / 1 ps

	module firMainAXI #
	(
		// Users to add parameters here
		parameter FIR_DATA_WIDTH = 32,
		parameter FIR_COEF_WIDTH = 18,
		parameter FIR_COEF_MAG = 16,
        parameter FIR_DSP_NR = 32, //TODO: set this value as an axi read register
		// User parameters ends
		// Do not modify the parameters beyond this line
		// modified lol

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 16//TODO: fit to needs
    )
	(
		// Users to add ports here
        input wire fir_clk,
        input wire [FIR_DATA_WIDTH-1 : 0] fir_in,
        output reg [FIR_DATA_WIDTH-1 : 0] fir_out,
        output wire [7:0] leds_out,
		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);
    
    // local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)

    localparam ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	// Addresses' bases in 32/64 bit addressing
	localparam FIR_OFFSET_COEFS = 8;
	localparam PROG_NAME = "FIRN";
	localparam PROG_VER = "0v1";

	//Switches:
	localparam SWITCH_CON_EST = 0;
	localparam SWITCH_FIR_EN = 1;
	localparam SWITCH_FIR_UPDATE = 2;

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
/*1*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] info_2;
/*2*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] coefs_max_nr;
/*3*/    //reg [C_S_AXI_DATA_WIDTH-1 : 0] unused;
    //write|read
/*4*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] switches;
/*5*/    reg [C_S_AXI_DATA_WIDTH-1 : 0] coefs_crr_nr;
/*6*/    //reg [C_S_AXI_DATA_WIDTH-1 : 0] unused;
/*7*/    //reg [C_S_AXI_DATA_WIDTH-1 : 0] unused;




	reg signed [FIR_COEF_WIDTH-1 : 0] coefs [FIR_DSP_NR-1 : 0];

	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      	else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // Write Address latching 
	          axi_awaddr <= S_AXI_AWADDR[C_S_AXI_ADDR_WIDTH-1 : ADDR_LSB];
	        end
	    end 
	end       

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low.
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
	        begin
	          // slave is ready to accept write data when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	always @( posedge S_AXI_ACLK )
	begin: write_data
	  if ( S_AXI_ARESETN == 1'b0 ) //TODO: change to zynq reset
	    begin
	    	//TODO: think about resetting registers
			//switches <= 0;
			//coefs_crr_nr <= 0;

	      	//for(idx = 0; idx < FIR_DSP_NR; idx = idx + 1) begin
	      	//	coefs[idx] <= 0;
	      	//end
	    end 
	  else begin
	    if (reg_wren & S_AXI_ARESETN)
	      begin
	      	for(idx = 0; idx < FIR_DSP_NR; idx = idx + 1) begin
	      		if(idx + FIR_OFFSET_COEFS == axi_awaddr) begin
	      			coefs[idx] <= {S_AXI_WDATA[FIR_COEF_WIDTH-1],S_AXI_WDATA[FIR_COEF_WIDTH-2 : 0]};
	      		end
	      	end

	      	case(axi_awaddr)
	      		4: switches <= S_AXI_WDATA;
	      		5: coefs_crr_nr <= S_AXI_WDATA;
	      		//6: unused <= S_AXI_WDATA;
	      		//7: unused <= S_AXI_WDATA;
	      	endcase

	      end
	  end
	end    

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end 
	  else
	    begin    
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response 
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	end   

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR[C_S_AXI_ADDR_WIDTH-1 : ADDR_LSB];
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end                
	    end
	end    

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.

	//-----------------------------------------------------//
	//---------------------WYBOR ADRESU--------------------//
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

		for(idx = 0; idx < FIR_DSP_NR; idx = idx + 1) begin
				if(idx + FIR_OFFSET_COEFS == axi_araddr) begin
					reg_data_out = coefs[idx]; //WARN:sign bit might not be shifted properly
				end
		end	      
	end

	//-----------------------------------------------------//
	//-------------WRZUCENIE DANYCH NA BUS-----------------//
	//-----------------------------------------------------//
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end 
	  else
	    begin    
	      // When there is a valid read address (S_AXI_ARVALID) with 
	      // acceptance of read address by the slave (axi_arready), 
	      // output the read data 
	      if (reg_rden)
	        begin
	        	axi_rdata <= reg_data_out;
	        end   
	    end
	end    

	//-----------------------------------------------------//
	//--------------------LOGIKA UKLADU--------------------//
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
    	//TODO: set proper fir_en
    	if(switches[SWITCH_FIR_EN] == 1'b0) begin
    		fir_out <= 0;
    	end else begin
    		fir_out[FIR_DATA_WIDTH-1:0] <= dsp_con_sum[FIR_DSP_NR][SUM_WIDTH-1: SUM_WIDTH - FIR_DATA_WIDTH]; 
    		//output shift by coefficients' magnitude
    		//same as [FIR_COEF_MAG + FIR_DATA_WIDTH - 1 : FIR_COEF_MAG] 
    	end
    end

    genvar k; 
    generate
    	for(k = 0; k < FIR_DSP_NR; k = k + 1) begin
    		firtap #(
    		.XW(FIR_DATA_WIDTH),
    		.COEFW(FIR_COEF_WIDTH),
    		.OUTW(SUM_WIDTH)
    		) inst_tap(
    		.clk(fir_clk),
    		.reset(1'b0), //TODO: set proper reset
    		.inX(dsp_con_x[k]),
    		.outX(dsp_con_x[k+1]),
    		.inCoef(coefs[k]),
    		.acc(dsp_con_sum[k]),
    		.out(dsp_con_sum[k+1])//TODO: add fir_en
    		);
    	end
    endgenerate

    ////////////////////

    always @(*) begin
    	coefs_max_nr = FIR_DSP_NR;
    	info_1 = PROG_NAME;
    	info_2 = 0; //TODO: check decoding, change to PROG_VER, remember about stop char
    end


	// User logic ends

	endmodule