module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

	wire [31:0] delay_in;

	initial begin
		delay_in = 32'd0;
	end

	always @(posedge clk ) begin
		delay_in <= in;
		if(reset) out <= 32'd0;
		else begin	
			out <= delay_in & (~in) | out;
		end 
	end

endmodule
