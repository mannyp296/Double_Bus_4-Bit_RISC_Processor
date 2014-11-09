module REG_374(clk, input_data, enable, output_data);

input [7:0] input_data;
input clk;
input enable;

output [7:0] output_data;

reg [7:0] output_data;

always @(posedge clk)
begin
	if(enable == 1)
		output_data <= input_data;
end

endmodule
