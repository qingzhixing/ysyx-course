module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 

    parameter LEFT=1'b0, RIGHT=1'b1;
    reg state, next_state;

    always @(*) begin
		if (!aaah) begin
			if (bump_left && bump_right) next_state = !state;
			else case (state)
				LEFT: next_state = (bump_left && ground)? RIGHT:LEFT;
				RIGHT: next_state = (bump_right && ground)? LEFT:RIGHT; 
			endcase
		end else next_state = state;
    end

    always @(posedge clk, posedge areset) begin
        if(areset) state <= LEFT;
		else begin	
			state <= next_state;
			aaah <= !ground;
		end 
    end

    // Output logic
    assign walk_left = (state == LEFT) && !aaah;
    assign walk_right = (state == RIGHT) && !aaah;

endmodule
