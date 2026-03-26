module top_module (
    input clk,
    input slowena,
    input reset,
    output [3:0] q);

	always @(posedge clk ) begin
		if (reset) q <= 4'd0;
		else if(slowena)
				if (q == 4'd9) q <= 4'd0;
				else q++;
	end

endmodule
