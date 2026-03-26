module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q ); 

	wire [511:0] left, right;

	assign left = {q[510:0], 1'b0};
	assign right = {1'b0, q[511:1]};

	always @(posedge clk ) begin
		if (load) q <= data;
		else begin
			for(int i = 0; i <= 511; i++) begin
				case ({right[i], q[i], left[i]})
					3'b111, 3'b100, 3'b000: q[i] <= 1'b0;
					default: q[i] <= 1'b1;
				endcase
			end
		end
	end

endmodule
