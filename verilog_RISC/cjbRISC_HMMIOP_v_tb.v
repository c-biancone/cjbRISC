/***************************************************************************************************
* File Name: cjbRISC_HMMIOP_v_tb.v
*
* Description: Test bench for verifying functionality of the processor using ModelSim
*              Creates test vectors to run as a routine
*
* Author: Chris Biancone, October 2021
***************************************************************************************************/

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module cjbRISC_HMMIOP_v_tb;

reg Reset_tb, Clock_tb, PB1_tb;
reg   [3:0]   SW_tb;
wire  [7:0]   LEDs_tb;
wire  [95:0]  ICis_tb;
wire  [2:0]   crtMCis_tb;

integer i;

cjbRISC_HMMIOP_v muv (.Reset (Reset_tb), .Clock (Clock_tb), .PB1 (PB1_tb), .SW (SW_tb),
    .LEDs (LEDs_tb), .ICis (ICis_tb), .crtMCis (crtMCis_tb));
    
//cjbRISC_HMMIOP_v_FPGA muv (.Reset (Reset_tb), .Clock (Clock_tb), .PB1 (PB1_tb), .SW (SW_tb),
//    .LEDs (LEDs_tb), .crtMCis (crtMCis_tb));

initial begin

// Reset_tb, Clock_tb, PB1_tb, SW_tb, LEDs_tb, ICis_tb, crtMCis_tb
//-- Test Vector 1 (40ns): Reset
  for (i=0; i<5; i=i+1)
    apply_test_vector(1, 0, 1, 4'b0000);

  //-- All other test vectors
  for (i=0; i<30; i=i+1)
    apply_test_vector(0, 0, 1, 4'b0000);
  // reduced from 700 iterations
  for (i=30; i<700; i=i+1)
    apply_test_vector(0, 0, 1, 4'b1111);
end

// routine
task apply_test_vector;
  input Reset_int, Clock_int, PB1_int;
  input [3:0] SW_int;

  begin
    Reset_tb = Reset_int; Clock_tb = Clock_int;
    PB1_tb = PB1_int; SW_tb = SW_int;
    #25000;
    Clock_tb = 1;
    #25000;
  end
endtask

endmodule