`default_nettype none
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   ); 
	
    wire result;
    
    assign result = (a&&b)||(c&&d);
    assign out = result;
    assign out_n = !result;
endmodule
