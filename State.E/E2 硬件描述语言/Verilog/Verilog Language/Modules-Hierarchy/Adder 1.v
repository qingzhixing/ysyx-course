module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
	wire adder_1_cout;

	add16 adder_1(a[15:0],b[15:0],0,sum[15:0],adder_1_cout);
	add16 adder_2(a[31:16],b[31:16],adder_1_cout,sum[31:16]);

endmodule
