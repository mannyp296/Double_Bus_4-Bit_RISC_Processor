


module Four_bit_Reg(d_out, d_in, clk);
	output [3:0] d_out;
	input [3:0] d_in;
	input clk;
	wire [3:0] d_out;
	
	d_ff a1(d_out[0], d_in[0], clk);
	d_ff a2(d_out[1], d_in[1], clk);	
	d_ff a3(d_out[2], d_in[2], clk);	
	d_ff a4(d_out[3], d_in[3], clk);
endmodule	
	
module 	d_ff (q, d, clk);
	input  clk;
	input [3:0]d;
	output [3:0]q;
	reg    [3:0]q;
	always @(posedge clk)
		q <= d;
endmodule
		