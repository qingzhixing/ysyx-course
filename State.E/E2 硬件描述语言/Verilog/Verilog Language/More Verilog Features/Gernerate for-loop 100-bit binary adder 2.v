module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );

	wire [100:0] carry_in;
	assign carry_in[0] = cin;

	generate
		genvar i;
		for (i = 0; i <= 99; i++) begin : addr_gen
			full_adder u_full_addr(
				.a(a[i]),
				.b(b[i]),
				.cin(carry_in[i]),
				.cout(carry_in[i + 1]),
				.sum(sum[i])
			);
		end
	endgenerate

	assign cout = carry_in[100:1];

endmodule

module full_adder(
    input a, b, cin,
    output sum, cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule
