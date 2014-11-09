module controller(clk, IN_data, CYout, IR, PC_control, IR_enable, S, Mode, PC_out, Gr, Sr, Rin, Rout, CYin, Cout, imm, OUT_port);
	
	input CYout;
	input [7:0]IR;
	input [3:0]IN_data;
	input clk;
	
	output [3:0]PC_control;  //[update, carry flag, input low, input high]
	output IR_enable;
	output [3:0]S;
	output Mode;
	output PC_out;
	output [9:0]Gr;
	output [9:0]Sr;
	output Rin;
	output Rout;
	output CYin;
	output Cout;
	output [3:0]imm;
	output OUT_port;
	//output [3:0]Q;  //TEST 
	//output [7:0]stack_ptr; //TEST
	
	reg [3:0]PC_control;  //[update, carry flag, input low, input high]
	reg IR_enable;
	reg [3:0]S;
	reg Mode;
	reg PC_out;
	reg [9:0]Gr;
	reg [9:0]Sr;
	reg Rin;
	reg Rout;
	reg CYin;
	reg Cout;
	reg [3:0]imm;
	reg OUT_port;
	
	reg [7:0]stack_ptr;
	reg [3:0]Q;
	
	parameter JC 	= 4'b1111;
	parameter JMP 	= 4'b1110;
	parameter MOV 	= 4'b1101;
	parameter MVI 	= 4'b1100;
	parameter INC 	= 4'b1011;
	parameter ADD 	= 4'b1010;
	parameter SUB 	= 4'b1001;
	parameter I_AND = 4'b1000;
	parameter I_OR 	= 4'b0111;
	parameter SC 	= 4'b0110;
	parameter CC 	= 4'b0101;
	parameter PUSH 	= 4'b0100;
	parameter POP 	= 4'b0011;
	parameter IN 	= 4'b0010;
	parameter OUT 	= 4'b0001;
	parameter NOP 	= 4'b0000;
	
	//Defaults: PC_control <= 0; Rin <= 0; Rout <= 0; imm <= 0; OUT_port <= 0; Cout <= 0; PC_out <= 0;
	initial begin
		CYin = 1;
		Q = 4'b1111;
		IR_enable = 1;
		stack_ptr = 0;
	end
	always @ (posedge clk) begin
		
		case({IR[7:4],Q})
			//JC
			{JC,4'b0000}: if(~CYin) begin
				imm <= IR[3:0]; S <= 4'b1001; Mode <= 0; PC_out <= 1; Rout <= 0; Rin <= 0; Cout <= 0; OUT_port <= 0; PC_control <= 4'b0000; Q <= 1;
				end
				else begin
					PC_control <= 4'b1000; Q <= 4; Rin <= 0;
					end
			{JC,4'b0001}: begin
				CYin <= CYout; Q <= 2;
				end
			{JC,4'b0010}: begin
				Cout <= 1; PC_control <= {1'b0,~CYin,2'b10}; Q <= 3;
				end
			{JC,4'b0011}: begin
				PC_control <= 0; Q <= 0;
				end
			{JC,4'b0100}: begin
				PC_control <= 4'b0000; Q <= 0;
				end
			//JMP
			{JMP,4'b0000}: begin
				PC_control <= 4'b0001;Q <= 1; IR_enable <= 0; PC_out <= 0; Rout <= 0; Rin <= 0; Cout <= 0;imm <= IR[3:0];  OUT_port <= 0;
				end
			{JMP,4'b0001}: begin
				PC_control <= 0; Q <= 2; Gr <= 10'b0000000000; Cout <= 1; Rout <= 1; S <= 4'b1010; Mode <= 1; imm <= 0;
				end
			{JMP,4'b0010}: begin
				Rout <= 0; Rin <=0; PC_control <= 4'b0010; Q <= 3; IR_enable = 1;
				end
			{JMP,4'b0011}: begin
				PC_control <= 4'b0000; Q <= 0;
				end
			//MOV
			{MOV,4'b0000}: begin
				PC_control <= 4'b1000; Rin <= 0; Rout <= 1; imm <= 0; OUT_port <= 0; Cout <= 1; PC_out <= 0; Gr <= {8'b00000000,IR[3:2]}; S <= 4'b1010; Mode <= 1; Q <= 1;
				end
			{MOV,4'b0001}: begin
				PC_control <= 0; Gr <= 0; Sr <= {8'b00000000,IR[1:0]}; Rin <= 1; Rout <=0; Q <=0;
				end
			//MVI
			{MVI,4'b0000}: begin
				PC_control <= 4'b1000; Q <=1; Cout <= 0; OUT_port <= 0; PC_out <= 0; Sr <= 10'b0000000000; Rin <= 1; Rout <= 0; imm <= IR[3:0];
				end
			{MVI,4'b0001}: begin
				PC_control <= 4'b0000; Q <=0; Rin <= 1;
				end
			//INC
			{INC,4'b0000}: begin
				PC_control <= 4'b0000; Q <= 1; Rin <= 0;
				end
			{INC,4'b0001}: begin
				PC_control <= 4'b1000; Rout <= 1; imm <= 1; OUT_port <= 0; Cout <= 0; PC_out <= 0; Gr <= {8'b00000000,IR[1:0]}; Q <= 2; S <= 4'b1001; Mode <= 0;
				end
			{INC,4'b0010}: begin
				PC_control <= 4'b0000; Rin <=1; Rout <= 0; Cout <=1; Sr <= {8'b00000000,IR[1:0]}; Q <= 0; CYin <= CYout;
				end
			//ADD
			{ADD,4'b0000}: begin
				PC_control <= 4'b0000; Rin <= 0; Gr <= {8'b00000000,IR[3:2]}; Rout <= 1; imm <= 0; OUT_port <= 0; Cout <= 0; PC_out <= 0; Mode <= 1; S <= 4'b1010; Q <= 1;
				end
			{ADD,4'b0001}: begin
				PC_control <= 4'b1000; Gr <= {8'b00000000,IR[1:0]}; Cout <= 1; S <= 4'b1001; Mode <= 0; Q <= 2;
				end
			{ADD,4'b0010}: begin
				Rout <= 0; Sr <= {8'b00000000,IR[3:2]}; Rin <= 1; Q <= 0; PC_control <= 0; CYin <= CYout;
				end
			//SUB
			{SUB,4'b0000}: begin
				PC_control <= 4'b0000; Rin <= 0; Gr <= {8'b00000000,IR[3:2]}; Rout <= 1; imm <= 0; OUT_port <= 0; Cout <= 0; PC_out <= 0; Mode <= 1; S <= 4'b1010; Q <= 1;
				end
			{SUB,4'b0001}: begin
				PC_control <= 4'b1000; Gr <= {8'b00000000,IR[1:0]}; Cout <= 1; S <= 4'b0110; Mode <= 0; Q <= 2;
				end
			{SUB,4'b0010}: begin
				Rout <= 0; Sr <= {8'b00000000,IR[3:2]}; Rin <= 1; Q <= 0; PC_control <= 0; CYin <= CYout;
				end
			//AND
			{I_AND,4'b0000}: begin
				PC_control <= 4'b0000; Rin <= 0; Gr <= {8'b00000000,IR[3:2]}; Rout <= 1; imm <= 0; OUT_port <= 0; Cout <= 0; PC_out <= 0; Mode <= 1; S <= 4'b1010; Q <= 1;
				end
			{I_AND,4'b0001}: begin
				PC_control <= 4'b1000; Gr <= {8'b00000000,IR[1:0]}; Cout <= 1; S <= 4'b1011; Mode <= 1; Q <= 2;
				end
			{I_AND,4'b0010}: begin
				Rout <= 0; Sr <= {8'b00000000,IR[3:2]}; Rin <= 1; Q <= 0; PC_control <= 0;
				end
			//OR
			{I_OR,4'b0000}: begin
				PC_control <= 4'b0000; Rin <= 0; Gr <= {8'b00000000,IR[3:2]}; Rout <= 1; imm <= 0; OUT_port <= 0; Cout <= 0; PC_out <= 0; Mode <= 1; S <= 4'b1010; Q <= 1;
				end
			{I_OR,4'b0001}: begin
				PC_control <= 4'b1000; Gr <= {8'b00000000,IR[1:0]}; Cout <= 1; S <= 4'b1110; Mode <= 1; Q <= 2;
				end
			{I_OR,4'b0010}: begin
				Rout <= 0; Sr <= {8'b00000000,IR[3:2]}; Rin <= 1; Q <= 0; PC_control <= 0;
				end
			//SC
			{SC, 4'b0000}: begin
				PC_control<=4'b1000; Q<=1; Rin<=0;
			end
			{SC, 4'b0001}: begin
				CYin<=0; PC_control<=4'b0000; Cout<=0; imm<=0; OUT_port<=0; Rout<=0; PC_out<=0; Q<=0;
			end
			//CC
			{CC, 4'b0000}: begin
				PC_control<=4'b1000; Q<=1; Rin<=0;
			end
			{CC, 4'b0001}: begin
				CYin<=1; PC_control<=4'b0000; Cout<=0; imm<=0; OUT_port<=0; Rout<=0; PC_out<=0; Q<=0;
			end
			//PUSH
			{PUSH,4'b0000}: begin
				PC_control<=4'b1000; Gr<={8'b00000000,IR[1:0]}; Rout<=1; S<=4'b1010; Mode<=1; stack_ptr<=stack_ptr+1;
				PC_out=0; Rin<=0; Cout<=0; imm<=0; OUT_port<=0; Q<=1;
				end
			{PUSH,4'b0001}: begin PC_control<=0; Rout<=0; Cout<=1; Sr<={stack_ptr, 2'b00}; Rin<=1;Q<=0;
				end
			//POP
			{POP,4'b0000}: begin
				PC_control<=4'b1000; Gr<={stack_ptr, 2'b00}; Rout<=1; Rin <=0; stack_ptr<=stack_ptr-1; S <= 4'b1010; Mode <= 1;
				PC_out=0; Cout<=0; imm<=0; OUT_port<=0; Q<=1;
				end
			{POP,4'b0001}: begin PC_control<=0; Rout<=0; Cout<=1; Sr<={8'b00000000,IR[1:0]}; Rin<=1;Q<=0;
				end
			//IN
			{IN, 4'b0000}:begin
				PC_control <= 4'b1000; Q<=1; Sr<={8'b00000000,IR[1:0]}; Rin<=1; imm<=IN_data; Cout<=0; OUT_port<=0; Rout<=0; PC_out<=0;
			end
			{IN, 4'b0001}:begin
				PC_control<=4'b0000;
				Q<=0;
			end
			//OUT
			{OUT, 4'b0000}:begin
				PC_control <= 4'b1000; Q<=1; Rin <= 0; Cout<=0; imm<=0; PC_out<=0; Gr<={8'b00000000,IR[1:0]}; Rout<=1;
			end
			{OUT, 4'b0001}:begin
				PC_control<=4'b0000; OUT_port<=1; Q<=0;
			end
			//NOP
			{NOP, 4'b0000}:begin
				PC_control<=4'b1000; Q<=1; Rin <= 0;
			end
			{NOP, 4'b0001}:begin
				PC_control<=4'b0000; Cout<=0; imm<=0; OUT_port<=0; Rout<=0; PC_out<=0; Q<=0;
			end
			default: begin
				PC_control <= 4'b0000; Rin <= 0; Rout <= 0; imm <= 0; OUT_port <= 0; Cout <= 0; PC_out <= 0; Gr <= 0; Sr <= 0; Q <= 0; S <= 0; Mode <= 0; IR_enable <= 1;
				end
		endcase
	end
	
	
	
endmodule
