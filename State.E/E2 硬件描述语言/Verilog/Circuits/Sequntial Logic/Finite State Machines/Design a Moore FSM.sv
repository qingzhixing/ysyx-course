// COPIED from https://blog.csdn.net/shushisheng/article/details/137053909
module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
    // 状态描述
	localparam BelowS1   = 6'b000001,	// 采用独热码，以寄存器用量换组合电路用量
    		   BetwS21_u = 6'b000010,	// u：表示是升到这个水位的
    		   BetwS21_d = 6'b000100,	// d：表示是降到这个水位的
    		   BetwS32_u = 6'b001000,
    		   BetwS32_d = 6'b010000,
    		   AboveS3   = 6'b100000;
    
    // 现态、次态寄存器声明
    reg [5:0] state;
    reg [5:0] next_state;
    
    // 三段式状态机1：时序逻辑描述状态转换
    always @(posedge clk) begin
        if(reset)
            state <= BelowS1;
    	else
            state <= next_state;
    end
    
    // 三段式状态机2：组合逻辑描述判断逻辑
    always @(*) begin
        case(state)
            BelowS1   : next_state = s[1] ? BetwS21_u : BelowS1;
            BetwS21_u : next_state = s[2] ? BetwS32_u : (s[1] ? BetwS21_u : BelowS1);
            BetwS21_d : next_state = s[2] ? BetwS32_u : (s[1] ? BetwS21_d : BelowS1);
            BetwS32_u : next_state = s[3] ? AboveS3   : (s[2] ? BetwS32_u : BetwS21_d);
            BetwS32_d : next_state = s[3] ? AboveS3   : (s[2] ? BetwS32_d : BetwS21_d);
            AboveS3   : next_state = s[3] ? AboveS3   : BetwS32_d;
        endcase
    end
    
    // 三段式状态机3：组合逻辑描述输出（时序允许的情况下，使用时序逻辑可降低毛刺影响）
    always @(*) begin
        case(state)
            BelowS1   : {fr3, fr2, fr1, dfr} = 4'b1111;
            BetwS21_u : {fr3, fr2, fr1, dfr} = 4'b0110;
            BetwS21_d : {fr3, fr2, fr1, dfr} = 4'b0111;
            BetwS32_u : {fr3, fr2, fr1, dfr} = 4'b0010;
            BetwS32_d : {fr3, fr2, fr1, dfr} = 4'b0011;
            AboveS3   : {fr3, fr2, fr1, dfr} = 4'b0000;
            default   : {fr3, fr2, fr1, dfr} = 4'b1111;
        endcase
    end
endmodule
