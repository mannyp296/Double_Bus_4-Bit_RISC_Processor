module PC(reset, parallel_input, enable1, enable2, CYin,CYin_control, Q, clock, count_en);
input reset, enable1, enable2, clock, count_en, CYin, CYin_control;
input [3:0] parallel_input;
output [7:0] Q;

reg [7:0] Q;

always @(posedge clock)
begin
	if(reset == 1)			//active high signal
		Q = 0;
	else if(enable2 == 1) 	//active high signal
		Q[7:4] = parallel_input;
	else if(enable1 == 1) 	//active high signal
		begin
			Q[3:0] = parallel_input;
			if(CYin_control==1)
				Q[7:4]=Q[7:4]+CYin;
		end
	else if(count_en == 0) 		//active high signal
		Q = Q;
	else
		Q = Q+1;

end
endmodule
