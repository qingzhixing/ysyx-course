module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else begin
            if (ena[0] ^ ena[1]) begin
                if (ena[1])            // left rotate
                    q <= {q[98:0], q[99]};
                else                   // right rotate
                    q <= {q[0], q[99:1]};
            end
        end
    end

endmodule