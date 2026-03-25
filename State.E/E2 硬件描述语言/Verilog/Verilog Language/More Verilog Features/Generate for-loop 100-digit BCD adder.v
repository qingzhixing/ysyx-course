module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );

	wire [99:0] carry_in, carry_out;

	assign carry_in[0] = cin;
	assign cout = carry_out[99];

	generate
		genvar i;
		for(i = 0; i <= 99; i++) begin : gen_adder
			bcd_fadd bcd_adder(
				.a(a[(i * 4 + 3) : (i * 4)]),
				.b(b[(i * 4 + 3) : (i * 4)]),
				.cin(carry_in[i]),
				.cout(carry_out[i]),
				.sum(sum[(i * 4 + 3) : (i * 4)])
			);
			if(i < 99)
				assign carry_in[i + 1] = carry_out[i];
		end
	endgenerate

endmodule
