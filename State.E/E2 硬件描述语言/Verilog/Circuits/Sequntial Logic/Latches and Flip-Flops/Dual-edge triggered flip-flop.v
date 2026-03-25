module top_module (
    input clk,
    input d,
    output q
);

	wire pos_d, neg_d;

	always @(posedge clk ) begin
		pos_d <= d;
	end

	always @(negedge clk ) begin
		neg_d <= d;
	end

	assign q = clk? pos_d : neg_d;

endmodule
