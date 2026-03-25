module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

	wire [7:0] delay1, delay2;

	always @(posedge clk ) begin
		delay1 <= in;
		delay2 <= delay1;
	end

	assign anyedge = delay1 ^ delay2;

endmodule
