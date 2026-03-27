module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
	parameter [4:0] IDLE_STATE  = 5'b0000_1;
	parameter [4:0] START_STATE = 5'b0001_0;
	parameter [4:0] DATA_STATE  = 5'b0010_0;
	parameter [4:0] END_STATE   = 5'b0100_0;
	parameter [4:0] ERROR_STATE = 5'b1000_0;

	reg [4:0] state, next_state;

	reg [4:0] data_cnt;

	// State Transition
	assign next_state[0] = in && (state[0] || state[3] || state[4]);			// IDLE
	assign next_state[1] = (!in) && (state[0] || state[3]);						// START
	assign next_state[2] = state[1] || (state[2] && (data_cnt < 8));			// DATA
	assign next_state[3] = in && state[2] && (data_cnt >= 8);					// END
	assign next_state[4] = (!in) && ((state[2] && (data_cnt >=8)) || state[4])	// ERROR

	// State Flip-Flop
	always @(posedge clk) begin
		if(reset) begin
			
		end
	end	
endmodule
