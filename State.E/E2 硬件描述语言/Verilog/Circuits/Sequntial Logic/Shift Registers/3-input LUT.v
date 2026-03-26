module top_module (
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z ); 

	wire [7:0] Q;
	initial begin
		Q <= 8'b0;
	end

	always @(posedge clk ) begin
		if(enable) begin
			Q <= { Q[6:0], S};
		end
	end

	assign Z = Q [{A,B,C}];

endmodule
