`default_nettype none

// 8位数据 4选1 多路选择器
module mux4to1_8bit (
    input wire [7:0] in0, in1, in2, in3,
    input wire [1:0] sel,
    output reg [7:0] out
);
    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
            default: out = 8'b00000000;
        endcase
    end
endmodule

module top_module ( 
    input clk, 
    input [7:0] d, 
    input [1:0] sel, 
    output [7:0] q 
);

    wire [7:0] q1, q2, q3;

    my_dff8 instance_1 (clk, d, q1);
    my_dff8 instance_2 (clk, q1, q2);
    my_dff8 instance_3 (clk, q2, q3);

    mux4to1_8bit mux (
        .in0(d),
        .in1(q1),
        .in2(q2),
        .in3(q3),
        .sel(sel),
        .out(q)
    );

endmodule