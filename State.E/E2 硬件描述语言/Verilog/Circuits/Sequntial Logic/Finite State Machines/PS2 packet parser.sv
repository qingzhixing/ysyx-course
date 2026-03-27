module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //

	parameter BYTE1 = 4'b0001;
	parameter BYTE2 = 4'b0010;
	parameter BYTE3 = 4'b0100;
	parameter DONE  = 4'b1000;

	reg [3:0] state, next_state;
	initial begin
		state = BYTE1;
	end

    // State transition logic (combinational)
	assign next_state[0] = (!in[3]) && (state[0] || state[3]) ;
	assign next_state[1] = in[3] && (state[0] || state[3]);
	assign next_state[2] = state[1];
	assign next_state[3] = state[2];

    // State flip-flops (sequential)
	always @(posedge clk or posedge reset) begin
		if(reset) state <= BYTE1;
		else state <= next_state;
	end

    // Output logic
	assign done = state[3];
endmodule
