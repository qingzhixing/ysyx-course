module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

	// define states
	parameter walking_left = 4'd0;
	parameter walking_right = 4'd1;
	parameter falling_left = 4'd2;
	parameter falling_right = 4'd3;
	parameter digging_left = 4'd4;
	parameter digging_right = 4'd5;
	parameter splatter = 4'd6;

	// state regs
	reg [3:0] state, next_state;

	reg [4:0] splatter_counter;

	initial begin
		splatter_counter = 5'd0;
	end

	// State transition logic
	always @(*) begin
		case (state)
			walking_left: begin
				if(!ground) next_state = falling_left;
				else if(dig) next_state = digging_left;
				else if(bump_left) next_state = walking_right;
				else next_state = walking_left;
			end
			walking_right: begin
				if(!ground) next_state = falling_right;
				else if(dig) next_state = digging_right;
				else if(bump_right) next_state = walking_left;
				else next_state = walking_right;
			end
			falling_left: begin
				if(ground) begin
					if (splatter_counter > 20) next_state = splatter;
					else next_state = walking_left;
				end
				else next_state = falling_left;
			end
			falling_right: begin
				if(ground) begin
					if (splatter_counter > 20) next_state = splatter;
					else next_state = walking_right;
				end
				else next_state = falling_right;
			end
			digging_left: begin
				if(!ground) next_state = falling_left;
				else next_state = digging_left;
			end
			digging_right: begin
				if(!ground) next_state = falling_right;
				else next_state = digging_right;
			end
			splatter: next_state = splatter;
		endcase
	end

	// State flip-flops with asynchronous reset
	always @(posedge clk or posedge areset) begin
		if(areset) begin 
			state <= walking_left;
			splatter_counter <= 5'd0;
		end
		else begin 
			state <= next_state;
			// counter++
			if (next_state == falling_left || next_state == falling_right) begin
				if (splatter_counter >= 21) splatter_counter <= 21;
				else splatter_counter <= splatter_counter + 5'd1;
			end else splatter_counter <= 5'd0;
		end
	end

	// output logic
	assign walk_left = (state == walking_left);
	assign walk_right = (state == walking_right);
	assign aaah = (state == falling_left) || (state == falling_right);
	assign digging = (state == digging_left) || (state == digging_right);

endmodule
