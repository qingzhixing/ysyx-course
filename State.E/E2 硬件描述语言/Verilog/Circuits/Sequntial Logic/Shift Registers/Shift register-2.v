module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //

	wire [3:0] w_in;

	assign w_in = {KEY[3], LEDR[3:1]};

	generate
		genvar i;
		for (i = 3; i >= 0; i--) begin : gen_mux
			MUXDFF mux_instance (
				.clk(KEY[0]),
				.E(KEY[1]),
				.L(KEY[2]),
				.w(w_in[i]),
				.R(SW[i]),
				.Q(LEDR[i]),
			);
		end
	endgenerate

endmodule

module MUXDFF (
	input clk,
	input E,
	input L,
	input w,
	input R,
	output Q
);

	always @(posedge clk ) begin
		case ({E, L})
			2'b00: Q <= Q;
			2'b01: Q <= R;
			2'b10: Q <= w;
			2'b11: Q <= R;
		endcase
	end

endmodule
