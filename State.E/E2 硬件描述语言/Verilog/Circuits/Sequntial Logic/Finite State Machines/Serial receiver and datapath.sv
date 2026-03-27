module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
);
	parameter [3:0] IDLE_STATE  = 4'd0;
	parameter [3:0] START_STATE = 4'd1;
	parameter [3:0] DATA_STATE  = 4'd2;
	parameter [3:0] END_STATE   = 4'd3;
	parameter [3:0] ERROR_STATE = 4'd4;

	reg [3:0] state, next_state;

	reg [4:0] data_cnt;

	// State Transition
	always @(*) begin
		case (state)
			IDLE_STATE: begin
				if(in) next_state = IDLE_STATE;
				else next_state = START_STATE;
			end
			START_STATE: begin
				next_state = DATA_STATE;
			end
			DATA_STATE: begin
				if(data_cnt < 8) next_state = DATA_STATE;
				else if (in) next_state = END_STATE;
				else next_state = ERROR_STATE;
			end
			END_STATE: begin
				if (in) next_state = IDLE_STATE;
				else next_state = START_STATE;
			end
			ERROR_STATE: begin
				if (in) next_state = IDLE_STATE;
				else next_state = ERROR_STATE;
			end
			default: next_state = IDLE_STATE;
		endcase
	end

	// State Flip-Flop
	always @(posedge clk) begin
		if(reset) begin
			state <= IDLE_STATE;
			data_cnt <= 0;
		end else begin
			state <= next_state;
			if(next_state == DATA_STATE) begin
				data_cnt <= data_cnt + 5'b1;
				out_byte[data_cnt] <= in; 
			end else data_cnt <= 0;
		end
	end	

	// Output
	assign done = (state == END_STATE);
endmodule
