module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
	wire adder_1_carry;
	wire [15:0] selector_in0, selector_in1;

	add16 adder_1 (a[15:0], b[15:0], 0, sum[15:0], adder_1_carry);
	add16 no_carry_adder_2 (a[31:16], b[31:16], 0, selector_in0);
	add16 carry_adder_2 (a[31:16], b[31:16], 1, selector_in1);

	always @(*) begin
		case (adder_1_carry)
			1'b0: sum[31:16] = selector_in0; 
			1'b1: sum[31:16] = selector_in1;
		endcase
	end
endmodule
