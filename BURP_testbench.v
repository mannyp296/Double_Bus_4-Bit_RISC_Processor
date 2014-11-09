module BURP_testbench;
	
	wire [3:0]ALU_out;
	wire [7:0]address;
	wire [7:0]eeprom_data;
	wire [3:0]S;
	wire Mode;
	wire [3:0]BusAout;
	wire CYout;
	wire CYin;
	wire [3:0]BusBout;
	wire X;
	wire Y;
	wire AEB;
	wire [9:0]Sr;
	wire [9:0]Gr;
	wire [3:0]OUT_wire;
	wire [3:0] aa;
	wire[3:0] RAMin;
	
	//wire [3:0]PC_control;
	//wire [7:0]IR;
	//wire IR_enable;
	//wire [3:0]Q;
	//wire [3:0]Cwire;
	//wire [7:0] st;
	//wire [3:0]imm;
	//wire Cout;
	
	reg clk;
	reg [3:0]IN_port;
	reg rst;
	reg [3:0]BusAin;
	reg [3:0]BusBin;
	
	assign aa=0;
	
	always @ (BusAout)
		BusAin <= BusAout;
	always @ (BusBout)
		BusBin <= BusBout;
	
	BURP B1(ALU_out, BusAin, BusBin, clk, CYout, eeprom_data, IN_port, rst, address, BusAout, BusBout,
	CYin, Gr, Mode, OUT_wire, Rin, Rout, S, Sr, RAMin);
	
	EEPROM eeprom(address, eeprom_data);
	
	//Right side = writing, Left side = reading
	SRAM SRAM1(Rin,0,0,Sr,{aa,BusAout},~clk,Rout,1,Gr,RAMin);
	
	Circuit74181 ALU(S, BusAout, BusBout, Mode, CYin, ALU_out, X, Y, CYout, AEB);
	
	always
		#5 clk = ~clk;
		
	initial
		begin
		clk = 1;
		IN_port = 4'b0000;
		rst = 1;
		BusAin = 0;
		BusBin = 0;
		
		#15 rst = 0;
		#250000 IN_port = 4'b1111;
		#200000 IN_port = 4'b0001;
		#100000 rst = 1;
		#1000 $stop;
		end
	
	
endmodule
