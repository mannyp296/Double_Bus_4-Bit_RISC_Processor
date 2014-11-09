module BURP(ALU, BusAin, BusBin, clk, CYout, eeprom_data, IN_port, rst, address, BusAout, BusBout,
CYin, Gr, Mode, OUT_wire, Rin, Rout, S, Sr, RAMin);
	
	inout [3:0] ALU;
	input [3:0]BusAin;
	input [3:0]BusBin;
	input clk;
	input CYout;
	input [7:0]eeprom_data;
	input [3:0]IN_port;
	input rst;
	input [3:0] RAMin;
	
	output [7:0]address;
	output [3:0] BusAout;
	output [3:0]BusBout;
	output CYin;
	output [9:0]Gr;
	output Mode;
	output [3:0]OUT_wire;
	output Rin, Rout;
	output [3:0]S;
	output [9:0]Sr;
	
	//output [3:0]PC_control; //TEST
	//output [7:0] IR; //TEST
	//output IR_enable; //TEST
	//output [3:0]Q; //TEST
	//output [3:0]Cwire; //TEST
	//output [7:0] st; //TEST
	//output [3:0] imm;//TEST
	//output Cout; //TEST
	
	wire [7:0]address;
	wire Ccotrol;
	wire Cout;
	wire [3:0]Cwire;
	wire [3:0]imm;
	wire [7:0]IR;
	wire IR_enable;
	wire OUT_port;
	wire [3:0]PC_control;
	wire PC_out;
	wire Rin_bar;
	wire [3:0]pcBus;

	assign Rin=~Rin_bar;
	
	controller c1(clk, IN_port, CYout, IR, PC_control, IR_enable, S, Mode, PC_out, Gr, Sr, Rin_bar, Rout, CYin, Cout, imm, OUT_port);
	PC counter(rst, BusAin, PC_control[1], PC_control[0], CYout, PC_control[2], address, ~clk, PC_control[3]);
	
	REG_374 InstructionRegister(clk, eeprom_data, IR_enable, IR);
	
	//Control for PC output and RAM into Bus B
	MUX_2to1x4 M1(PC_out, 0, address[3:0], pcBus);
		MUX_2to1x4 M4(Rout, pcBus, RAMin, BusBout);

	
	//Register for outport
	Four_bit_Reg OPT(OUT_wire, BusBin, OUT_port);
	
	//C reg/accumulator
	//and a1( Ccontrol, clk, Cout );
	Four_bit_Reg C(Cwire, ALU, clk);
	
	//Bus A output
	//or4bit o1(BusAout, Cwire, imm);
	MUX_2to1x4 M3(Cout, imm, Cwire, BusAout);
	
endmodule

module or4bit(out, in0,in1);
	output [3:0]out;
	input [3:0]in0;
	input [3:0]in1;
	
	or o0(out[0],in0[0],in1[0]);
	or o1(out[1],in0[1],in1[1]);
	or o2(out[2],in0[2],in1[2]);
	or o3(out[3],in0[3],in1[3]);
	
endmodule
