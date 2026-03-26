module top_module(
    input clk,
    input in,
    input areset,
    output out); //

	parameter A = 2'd0, B = 2'd1, C = 2'd2, D = 2'd3;
	reg [1:0] current_state, next_state;

    // State transition logic
	always @(*) begin
		case (current_state)
			A: next_state = in? B:A;
			B: next_state = in? B:C;
			C: next_state = in? D:A;
			D: next_state = in? B:C;
			default: next_state = A;
		endcase
	end

    // State flip-flops with asynchronous reset
	always @(posedge clk or posedge areset) begin
		if(areset) current_state <= A;
		else current_state <= next_state;
	end

    // Output logic
	assign out = (current_state == D);

endmodule
