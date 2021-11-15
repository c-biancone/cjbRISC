/***************************************************************************************************
* File Name: cjbRISC_HMMIOP_v_FPGA.v
*
* Description: Top-level entity for CPU emulation on Altera FPGA board
*              Instantiates the RISC processor and divides the clock for ease of reading outputs
*              on the board's LEDs. This can be changed based on preference.
*
* Author: Chris Biancone, October 2021
***************************************************************************************************/

module cjbRISC_HMMIOP_v_FPGA (Clk_50, pb, sw, leds);

// User I/O-Ps of the DE0-Nano board: 2 push-buttons (pb), 4 switches (sw), 8 LEDs
input         Clk_50;
input   [1:0] pb;
input   [3:0] sw;
output  [7:0] leds;

// internal signals
wire  [95:0] ICis;
wire  [2:0]  crtMCis;
wire         RESET;

// set up for clock division
reg   [25:0] intclkcnt = 26'd0;
reg          intClk = 1'b0;

// flip pb0 input to match reset functionality since it is active low
assign RESET = ~pb[0];

// instantiate RISC processor
cjbRISC_HMMIOP_v (.Reset (RESET), .Clock (intClk), .PB1 (pb[1]), .SW (sw), .LEDs (leds),
    .ICis (ICis), .crtMCis (crtMCis));

// divide the onboard 50 MHz CLOCK_50 so that the period of intClock is 1 second;
always @ (posedge Clk_50) begin
  if (intclkcnt < 26'd25000000) begin
    intclkcnt = intclkcnt + 1'b1; intClk = intClk; end
  else begin intclkcnt = 26'd0; intClk = ~intClk; end
end

endmodule