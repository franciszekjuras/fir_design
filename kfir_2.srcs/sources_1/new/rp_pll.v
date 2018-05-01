module rp_pll (
  // inputs
  input  wire clk       ,  // clock
  input  wire rstn      ,  // reset - active low
  // output clocks
  output wire clk_adc   ,  // ADC clock
  output wire clk_dac_1x,  // DAC clock
  output wire clk_dac_2x,  // DAC clock
  output wire clk_dac_2p,  // DAC clock
  output wire clk_ser   ,  // fast serial clock
  output wire clk_pdm   ,  // PDM clock
  // status outputs
  output wire pll_locked
);

localparam UNDERSAMPL = 2;
localparam SERIALMULT = 1;

wire clk_fb;

PLLE2_ADV #(
   .BANDWIDTH            ("OPTIMIZED"   ),
   .COMPENSATION         ("ZHOLD"       ),
   .DIVCLK_DIVIDE        ( 1            ),
   .CLKFBOUT_MULT        ( 8            ),
   .CLKFBOUT_PHASE       ( 0.000        ),
   //copied ADC clock
   .CLKOUT0_DIVIDE       ( 8            ), // 8 bylo wczesniej
   .CLKOUT0_PHASE        ( 0            ),
   .CLKOUT0_DUTY_CYCLE   ( 0.5          ),
   //DAC clock 1x
   .CLKOUT1_DIVIDE       ( 8*UNDERSAMPL ),
   .CLKOUT1_PHASE        ( 0.000        ),
   .CLKOUT1_DUTY_CYCLE   ( 0.5          ),
   //DAC clock 2x
   .CLKOUT2_DIVIDE       ( 4*UNDERSAMPL ),
   .CLKOUT2_PHASE        ( 0.000        ),
   .CLKOUT2_DUTY_CYCLE   ( 0.5          ),
   //DAC clock 2x phase shifted
   .CLKOUT3_DIVIDE       ( 4*UNDERSAMPL ),
   .CLKOUT3_PHASE        (-45.000       ),
   .CLKOUT3_DUTY_CYCLE   ( 0.5          ),
   //serial clock for multiplication in DSP blocks
   .CLKOUT4_DIVIDE       ( 8/SERIALMULT ),  // 8->125MHz 4->250MHz, 2->500MHz
   .CLKOUT4_PHASE        ( 0            ),
   .CLKOUT4_DUTY_CYCLE   ( 0.5          ),
   //pdm clock - unused
   .CLKOUT5_DIVIDE       ( 4            ),
   .CLKOUT5_PHASE        ( 0.000        ),
   .CLKOUT5_DUTY_CYCLE   ( 0.5          ),
   .CLKIN1_PERIOD        ( 8.000        ),
   .REF_JITTER1          ( 0.010        )
) pll (
   // Output clocks
   .CLKFBOUT     (clk_fb    ),
   .CLKOUT0      (clk_adc   ),
   .CLKOUT1      (clk_dac_1x),
   .CLKOUT2      (clk_dac_2x),
   .CLKOUT3      (clk_dac_2p),
   .CLKOUT4      (clk_ser   ),
   .CLKOUT5      (clk_pdm   ),
   // Input clock control
   .CLKFBIN      (clk_fb    ),
   .CLKIN1       (clk       ),
   .CLKIN2       (1'b0      ),
   // Tied to always select the primary input clock
   .CLKINSEL     (1'b1 ),
   // Ports for dynamic reconfiguration
   .DADDR        (7'h0 ),
   .DCLK         (1'b0 ),
   .DEN          (1'b0 ),
   .DI           (16'h0),
   .DO           (     ),
   .DRDY         (     ),
   .DWE          (1'b0 ),
   // Other control and status signals
   .LOCKED       (pll_locked),
   .PWRDWN       (1'b0      ),
   .RST          (!rstn     )
);

endmodule: rp_pll