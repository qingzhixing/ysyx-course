module top_module( 
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different );

	// always @(*) begin
	// 	for ( int i = 0; i <= 98; i++) begin
	// 		out_both[i] = in[i] && in[i+1];
	// 		out_any[i+1] = in[i+1] || in[i];
	// 		out_different[i] = in[i] ^ in[i+1];
	// 	end
	// end
	
	// assign out_different[99] = in[99] ^ in[0];

	assign out_both = in[98:0] & in[99:1];

	assign out_any = in[99:1] | in[98:0];

	assign out_different = {in[99] ^ in[0], in[98:0] ^ in[99:1]};

endmodule
