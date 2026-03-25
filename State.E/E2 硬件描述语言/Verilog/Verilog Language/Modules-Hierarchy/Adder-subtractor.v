module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);

	wire [31:0] handled_b = b ^ {32{sub}};
	wire adder_1_cout;

	add16 adder_1(a[15:0], handled_b[15:0], sub, sum[15:0], adder_1_cout);
	add16 adder_2(a[31:16], handled_b[31:16], adder_1_cout, sum[31:16]);

endmodule
