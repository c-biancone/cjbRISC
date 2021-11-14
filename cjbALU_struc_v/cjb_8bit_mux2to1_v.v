module cjb_8bit_mux2to1_v (d1, d0, s, f);

input	[7:0] d1, d0;
input s;
output [7:0] f;

// Ternary operator conditional assignment

assign f = s ? d1 : d0; 

endmodule 