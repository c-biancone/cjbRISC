//=============================================================================
// This is the behavioral description of an 8-bit x4 location deep hardware
// stack - LIFO.
// Chris Biancone October 2021.
//=============================================================================
module cjb_nbit_4loc_stack_v (push, pop, Reset, Clock, din, dout);
//=============================================================================
// Input and output ports declarations
//=============================================================================
parameter n = 8;
input push, pop, Reset, Clock;
input [n-1:0] din;
output reg [n-1:0] dout;
//=============================================================================
// Internal registered signals declarations
//=============================================================================
reg [n-1:0] tos, tos1, tos2, tos3;
//=============================================================================
// Behavioral description:
//=============================================================================
always @ (posedge Clock)
begin
	if (Reset) begin tos = 8'h00; tos1 = 8'h00; tos2 = 8'h00; tos3 = 8'h00; end 
	else if (push) begin tos3 = tos2; tos2 = tos1; tos1 = tos; tos = din; dout = din; end
	else if (pop) begin dout = tos; tos = tos1; tos1 = tos2; tos2 = tos3; tos3 = 8'h00; end
	else begin tos = tos; tos1 = tos1; tos2 = tos2; tos3 = tos3; dout = tos; end
end
endmodule
