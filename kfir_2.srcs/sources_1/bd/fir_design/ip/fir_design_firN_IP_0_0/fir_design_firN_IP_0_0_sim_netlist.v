// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.3 (lin64) Build 2018833 Wed Oct  4 19:58:07 MDT 2017
// Date        : Sat Dec  2 17:52:39 2017
// Host        : franciszek-ThinkPad running 64-bit Ubuntu 16.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/franciszek/Documents/fpga/firN/kfir_2.srcs/sources_1/bd/fir_design/ip/fir_design_firN_IP_0_0/fir_design_firN_IP_0_0_sim_netlist.v
// Design      : fir_design_firN_IP_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "fir_design_firN_IP_0_0,firIP_v1_0,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* X_CORE_INFO = "firIP_v1_0,Vivado 2017.3" *) 
(* NotValidForBitStream *)
module fir_design_firN_IP_0_0
   (fir_clk,
    fir_in,
    fir_out,
    leds_out,
    s00_axi_awaddr,
    s00_axi_awprot,
    s00_axi_awvalid,
    s00_axi_awready,
    s00_axi_wdata,
    s00_axi_wstrb,
    s00_axi_wvalid,
    s00_axi_wready,
    s00_axi_bresp,
    s00_axi_bvalid,
    s00_axi_bready,
    s00_axi_araddr,
    s00_axi_arprot,
    s00_axi_arvalid,
    s00_axi_arready,
    s00_axi_rdata,
    s00_axi_rresp,
    s00_axi_rvalid,
    s00_axi_rready,
    s00_axi_aclk,
    s00_axi_aresetn);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 fir_clk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME fir_clk, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN fir_design_adc_clk" *) input fir_clk;
  input [13:0]fir_in;
  output [13:0]fir_out;
  output [7:0]leds_out;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR" *) input [15:0]s00_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT" *) input [2:0]s00_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID" *) input s00_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY" *) output s00_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WDATA" *) input [31:0]s00_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB" *) input [3:0]s00_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WVALID" *) input s00_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WREADY" *) output s00_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BRESP" *) output [1:0]s00_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BVALID" *) output s00_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BREADY" *) input s00_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR" *) input [15:0]s00_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT" *) input [2:0]s00_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID" *) input s00_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY" *) output s00_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RDATA" *) output [31:0]s00_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RRESP" *) output [1:0]s00_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RVALID" *) output s00_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RREADY" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 4, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 50000000, ID_WIDTH 0, ADDR_WIDTH 16, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 8, NUM_WRITE_OUTSTANDING 8, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN fir_design_processing_system7_0_1_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0" *) input s00_axi_rready;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK, xilinx.com:signal:clock:1.0 s00_axi_aclk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_CLK, ASSOCIATED_BUSIF S00_AXI, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 100000000, PHASE 0.000, XIL_INTERFACENAME s00_axi_aclk, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 50000000, PHASE 0.000, CLK_DOMAIN fir_design_processing_system7_0_1_FCLK_CLK0, ASSOCIATED_BUSIF S00_AXI" *) input s00_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S00_AXI_RST RST, xilinx.com:signal:reset:1.0 s00_axi_aresetn RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, XIL_INTERFACENAME s00_axi_aresetn, POLARITY ACTIVE_LOW" *) input s00_axi_aresetn;

  wire \<const0> ;
  wire fir_clk;
  wire [13:0]fir_in;
  wire [13:0]fir_out;
  wire [7:0]leds_out;
  wire s00_axi_aclk;
  wire [15:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arready;
  wire s00_axi_arvalid;
  wire [15:0]s00_axi_awaddr;
  wire s00_axi_awready;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire s00_axi_wready;
  wire s00_axi_wvalid;

  assign s00_axi_bresp[1] = \<const0> ;
  assign s00_axi_bresp[0] = \<const0> ;
  assign s00_axi_rresp[1] = \<const0> ;
  assign s00_axi_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  fir_design_firN_IP_0_0_firIP_v1_0 inst
       (.S_AXI_ARREADY(s00_axi_arready),
        .S_AXI_AWREADY(s00_axi_awready),
        .S_AXI_WREADY(s00_axi_wready),
        .fir_clk(fir_clk),
        .fir_in(fir_in),
        .fir_out(fir_out),
        .leds_out(leds_out),
        .s00_axi_aclk(s00_axi_aclk),
        .s00_axi_araddr(s00_axi_araddr[15:2]),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_awaddr(s00_axi_awaddr[15:2]),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rready(s00_axi_rready),
        .s00_axi_rvalid(s00_axi_rvalid),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wvalid(s00_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "firIP_v1_0" *) 
module fir_design_firN_IP_0_0_firIP_v1_0
   (leds_out,
    S_AXI_ARREADY,
    S_AXI_AWREADY,
    S_AXI_WREADY,
    fir_out,
    s00_axi_rdata,
    s00_axi_rvalid,
    s00_axi_bvalid,
    s00_axi_arvalid,
    s00_axi_awaddr,
    s00_axi_aclk,
    s00_axi_wdata,
    fir_in,
    fir_clk,
    s00_axi_araddr,
    s00_axi_wvalid,
    s00_axi_awvalid,
    s00_axi_aresetn,
    s00_axi_bready,
    s00_axi_rready);
  output [7:0]leds_out;
  output S_AXI_ARREADY;
  output S_AXI_AWREADY;
  output S_AXI_WREADY;
  output [13:0]fir_out;
  output [31:0]s00_axi_rdata;
  output s00_axi_rvalid;
  output s00_axi_bvalid;
  input s00_axi_arvalid;
  input [13:0]s00_axi_awaddr;
  input s00_axi_aclk;
  input [31:0]s00_axi_wdata;
  input [13:0]fir_in;
  input fir_clk;
  input [13:0]s00_axi_araddr;
  input s00_axi_wvalid;
  input s00_axi_awvalid;
  input s00_axi_aresetn;
  input s00_axi_bready;
  input s00_axi_rready;

  wire S_AXI_ARREADY;
  wire S_AXI_AWREADY;
  wire S_AXI_WREADY;
  wire fir_clk;
  wire [13:0]fir_in;
  wire [13:0]fir_out;
  wire [7:0]leds_out;
  wire s00_axi_aclk;
  wire [13:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arvalid;
  wire [13:0]s00_axi_awaddr;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire s00_axi_wvalid;

  fir_design_firN_IP_0_0_firMainAXI firMainAXI_inst
       (.S_AXI_ARREADY(S_AXI_ARREADY),
        .S_AXI_AWREADY(S_AXI_AWREADY),
        .S_AXI_WREADY(S_AXI_WREADY),
        .fir_clk(fir_clk),
        .fir_in(fir_in),
        .fir_out(fir_out),
        .leds_out(leds_out),
        .s00_axi_aclk(s00_axi_aclk),
        .s00_axi_araddr(s00_axi_araddr),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_awaddr(s00_axi_awaddr),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rready(s00_axi_rready),
        .s00_axi_rvalid(s00_axi_rvalid),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wvalid(s00_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "firMainAXI" *) 
module fir_design_firN_IP_0_0_firMainAXI
   (leds_out,
    S_AXI_ARREADY,
    S_AXI_AWREADY,
    S_AXI_WREADY,
    fir_out,
    s00_axi_rdata,
    s00_axi_rvalid,
    s00_axi_bvalid,
    s00_axi_arvalid,
    s00_axi_awaddr,
    s00_axi_aclk,
    s00_axi_wdata,
    fir_in,
    fir_clk,
    s00_axi_araddr,
    s00_axi_wvalid,
    s00_axi_awvalid,
    s00_axi_aresetn,
    s00_axi_bready,
    s00_axi_rready);
  output [7:0]leds_out;
  output S_AXI_ARREADY;
  output S_AXI_AWREADY;
  output S_AXI_WREADY;
  output [13:0]fir_out;
  output [31:0]s00_axi_rdata;
  output s00_axi_rvalid;
  output s00_axi_bvalid;
  input s00_axi_arvalid;
  input [13:0]s00_axi_awaddr;
  input s00_axi_aclk;
  input [31:0]s00_axi_wdata;
  input [13:0]fir_in;
  input fir_clk;
  input [13:0]s00_axi_araddr;
  input s00_axi_wvalid;
  input s00_axi_awvalid;
  input s00_axi_aresetn;
  input s00_axi_bready;
  input s00_axi_rready;

  wire S_AXI_ARREADY;
  wire S_AXI_AWREADY;
  wire S_AXI_WREADY;
  wire aw_en_i_1_n_0;
  wire aw_en_reg_n_0;
  wire \axi_araddr_reg_n_0_[0] ;
  wire \axi_araddr_reg_n_0_[10] ;
  wire \axi_araddr_reg_n_0_[11] ;
  wire \axi_araddr_reg_n_0_[12] ;
  wire \axi_araddr_reg_n_0_[13] ;
  wire \axi_araddr_reg_n_0_[1] ;
  wire \axi_araddr_reg_n_0_[2] ;
  wire \axi_araddr_reg_n_0_[3] ;
  wire \axi_araddr_reg_n_0_[4] ;
  wire \axi_araddr_reg_n_0_[5] ;
  wire \axi_araddr_reg_n_0_[6] ;
  wire \axi_araddr_reg_n_0_[7] ;
  wire \axi_araddr_reg_n_0_[8] ;
  wire \axi_araddr_reg_n_0_[9] ;
  wire axi_arready_i_1_n_0;
  wire [13:0]axi_awaddr;
  wire axi_awready0;
  wire axi_awready_i_1_n_0;
  wire axi_bvalid_i_1_n_0;
  wire \axi_rdata[0]_i_1_n_0 ;
  wire \axi_rdata[10]_i_1_n_0 ;
  wire \axi_rdata[10]_i_2_n_0 ;
  wire \axi_rdata[11]_i_1_n_0 ;
  wire \axi_rdata[11]_i_2_n_0 ;
  wire \axi_rdata[12]_i_1_n_0 ;
  wire \axi_rdata[13]_i_1_n_0 ;
  wire \axi_rdata[14]_i_1_n_0 ;
  wire \axi_rdata[14]_i_2_n_0 ;
  wire \axi_rdata[15]_i_1_n_0 ;
  wire \axi_rdata[16]_i_1_n_0 ;
  wire \axi_rdata[17]_i_1_n_0 ;
  wire \axi_rdata[17]_i_2_n_0 ;
  wire \axi_rdata[18]_i_1_n_0 ;
  wire \axi_rdata[19]_i_1_n_0 ;
  wire \axi_rdata[1]_i_1_n_0 ;
  wire \axi_rdata[1]_i_2_n_0 ;
  wire \axi_rdata[20]_i_1_n_0 ;
  wire \axi_rdata[20]_i_2_n_0 ;
  wire \axi_rdata[21]_i_1_n_0 ;
  wire \axi_rdata[21]_i_2_n_0 ;
  wire \axi_rdata[22]_i_1_n_0 ;
  wire \axi_rdata[22]_i_2_n_0 ;
  wire \axi_rdata[23]_i_1_n_0 ;
  wire \axi_rdata[24]_i_1_n_0 ;
  wire \axi_rdata[24]_i_2_n_0 ;
  wire \axi_rdata[25]_i_1_n_0 ;
  wire \axi_rdata[25]_i_2_n_0 ;
  wire \axi_rdata[26]_i_1_n_0 ;
  wire \axi_rdata[26]_i_2_n_0 ;
  wire \axi_rdata[27]_i_1_n_0 ;
  wire \axi_rdata[27]_i_2_n_0 ;
  wire \axi_rdata[28]_i_1_n_0 ;
  wire \axi_rdata[28]_i_2_n_0 ;
  wire \axi_rdata[29]_i_1_n_0 ;
  wire \axi_rdata[2]_i_1_n_0 ;
  wire \axi_rdata[2]_i_2_n_0 ;
  wire \axi_rdata[30]_i_1_n_0 ;
  wire \axi_rdata[30]_i_2_n_0 ;
  wire \axi_rdata[31]_i_1_n_0 ;
  wire \axi_rdata[31]_i_2_n_0 ;
  wire \axi_rdata[31]_i_3_n_0 ;
  wire \axi_rdata[31]_i_4_n_0 ;
  wire \axi_rdata[3]_i_1_n_0 ;
  wire \axi_rdata[4]_i_1_n_0 ;
  wire \axi_rdata[4]_i_2_n_0 ;
  wire \axi_rdata[5]_i_1_n_0 ;
  wire \axi_rdata[6]_i_1_n_0 ;
  wire \axi_rdata[6]_i_2_n_0 ;
  wire \axi_rdata[7]_i_1_n_0 ;
  wire \axi_rdata[8]_i_1_n_0 ;
  wire \axi_rdata[8]_i_2_n_0 ;
  wire \axi_rdata[9]_i_1_n_0 ;
  wire axi_rvalid_i_1_n_0;
  wire axi_wready0;
  wire [31:0]coefs_crr_nr;
  wire coefs_crr_nr_0;
  wire fir_clk;
  wire [13:0]fir_in;
  wire [13:0]fir_out;
  wire [7:0]leds_out;
  wire reg_rden__0;
  wire s00_axi_aclk;
  wire [13:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arvalid;
  wire [13:0]s00_axi_awaddr;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire s00_axi_wvalid;
  wire [31:8]switches;
  wire switches1__1;
  wire \switches[7]_i_3_n_0 ;
  wire \switches[7]_i_4_n_0 ;
  wire \switches[7]_i_5_n_0 ;
  wire switches_1;

  LUT6 #(
    .INIT(64'hFF7FF070F070F070)) 
    aw_en_i_1
       (.I0(s00_axi_awvalid),
        .I1(s00_axi_wvalid),
        .I2(aw_en_reg_n_0),
        .I3(S_AXI_AWREADY),
        .I4(s00_axi_bready),
        .I5(s00_axi_bvalid),
        .O(aw_en_i_1_n_0));
  FDSE aw_en_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(aw_en_i_1_n_0),
        .Q(aw_en_reg_n_0),
        .S(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[0] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[0]),
        .Q(\axi_araddr_reg_n_0_[0] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[10] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[10]),
        .Q(\axi_araddr_reg_n_0_[10] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[11] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[11]),
        .Q(\axi_araddr_reg_n_0_[11] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[12] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[12]),
        .Q(\axi_araddr_reg_n_0_[12] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[13] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[13]),
        .Q(\axi_araddr_reg_n_0_[13] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[1] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[1]),
        .Q(\axi_araddr_reg_n_0_[1] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[2] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[2]),
        .Q(\axi_araddr_reg_n_0_[2] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[3] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[3]),
        .Q(\axi_araddr_reg_n_0_[3] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[4] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[4]),
        .Q(\axi_araddr_reg_n_0_[4] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[5] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[5]),
        .Q(\axi_araddr_reg_n_0_[5] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[6] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[6]),
        .Q(\axi_araddr_reg_n_0_[6] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[7] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[7]),
        .Q(\axi_araddr_reg_n_0_[7] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[8] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[8]),
        .Q(\axi_araddr_reg_n_0_[8] ),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[9] 
       (.C(s00_axi_aclk),
        .CE(axi_arready_i_1_n_0),
        .D(s00_axi_araddr[9]),
        .Q(\axi_araddr_reg_n_0_[9] ),
        .R(axi_awready_i_1_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    axi_arready_i_1
       (.I0(s00_axi_arvalid),
        .I1(S_AXI_ARREADY),
        .O(axi_arready_i_1_n_0));
  FDRE axi_arready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_arready_i_1_n_0),
        .Q(S_AXI_ARREADY),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[0] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[0]),
        .Q(axi_awaddr[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[10] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[10]),
        .Q(axi_awaddr[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[11] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[11]),
        .Q(axi_awaddr[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[12] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[12]),
        .Q(axi_awaddr[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[13] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[13]),
        .Q(axi_awaddr[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[1] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[1]),
        .Q(axi_awaddr[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[2] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[2]),
        .Q(axi_awaddr[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[3] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[3]),
        .Q(axi_awaddr[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[4] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[4]),
        .Q(axi_awaddr[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[5] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[5]),
        .Q(axi_awaddr[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[6] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[6]),
        .Q(axi_awaddr[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[7] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[7]),
        .Q(axi_awaddr[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[8] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[8]),
        .Q(axi_awaddr[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[9] 
       (.C(s00_axi_aclk),
        .CE(axi_awready0),
        .D(s00_axi_awaddr[9]),
        .Q(axi_awaddr[9]),
        .R(axi_awready_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    axi_awready_i_1
       (.I0(s00_axi_aresetn),
        .O(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h4000)) 
    axi_awready_i_2
       (.I0(S_AXI_AWREADY),
        .I1(aw_en_reg_n_0),
        .I2(s00_axi_wvalid),
        .I3(s00_axi_awvalid),
        .O(axi_awready0));
  FDRE axi_awready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_awready0),
        .Q(S_AXI_AWREADY),
        .R(axi_awready_i_1_n_0));
  LUT6 #(
    .INIT(64'h0000FFFF80008000)) 
    axi_bvalid_i_1
       (.I0(s00_axi_awvalid),
        .I1(s00_axi_wvalid),
        .I2(S_AXI_WREADY),
        .I3(S_AXI_AWREADY),
        .I4(s00_axi_bready),
        .I5(s00_axi_bvalid),
        .O(axi_bvalid_i_1_n_0));
  FDRE axi_bvalid_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_bvalid_i_1_n_0),
        .Q(s00_axi_bvalid),
        .R(axi_awready_i_1_n_0));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[0]_i_1 
       (.I0(coefs_crr_nr[0]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(leds_out[0]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[10]_i_1 
       (.I0(\axi_rdata[10]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[10]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h55400540)) 
    \axi_rdata[10]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(switches[10]),
        .I2(\axi_araddr_reg_n_0_[2] ),
        .I3(\axi_araddr_reg_n_0_[0] ),
        .I4(coefs_crr_nr[10]),
        .O(\axi_rdata[10]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[11]_i_1 
       (.I0(\axi_rdata[11]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[11]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h45405555)) 
    \axi_rdata[11]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(coefs_crr_nr[11]),
        .I2(\axi_araddr_reg_n_0_[0] ),
        .I3(switches[11]),
        .I4(\axi_araddr_reg_n_0_[2] ),
        .O(\axi_rdata[11]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[12]_i_1 
       (.I0(coefs_crr_nr[12]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(switches[12]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[13]_i_1 
       (.I0(coefs_crr_nr[13]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(switches[13]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[14]_i_1 
       (.I0(\axi_rdata[14]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[14]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h45405555)) 
    \axi_rdata[14]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(coefs_crr_nr[14]),
        .I2(\axi_araddr_reg_n_0_[0] ),
        .I3(switches[14]),
        .I4(\axi_araddr_reg_n_0_[2] ),
        .O(\axi_rdata[14]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[15]_i_1 
       (.I0(coefs_crr_nr[15]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(switches[15]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[16]_i_1 
       (.I0(coefs_crr_nr[16]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(switches[16]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[16]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[17]_i_1 
       (.I0(\axi_rdata[17]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[17]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h45405555)) 
    \axi_rdata[17]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(coefs_crr_nr[17]),
        .I2(\axi_araddr_reg_n_0_[0] ),
        .I3(switches[17]),
        .I4(\axi_araddr_reg_n_0_[2] ),
        .O(\axi_rdata[17]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[18]_i_1 
       (.I0(coefs_crr_nr[18]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(switches[18]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[19]_i_1 
       (.I0(coefs_crr_nr[19]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(switches[19]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[19]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[1]_i_1 
       (.I0(\axi_rdata[1]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[1]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h50450045)) 
    \axi_rdata[1]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(leds_out[1]),
        .I2(\axi_araddr_reg_n_0_[2] ),
        .I3(\axi_araddr_reg_n_0_[0] ),
        .I4(coefs_crr_nr[1]),
        .O(\axi_rdata[1]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[20]_i_1 
       (.I0(\axi_rdata[20]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[20]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h45405555)) 
    \axi_rdata[20]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(coefs_crr_nr[20]),
        .I2(\axi_araddr_reg_n_0_[0] ),
        .I3(switches[20]),
        .I4(\axi_araddr_reg_n_0_[2] ),
        .O(\axi_rdata[20]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[21]_i_1 
       (.I0(\axi_rdata[21]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[21]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h55400540)) 
    \axi_rdata[21]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(switches[21]),
        .I2(\axi_araddr_reg_n_0_[2] ),
        .I3(\axi_araddr_reg_n_0_[0] ),
        .I4(coefs_crr_nr[21]),
        .O(\axi_rdata[21]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[22]_i_1 
       (.I0(\axi_rdata[22]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[22]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h50450045)) 
    \axi_rdata[22]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(switches[22]),
        .I2(\axi_araddr_reg_n_0_[2] ),
        .I3(\axi_araddr_reg_n_0_[0] ),
        .I4(coefs_crr_nr[22]),
        .O(\axi_rdata[22]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[23]_i_1 
       (.I0(coefs_crr_nr[23]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(switches[23]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[23]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[24]_i_1 
       (.I0(\axi_rdata[24]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[24]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h50450045)) 
    \axi_rdata[24]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(switches[24]),
        .I2(\axi_araddr_reg_n_0_[2] ),
        .I3(\axi_araddr_reg_n_0_[0] ),
        .I4(coefs_crr_nr[24]),
        .O(\axi_rdata[24]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[25]_i_1 
       (.I0(\axi_rdata[25]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[25]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h50450045)) 
    \axi_rdata[25]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(switches[25]),
        .I2(\axi_araddr_reg_n_0_[2] ),
        .I3(\axi_araddr_reg_n_0_[0] ),
        .I4(coefs_crr_nr[25]),
        .O(\axi_rdata[25]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[26]_i_1 
       (.I0(\axi_rdata[26]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[26]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h50450045)) 
    \axi_rdata[26]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(switches[26]),
        .I2(\axi_araddr_reg_n_0_[2] ),
        .I3(\axi_araddr_reg_n_0_[0] ),
        .I4(coefs_crr_nr[26]),
        .O(\axi_rdata[26]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[27]_i_1 
       (.I0(\axi_rdata[27]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[27]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h50450045)) 
    \axi_rdata[27]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(switches[27]),
        .I2(\axi_araddr_reg_n_0_[2] ),
        .I3(\axi_araddr_reg_n_0_[0] ),
        .I4(coefs_crr_nr[27]),
        .O(\axi_rdata[27]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[28]_i_1 
       (.I0(\axi_rdata[28]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[28]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h50450045)) 
    \axi_rdata[28]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(switches[28]),
        .I2(\axi_araddr_reg_n_0_[2] ),
        .I3(\axi_araddr_reg_n_0_[0] ),
        .I4(coefs_crr_nr[28]),
        .O(\axi_rdata[28]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[29]_i_1 
       (.I0(coefs_crr_nr[29]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(switches[29]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[29]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[2]_i_1 
       (.I0(\axi_rdata[2]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[2]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h45405555)) 
    \axi_rdata[2]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(coefs_crr_nr[2]),
        .I2(\axi_araddr_reg_n_0_[0] ),
        .I3(leds_out[2]),
        .I4(\axi_araddr_reg_n_0_[2] ),
        .O(\axi_rdata[2]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[30]_i_1 
       (.I0(\axi_rdata[30]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[30]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h50450045)) 
    \axi_rdata[30]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(switches[30]),
        .I2(\axi_araddr_reg_n_0_[2] ),
        .I3(\axi_araddr_reg_n_0_[0] ),
        .I4(coefs_crr_nr[30]),
        .O(\axi_rdata[30]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[31]_i_1 
       (.I0(coefs_crr_nr[31]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(switches[31]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \axi_rdata[31]_i_2 
       (.I0(\axi_araddr_reg_n_0_[2] ),
        .I1(\axi_araddr_reg_n_0_[1] ),
        .O(\axi_rdata[31]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \axi_rdata[31]_i_3 
       (.I0(\axi_araddr_reg_n_0_[4] ),
        .I1(\axi_araddr_reg_n_0_[3] ),
        .I2(\axi_araddr_reg_n_0_[7] ),
        .I3(\axi_araddr_reg_n_0_[6] ),
        .I4(\axi_araddr_reg_n_0_[5] ),
        .O(\axi_rdata[31]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \axi_rdata[31]_i_4 
       (.I0(\axi_araddr_reg_n_0_[8] ),
        .I1(\axi_araddr_reg_n_0_[10] ),
        .I2(\axi_araddr_reg_n_0_[9] ),
        .I3(\axi_araddr_reg_n_0_[13] ),
        .I4(\axi_araddr_reg_n_0_[12] ),
        .I5(\axi_araddr_reg_n_0_[11] ),
        .O(\axi_rdata[31]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[3]_i_1 
       (.I0(coefs_crr_nr[3]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(leds_out[3]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[4]_i_1 
       (.I0(\axi_rdata[4]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[4]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h0B3C083C)) 
    \axi_rdata[4]_i_2 
       (.I0(coefs_crr_nr[4]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(\axi_araddr_reg_n_0_[1] ),
        .I3(\axi_araddr_reg_n_0_[2] ),
        .I4(leds_out[4]),
        .O(\axi_rdata[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[5]_i_1 
       (.I0(coefs_crr_nr[5]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(leds_out[5]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[6]_i_1 
       (.I0(\axi_rdata[6]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[6]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h0505FD5D)) 
    \axi_rdata[6]_i_2 
       (.I0(\axi_araddr_reg_n_0_[2] ),
        .I1(leds_out[6]),
        .I2(\axi_araddr_reg_n_0_[0] ),
        .I3(coefs_crr_nr[6]),
        .I4(\axi_araddr_reg_n_0_[1] ),
        .O(\axi_rdata[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[7]_i_1 
       (.I0(coefs_crr_nr[7]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(leds_out[7]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \axi_rdata[8]_i_1 
       (.I0(\axi_rdata[8]_i_2_n_0 ),
        .I1(\axi_rdata[31]_i_3_n_0 ),
        .I2(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[8]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h45405555)) 
    \axi_rdata[8]_i_2 
       (.I0(\axi_araddr_reg_n_0_[1] ),
        .I1(coefs_crr_nr[8]),
        .I2(\axi_araddr_reg_n_0_[0] ),
        .I3(switches[8]),
        .I4(\axi_araddr_reg_n_0_[2] ),
        .O(\axi_rdata[8]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB800000000000000)) 
    \axi_rdata[9]_i_1 
       (.I0(coefs_crr_nr[9]),
        .I1(\axi_araddr_reg_n_0_[0] ),
        .I2(switches[9]),
        .I3(\axi_rdata[31]_i_2_n_0 ),
        .I4(\axi_rdata[31]_i_3_n_0 ),
        .I5(\axi_rdata[31]_i_4_n_0 ),
        .O(\axi_rdata[9]_i_1_n_0 ));
  FDRE \axi_rdata_reg[0] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[0]_i_1_n_0 ),
        .Q(s00_axi_rdata[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[10] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[10]_i_1_n_0 ),
        .Q(s00_axi_rdata[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[11] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[11]_i_1_n_0 ),
        .Q(s00_axi_rdata[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[12] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[12]_i_1_n_0 ),
        .Q(s00_axi_rdata[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[13] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[13]_i_1_n_0 ),
        .Q(s00_axi_rdata[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[14] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[14]_i_1_n_0 ),
        .Q(s00_axi_rdata[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[15] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[15]_i_1_n_0 ),
        .Q(s00_axi_rdata[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[16] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[16]_i_1_n_0 ),
        .Q(s00_axi_rdata[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[17] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[17]_i_1_n_0 ),
        .Q(s00_axi_rdata[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[18] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[18]_i_1_n_0 ),
        .Q(s00_axi_rdata[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[19] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[19]_i_1_n_0 ),
        .Q(s00_axi_rdata[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[1] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[1]_i_1_n_0 ),
        .Q(s00_axi_rdata[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[20] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[20]_i_1_n_0 ),
        .Q(s00_axi_rdata[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[21] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[21]_i_1_n_0 ),
        .Q(s00_axi_rdata[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[22] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[22]_i_1_n_0 ),
        .Q(s00_axi_rdata[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[23] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[23]_i_1_n_0 ),
        .Q(s00_axi_rdata[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[24] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[24]_i_1_n_0 ),
        .Q(s00_axi_rdata[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[25] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[25]_i_1_n_0 ),
        .Q(s00_axi_rdata[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[26] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[26]_i_1_n_0 ),
        .Q(s00_axi_rdata[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[27] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[27]_i_1_n_0 ),
        .Q(s00_axi_rdata[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[28] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[28]_i_1_n_0 ),
        .Q(s00_axi_rdata[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[29] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[29]_i_1_n_0 ),
        .Q(s00_axi_rdata[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[2] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[2]_i_1_n_0 ),
        .Q(s00_axi_rdata[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[30] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[30]_i_1_n_0 ),
        .Q(s00_axi_rdata[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[31] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[31]_i_1_n_0 ),
        .Q(s00_axi_rdata[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[3] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[3]_i_1_n_0 ),
        .Q(s00_axi_rdata[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[4] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[4]_i_1_n_0 ),
        .Q(s00_axi_rdata[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[5] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[5]_i_1_n_0 ),
        .Q(s00_axi_rdata[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[6] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[6]_i_1_n_0 ),
        .Q(s00_axi_rdata[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[7] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[7]_i_1_n_0 ),
        .Q(s00_axi_rdata[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[8] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[8]_i_1_n_0 ),
        .Q(s00_axi_rdata[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[9] 
       (.C(s00_axi_aclk),
        .CE(reg_rden__0),
        .D(\axi_rdata[9]_i_1_n_0 ),
        .Q(s00_axi_rdata[9]),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h08F8)) 
    axi_rvalid_i_1
       (.I0(s00_axi_arvalid),
        .I1(S_AXI_ARREADY),
        .I2(s00_axi_rvalid),
        .I3(s00_axi_rready),
        .O(axi_rvalid_i_1_n_0));
  FDRE axi_rvalid_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_rvalid_i_1_n_0),
        .Q(s00_axi_rvalid),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h4000)) 
    axi_wready_i_1
       (.I0(S_AXI_WREADY),
        .I1(aw_en_reg_n_0),
        .I2(s00_axi_wvalid),
        .I3(s00_axi_awvalid),
        .O(axi_wready0));
  FDRE axi_wready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_wready0),
        .Q(S_AXI_WREADY),
        .R(axi_awready_i_1_n_0));
  LUT5 #(
    .INIT(32'h20000000)) 
    \coefs_crr_nr[31]_i_1 
       (.I0(switches1__1),
        .I1(\switches[7]_i_3_n_0 ),
        .I2(\switches[7]_i_4_n_0 ),
        .I3(\switches[7]_i_5_n_0 ),
        .I4(axi_awaddr[0]),
        .O(coefs_crr_nr_0));
  FDRE \coefs_crr_nr_reg[0] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[0]),
        .Q(coefs_crr_nr[0]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[10] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[10]),
        .Q(coefs_crr_nr[10]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[11] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[11]),
        .Q(coefs_crr_nr[11]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[12] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[12]),
        .Q(coefs_crr_nr[12]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[13] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[13]),
        .Q(coefs_crr_nr[13]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[14] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[14]),
        .Q(coefs_crr_nr[14]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[15] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[15]),
        .Q(coefs_crr_nr[15]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[16] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[16]),
        .Q(coefs_crr_nr[16]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[17] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[17]),
        .Q(coefs_crr_nr[17]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[18] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[18]),
        .Q(coefs_crr_nr[18]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[19] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[19]),
        .Q(coefs_crr_nr[19]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[1] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[1]),
        .Q(coefs_crr_nr[1]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[20] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[20]),
        .Q(coefs_crr_nr[20]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[21] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[21]),
        .Q(coefs_crr_nr[21]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[22] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[22]),
        .Q(coefs_crr_nr[22]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[23] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[23]),
        .Q(coefs_crr_nr[23]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[24] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[24]),
        .Q(coefs_crr_nr[24]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[25] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[25]),
        .Q(coefs_crr_nr[25]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[26] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[26]),
        .Q(coefs_crr_nr[26]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[27] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[27]),
        .Q(coefs_crr_nr[27]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[28] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[28]),
        .Q(coefs_crr_nr[28]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[29] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[29]),
        .Q(coefs_crr_nr[29]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[2] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[2]),
        .Q(coefs_crr_nr[2]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[30] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[30]),
        .Q(coefs_crr_nr[30]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[31] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[31]),
        .Q(coefs_crr_nr[31]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[3] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[3]),
        .Q(coefs_crr_nr[3]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[4] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[4]),
        .Q(coefs_crr_nr[4]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[5] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[5]),
        .Q(coefs_crr_nr[5]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[6] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[6]),
        .Q(coefs_crr_nr[6]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[7] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[7]),
        .Q(coefs_crr_nr[7]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[8] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[8]),
        .Q(coefs_crr_nr[8]),
        .R(1'b0));
  FDRE \coefs_crr_nr_reg[9] 
       (.C(s00_axi_aclk),
        .CE(coefs_crr_nr_0),
        .D(s00_axi_wdata[9]),
        .Q(coefs_crr_nr[9]),
        .R(1'b0));
  FDRE \fir_out_reg[0] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[0]),
        .Q(fir_out[0]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[10] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[10]),
        .Q(fir_out[10]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[11] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[11]),
        .Q(fir_out[11]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[12] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[12]),
        .Q(fir_out[12]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[13] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[13]),
        .Q(fir_out[13]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[1] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[1]),
        .Q(fir_out[1]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[2] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[2]),
        .Q(fir_out[2]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[3] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[3]),
        .Q(fir_out[3]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[4] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[4]),
        .Q(fir_out[4]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[5] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[5]),
        .Q(fir_out[5]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[6] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[6]),
        .Q(fir_out[6]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[7] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[7]),
        .Q(fir_out[7]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[8] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[8]),
        .Q(fir_out[8]),
        .R(leds_out[1]));
  FDRE \fir_out_reg[9] 
       (.C(fir_clk),
        .CE(1'b1),
        .D(fir_in[9]),
        .Q(fir_out[9]),
        .R(leds_out[1]));
  LUT3 #(
    .INIT(8'h40)) 
    reg_rden
       (.I0(s00_axi_rvalid),
        .I1(S_AXI_ARREADY),
        .I2(s00_axi_arvalid),
        .O(reg_rden__0));
  LUT5 #(
    .INIT(32'h02000000)) 
    \switches[7]_i_1 
       (.I0(switches1__1),
        .I1(axi_awaddr[0]),
        .I2(\switches[7]_i_3_n_0 ),
        .I3(\switches[7]_i_4_n_0 ),
        .I4(\switches[7]_i_5_n_0 ),
        .O(switches_1));
  LUT5 #(
    .INIT(32'h80000000)) 
    \switches[7]_i_2 
       (.I0(s00_axi_awvalid),
        .I1(s00_axi_wvalid),
        .I2(S_AXI_AWREADY),
        .I3(S_AXI_WREADY),
        .I4(s00_axi_aresetn),
        .O(switches1__1));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \switches[7]_i_3 
       (.I0(axi_awaddr[12]),
        .I1(axi_awaddr[13]),
        .I2(axi_awaddr[10]),
        .I3(axi_awaddr[11]),
        .O(\switches[7]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h01)) 
    \switches[7]_i_4 
       (.I0(axi_awaddr[8]),
        .I1(axi_awaddr[9]),
        .I2(axi_awaddr[7]),
        .O(\switches[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000002)) 
    \switches[7]_i_5 
       (.I0(axi_awaddr[2]),
        .I1(axi_awaddr[3]),
        .I2(axi_awaddr[1]),
        .I3(axi_awaddr[6]),
        .I4(axi_awaddr[5]),
        .I5(axi_awaddr[4]),
        .O(\switches[7]_i_5_n_0 ));
  FDRE \switches_reg[0] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[0]),
        .Q(leds_out[0]),
        .R(1'b0));
  FDRE \switches_reg[10] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[10]),
        .Q(switches[10]),
        .R(1'b0));
  FDRE \switches_reg[11] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[11]),
        .Q(switches[11]),
        .R(1'b0));
  FDRE \switches_reg[12] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[12]),
        .Q(switches[12]),
        .R(1'b0));
  FDRE \switches_reg[13] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[13]),
        .Q(switches[13]),
        .R(1'b0));
  FDRE \switches_reg[14] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[14]),
        .Q(switches[14]),
        .R(1'b0));
  FDRE \switches_reg[15] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[15]),
        .Q(switches[15]),
        .R(1'b0));
  FDRE \switches_reg[16] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[16]),
        .Q(switches[16]),
        .R(1'b0));
  FDRE \switches_reg[17] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[17]),
        .Q(switches[17]),
        .R(1'b0));
  FDRE \switches_reg[18] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[18]),
        .Q(switches[18]),
        .R(1'b0));
  FDRE \switches_reg[19] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[19]),
        .Q(switches[19]),
        .R(1'b0));
  FDRE \switches_reg[1] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[1]),
        .Q(leds_out[1]),
        .R(1'b0));
  FDRE \switches_reg[20] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[20]),
        .Q(switches[20]),
        .R(1'b0));
  FDRE \switches_reg[21] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[21]),
        .Q(switches[21]),
        .R(1'b0));
  FDRE \switches_reg[22] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[22]),
        .Q(switches[22]),
        .R(1'b0));
  FDRE \switches_reg[23] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[23]),
        .Q(switches[23]),
        .R(1'b0));
  FDRE \switches_reg[24] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[24]),
        .Q(switches[24]),
        .R(1'b0));
  FDRE \switches_reg[25] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[25]),
        .Q(switches[25]),
        .R(1'b0));
  FDRE \switches_reg[26] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[26]),
        .Q(switches[26]),
        .R(1'b0));
  FDRE \switches_reg[27] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[27]),
        .Q(switches[27]),
        .R(1'b0));
  FDRE \switches_reg[28] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[28]),
        .Q(switches[28]),
        .R(1'b0));
  FDRE \switches_reg[29] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[29]),
        .Q(switches[29]),
        .R(1'b0));
  FDRE \switches_reg[2] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[2]),
        .Q(leds_out[2]),
        .R(1'b0));
  FDRE \switches_reg[30] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[30]),
        .Q(switches[30]),
        .R(1'b0));
  FDRE \switches_reg[31] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[31]),
        .Q(switches[31]),
        .R(1'b0));
  FDRE \switches_reg[3] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[3]),
        .Q(leds_out[3]),
        .R(1'b0));
  FDRE \switches_reg[4] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[4]),
        .Q(leds_out[4]),
        .R(1'b0));
  FDRE \switches_reg[5] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[5]),
        .Q(leds_out[5]),
        .R(1'b0));
  FDRE \switches_reg[6] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[6]),
        .Q(leds_out[6]),
        .R(1'b0));
  FDRE \switches_reg[7] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[7]),
        .Q(leds_out[7]),
        .R(1'b0));
  FDRE \switches_reg[8] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[8]),
        .Q(switches[8]),
        .R(1'b0));
  FDRE \switches_reg[9] 
       (.C(s00_axi_aclk),
        .CE(switches_1),
        .D(s00_axi_wdata[9]),
        .Q(switches[9]),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
