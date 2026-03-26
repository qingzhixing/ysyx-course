`default_nettype none
module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 

	wire ss_ena, mm_ena, hh_ena;

	bcdcount_60 ss_count(clk, reset, ss_ena, ss);
	bcdcount_60 mm_count(clk, reset, mm_ena, mm);
	bcdcount_12 hh_count(clk, reset, hh_ena, hh);

	assign ss_ena = ena;
	assign mm_ena = (ss == 8'h59);
	assign hh_ena = (mm == 8'h59) && (ss == 8'h59);

	 // pm 在时钟沿更新，当 11:59:59 且使能时翻转
    always @(posedge clk) begin
        if (reset)
            pm <= 1'b0;   // 复位时设为上午
        else if (ena && (hh == 8'h11) && (mm == 8'h59) && (ss == 8'h59))
            pm <= ~pm;
    end
endmodule

module bcdcount_60(
	input clk,
	input reset,
	input enable,
	output [7:0] Q);

	always @(posedge clk ) begin
		if (!reset) begin
			if(enable) begin
				if(Q[3:0] == 4'h9) begin
					Q[3:0] <= 4'h0;

					if(Q[7:4] == 4'h5) begin
						Q[7:4] <= 4'h0;
					end
						else Q[7:4] <= Q[7:4] + 4'h1;
				end
					else Q[3:0] <= Q[3:0] + 4'h1;
			end
		end
		else Q <= 8'h00;
	end
endmodule

module bcdcount_12(
	input clk,
	input reset,
	input enable,
	output [7:0] Q);

	always @(posedge clk ) begin
		if (!reset) begin
			if(enable) begin
				if (Q == 8'h12) Q <= 8'h01;
				else if(Q[3:0] == 4'h9) begin
					Q[3:0] <= 4'h0;
					Q[7:4] <= Q[7:4] + 4'h1;
				end
					else Q[3:0] <= Q[3:0] + 4'h1;
			end
		end
		else Q <= 8'h12;		// 复位到12点
	end
endmodule