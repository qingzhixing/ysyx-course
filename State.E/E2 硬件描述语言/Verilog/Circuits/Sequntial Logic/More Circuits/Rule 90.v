module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q ); 

	always @(posedge clk ) begin
		if(load) q <= data;
		else begin
			q[0] <= 1'b0 ^ q[1];
			q[511] <= q[510] ^ 1'b0;
			for(int i = 1; i <= 510; i++) q[i] <= q[i-1] ^ q[i+1];
		end
	end

endmodule
