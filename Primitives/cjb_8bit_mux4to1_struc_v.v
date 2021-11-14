module cjb_8bit_mux4to1_struc_v (d3, d2, d1, d0, s, f);

input	[7:0] d3, d2, d1, d0;
input [1:0] s;
output [7:0] f;
wire [7:0] f1, f0;

cjb_8bit_mux2to1_v stage0 (.d1 (d1), .d0 (d0), .s (s[0]), .f (f0));
cjb_8bit_mux2to1_v stage1 (.d1 (d3), .d0 (d2), .s (s[0]), .f (f1));
cjb_8bit_mux2to1_v stage2 (.d1 (f1), .d0 (f0), .s (s[1]), .f (f));

endmodule 