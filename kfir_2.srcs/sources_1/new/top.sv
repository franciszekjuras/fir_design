  module top(
// sys 
   inout [14:0] DDR_addr,
   inout [2:0] DDR_ba,
   inout DDR_cas_n,
   inout DDR_ck_n,
   inout DDR_ck_p,
   inout DDR_cke,
   inout DDR_cs_n,
   inout [3:0] DDR_dm,
   inout [31:0] DDR_dq,
   inout [3:0] DDR_dqs_n,
   inout [3:0] DDR_dqs_p,
   inout DDR_odt,
   inout DDR_ras_n,
   inout DDR_reset_n,
   inout DDR_we_n,
   inout FIXED_IO_ddr_vrn,
   inout FIXED_IO_ddr_vrp,
   inout [53:0] FIXED_IO_mio,
   inout FIXED_IO_ps_clk,
   inout FIXED_IO_ps_porb,
   inout FIXED_IO_ps_srstb,
   output [7:0] LED_OUT,
   
      // ADC
   input  logic [2-1:0] [16-1:2] adc_dat_i,  // ADC data
   input  logic           [ 2-1:0] adc_clk_i,  // ADC clock {p,n}
   //output logic           [ 2-1:0] adc_clk_o,  // optional ADC clock source (unused)
   //output logic                    adc_cdcs_o, // ADC clock duty cycle stabilizer
   // DAC
   output logic [14-1:0] dac_dat_o  ,  // DAC combined data
   output logic          dac_wrt_o  ,  // DAC write
   output logic          dac_sel_o  ,  // DAC channel select
   output logic          dac_clk_o  ,  // DAC clock
   output logic          dac_rst_o    // DAC reset
    
    );
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /*
    ////////////////////////////////////////////////////////////////////////////////
    // PLL (clock and reset)
    ////////////////////////////////////////////////////////////////////////////////
    
    // diferential clock input
    IBUFDS i_clk (.I (adc_clk_i[1]), .IB (adc_clk_i[0]), .O (adc_clk_in));  // differential clock input
    
    red_pitaya_pll pll (
      // inputs
      .clk         (adc_clk_in),  // clock
      .rstn        (frstn[0]  ),  // reset - active low
      // output clocks
      .clk_adc     (pll_adc_clk   ),  // ADC clock
      .clk_dac_1x  (pll_dac_clk_1x),  // DAC clock 125MHz
      .clk_dac_2x  (pll_dac_clk_2x),  // DAC clock 250MHz
      .clk_dac_2p  (pll_dac_clk_2p),  // DAC clock 250MHz -45DGR
      .clk_ser     (pll_ser_clk   ),  // fast serial clock
      .clk_pdm     (pll_pdm_clk   ),  // PDM clock
      // status outputs
      .pll_locked  (pll_locked)
    );
    
    BUFG bufg_adc_clk    (.O (adc_clk   ), .I (pll_adc_clk   ));
    BUFG bufg_dac_clk_1x (.O (dac_clk_1x), .I (pll_dac_clk_1x));
    BUFG bufg_dac_clk_2x (.O (dac_clk_2x), .I (pll_dac_clk_2x));
    BUFG bufg_dac_clk_2p (.O (dac_clk_2p), .I (pll_dac_clk_2p));
    BUFG bufg_ser_clk    (.O (ser_clk   ), .I (pll_ser_clk   ));
    BUFG bufg_pdm_clk    (.O (pdm_clk   ), .I (pll_pdm_clk   ));
    
    // TODO: reset is a mess
    logic top_rst;
    assign top_rst = ~frstn[0] | ~pll_locked;
    
    // ADC reset (active low)
    always_ff @(posedge adc_clk, posedge top_rst)
    if (top_rst) adc_rstn <= 1'b0;
    else         adc_rstn <= ~top_rst;
    
    // DAC reset (active high)
    always_ff @(posedge dac_clk_1x, posedge top_rst)
    if (top_rst) dac_rst  <= 1'b1;
    else         dac_rst  <= top_rst;
    */
    
    // PLL signals
    logic                 adc_clk_in;
    logic                 pll_adc_clk;
    logic                 pll_dac_clk_1x;
    logic                 pll_dac_clk_2x;
    logic                 pll_dac_clk_2p;
    logic                 pll_ser_clk;
    logic                 pll_pwm_clk;
    logic                 pll_locked;
    
IBUFDS i_clk (.I (adc_clk_i[1]), .IB (adc_clk_i[0]), .O (adc_clk_in));  // differential clock input


// DAC signals
logic                    dac_clk_1x;
logic                    dac_clk_2x;
logic                    dac_clk_2p;
logic                    dac_rst;

logic        [14-1:0] dac_dat_a, dac_dat_b;
logic        [14-1:0] dac_a    , dac_b    ;
logic signed [15-1:0] dac_a_sum, dac_b_sum;


// ADC clock/reset
logic                 adc_clk;
logic                 adc_rstn;


rp_pll i_pll(

// inputs
.clk(adc_clk_in),  // clock
.rstn(frstn0),  // reset - active low
// output clocks
  .clk_adc     (pll_adc_clk   ),  // ADC clock
.clk_dac_1x  (pll_dac_clk_1x),  // DAC clock 125MHz
.clk_dac_2x  (pll_dac_clk_2x),  // DAC clock 250MHz
.clk_dac_2p  (pll_dac_clk_2p),  // DAC clock 250MHz -45DGR
.clk_ser     (pll_ser_clk   ),  // fast serial clock
.clk_pdm     (pll_pwm_clk   ),  // PWM clock
// status outputs
.pll_locked  (pll_locked)

);

BUFG bufg_adc_clk    (.O (adc_clk   ), .I (pll_adc_clk   ));
BUFG bufg_dac_clk_1x (.O (dac_clk_1x), .I (pll_dac_clk_1x));
BUFG bufg_dac_clk_2x (.O (dac_clk_2x), .I (pll_dac_clk_2x));
BUFG bufg_dac_clk_2p (.O (dac_clk_2p), .I (pll_dac_clk_2p));
BUFG bufg_ser_clk    (.O (ser_clk   ), .I (pll_ser_clk   ));
BUFG bufg_pwm_clk    (.O (pwm_clk   ), .I (pll_pwm_clk   ));

// ADC reset (active low)
always @(posedge adc_clk)
//always @(posedge fclk[0])
adc_rstn <=  frstn0 &  pll_locked;

// DAC reset (active high)
always @(posedge dac_clk_1x)
//always @(posedge fclk[0])
dac_rst  <= ~frstn0 | ~pll_locked;

// stream bus type
localparam type SBA_T = logic signed [14-1:0];  // acquire
localparam type SBG_T = logic signed [14-1:0];  // generate

SBA_T [2-1:0]          adc_dat;

// ADC clock duty cycle stabilizer is enabled
assign adc_cdcs_o = 1'b1 ;
logic [2-1:0] [14-1:0] adc_dat_raw;

// DDR outputs
ODDR oddr_dac_clk          (.Q(dac_clk_o), .D1(1'b0     ), .D2(1'b1     ), .C(dac_clk_2p), .CE(1'b1), .R(1'b0   ), .S(1'b0));
ODDR oddr_dac_wrt          (.Q(dac_wrt_o), .D1(1'b0     ), .D2(1'b1     ), .C(dac_clk_2x), .CE(1'b1), .R(1'b0   ), .S(1'b0));
ODDR oddr_dac_sel          (.Q(dac_sel_o), .D1(1'b1     ), .D2(1'b0     ), .C(dac_clk_1x), .CE(1'b1), .R(dac_rst), .S(1'b0));
ODDR oddr_dac_rst          (.Q(dac_rst_o), .D1(dac_rst  ), .D2(dac_rst  ), .C(dac_clk_1x), .CE(1'b1), .R(1'b0   ), .S(1'b0));
ODDR oddr_dac_dat [14-1:0] (.Q(dac_dat_o), .D1(dac_dat_b), .D2(dac_dat_a), .C(dac_clk_1x), .CE(1'b1), .R(dac_rst), .S(1'b0));

// output registers + signed to unsigned (also to negative slope)
always @(posedge dac_clk_1x)
// always @(posedge fclk[0])
begin
  dac_dat_a <= {dac_a[14-1], ~dac_a[14-2:0]};
  dac_dat_b <= {dac_b[14-1], ~dac_b[14-2:0]};
end

// Sumation of ASG and PID signal perform saturation before sending to DAC 
//assign dac_a_sum = FIR_OUT;
 //assign dac_b_sum = FIR_OUT;
 //assign dac_a_sum = FIR_OUT;


// assign dac_a = FIR_OUT;
// saturation
//assign dac_b = (^dac_b_sum[15-1:15-2]) ? {dac_b_sum[15-1], {13{~dac_b_sum[15-1]}}} : dac_b_sum[14-1:0];
//assign dac_a = (^dac_a_sum[15-1:15-2]) ? {dac_a_sum[15-1], {13{~dac_a_sum[15-1]}}} : dac_a_sum[14-1:0];

logic [3:0] fclk;

always @(posedge adc_clk)
// always @(posedge fclk[0])
begin
  adc_dat_raw[0] <= adc_dat_i[0][16-1:2];
  adc_dat_raw[1] <= adc_dat_i[1][16-1:2];
end

assign adc_dat[0] = {adc_dat_raw[0][14-1], ~adc_dat_raw[0][14-2:0]};
assign adc_dat[1] = {adc_dat_raw[1][14-1], ~adc_dat_raw[1][14-2:0]};

logic [1:0][14-1 : 0] tmp;

////////////////////////////////////////////////////////////
always @ (posedge adc_clk) begin

// dac_a <= adc_dat[0];
dac_b <= adc_dat[1];

end
////////////////////////////////////////////////////////////



fir_design_wrapper i_sys(
    .DDR_addr(DDR_addr),
    .DDR_ba(DDR_ba),
    .DDR_cas_n(DDR_cas_n),
    .DDR_ck_n(DDR_ck_n),
    .DDR_ck_p(DDR_ck_p),
    .DDR_cke(DDR_cke),
    .DDR_cs_n(DDR_cs_n),
    .DDR_dm(DDR_dm),
    .DDR_dq(DDR_dq),
    .DDR_dqs_n(DDR_dqs_n),
    .DDR_dqs_p(DDR_dqs_p),
    .DDR_odt(DDR_odt),
    .DDR_ras_n(DDR_ras_n),
    .DDR_reset_n(DDR_reset_n),
    .DDR_we_n(DDR_we_n),
    .FCLK_CLK0(fclk[0]),
    // .FCLK_CLK1(fclk[1]),
    // .FCLK_CLK2(fclk[2]),
    // .FCLK_CLK3(fclk[3]),
    .FCLK_RESET0_N(frstn0),
    .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
    .FIXED_IO_mio(FIXED_IO_mio),
    .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
   // .mul_clk_i(ser_clk), // fast clock for multiplication
    .adc_clk(adc_clk), 
    .leds_out(LED_OUT),
    .adc_data(adc_dat[0]),
    .dac_data(dac_a)
    );


endmodule