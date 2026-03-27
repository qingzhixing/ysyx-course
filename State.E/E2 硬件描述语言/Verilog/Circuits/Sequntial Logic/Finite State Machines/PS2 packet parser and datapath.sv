module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
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
		if(reset) begin
			state <= BYTE1;
			out_bytes <= 24'b0;
		end else begin
			state <= next_state;
			case (state)
				BYTE1, DONE: out_bytes[23:16] <= in;
				BYTE2: out_bytes[15:8] <= in;
				BYTE3: out_bytes[7:0] <= in;
			endcase
		end 
	end

    // Output logic
	assign done = state[3];
endmodule
