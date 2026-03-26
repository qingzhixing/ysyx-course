module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q ); 

	function automatic get_cell;
		input integer row, col;
		get_cell = q[((row + 16) % 16) * 16 + ((col + 16) % 16)];
	endfunction

    always @(posedge clk) begin
        if(load) q <= data;
        else begin
            for(int row = 0; row < 16; row++)
                for (int column = 0; column < 16; column++) begin
                    int sum;
                    sum = 
                      get_cell(row-1, column-1) + get_cell(row-1, column) + get_cell(row-1, column+1)
                    + get_cell(row,   column-1)                    + get_cell(row,   column+1)
                    + get_cell(row+1, column-1) + get_cell(row+1, column) + get_cell(row+1, column+1);

                    case (sum)
                        2: q[row * 16 + column] <= q[row * 16 + column];
                        3: q[row * 16 + column] <= 1'b1;
                        default: q[row * 16 + column] <= 1'b0;
                    endcase
                end
        end
    end

endmodule
