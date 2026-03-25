module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

	wire [7:0] saved_in,delay_in;

	always @(posedge clk) begin
		saved_in <= in;
		delay_in <= saved_in;
	end

	assign pedge = (~delay_in) & saved_in;

endmodule
