module EEPROM (address, data);

parameter JC 	= 4'b1111; //f
parameter JMP 	= 4'b1110; //e
parameter MOV 	= 4'b1101; //d
parameter MVI 	= 4'b1100; //c
parameter INC 	= 4'b1011; //b
parameter ADD 	= 4'b1010; //a
parameter SUB 	= 4'b1001; //9
parameter I_AND = 4'b1000; //8
parameter I_OR 	= 4'b0111; //7
parameter SC 	= 4'b0110; //6
parameter CC 	= 4'b0101; //5
parameter PUSH 	= 4'b0100; //4
parameter POP 	= 4'b0011; //3
parameter IN 	= 4'b0010; //2
parameter OUT 	= 4'b0001; //1
parameter NOP 	= 4'b0000; //0

input [7:0] address;
output [7:0] data;

reg [7:0] data;

always @(address) begin
	case(address)
		
		8'h00 : data = {IN, 4'b0010}; //in RC <Start>...<RC=1>
		8'h01 : data = {I_OR, 4'b1010}; // or RC RC ...<RC=1>
		//*** initialize registers
		8'h02 : data = {CC, 4'b0000}; //cc
		8'h03 : data = {MVI, 4'b0000}; // mvi RA,0 ...<RA=0,RC=1>
		8'h04 : data = {MOV, 4'b0011}; //mov RA,RD  ...<RA=0,RC=1, RD=0> >>>>RAM 
		8'h05 : data = {I_AND, 4'b0100}; //and RB,RA...<RA=0,RB=0,RC=1, RD=0> >>>>>>>RAM
		8'h06 : data = {MOV, 4'b1000}; //mov RC,RA ...<RA=1,RB=0,RC=1, RD=0> >>>>>>>RAM
		// *** count = input * 4
		8'h07 : data = {ADD, 4'b1000}; //add RC,RA ...<RA=1,RB=0,RC=2, RD=0> 
		8'h08 : data = {ADD, 4'b1101}; //add RD,RB       
		8'h09 : data = {ADD, 4'b1000}; //add RC,RA ...<RA=1,RB=0,RC=3, RD=0> 
		8'h0A : data = {ADD, 4'b1101};//add RD,RB               
		8'h0B : data = {ADD, 4'b1000};//add RC,RA...<RA=1,RB=0,RC=4, RD=0>
		8'h0C : data = {ADD, 4'b1101};//add RD,RB                        OK
		//*** initial output is same as input value
		8'h0D : data = {OUT, 4'b0000};//out RA
		//*** save items on stack
		8'h0E : data = {PUSH, 4'b0010};//push RC ...<MEM[0]=4>
		8'h0F : data = {PUSH, 4'b0011};//push RD ...<MEM[0]=4,MEM[1]=0 >
		8'h10 : data = {PUSH, 4'b0000};//push RA ...<MEM[0]=4,MEM[1]=0, MEM[2]=1 >
		8'h11 : data = {PUSH, 4'b0000}; //PUSH RA...<MEM[0]=4,MEM[1]=0, MEM[2]=1, MEM[4]=1 >
		//*** main program loop
		8'h12 : data = {MVI, 4'b0011}; //main: mvi RA,loop1.ls  ...<RA=3,RB=0,RC=4, RD=0>
		8'h13 : data = {INC, 4'b0010}; //loop1:  inc RC ...<RA=3,RB=0,RC=5, RD=0>
		8'h14 : data = {ADD, 4'b1101};//add RD,RB
		8'h15 : data = {NOP, 4'b0000};//nop
		8'h16 : data = {JC, 4'b0010};//jc break1
		8'h17 : data = {JMP, 4'b0001};//jmp loop1 //KEEP LOOPING TILL ....<RA=3, RB=0, RC=0, RD=0> at a CY
		// *** check if the user changed the input value
		8'h18 : data = {POP, 4'b0011}; //break1: pop RD ....<RA=3, RB=0, RC=0, RD=1>...<MEM[0]=4,MEM[1]=0, MEM[2]=1>
		8'h19 : data = {MOV, 4'b1110};//mov RD,RC ....<RA=3, RB=0, RC=1, RD=1>
		8'h1A : data = {IN, 4'b0000};//in RA ....<RA=1, RB=0, RC=1, RD=1>
		8'h1B : data = {SC, 4'b0000};//sc
		8'h1C : data = {SUB, 4'b1100};// sub RD,RA ....<RA=1, RB=0, RC=1, RD=0>
		8'h1D : data = {MVI, 4'b0001};//mvi RA,1
		8'h1E : data = {SC, 4'b0000};//sc
		8'h1F : data = {SUB, 4'b1100}; //sub RD,RA ....<RA=1, RB=0, RC=1, RD=15>
		8'h20 : data = {JC, 4'b1111}; //jc break2
		//*** compute logical inverse of last output and make it the new output
		8'h21 : data = {POP, 4'b0000};// pop RA ....<RA=1, RB=0, RC=1, RD=15>...<MEM[0]=4,MEM[1]=0>
		8'h22 : data = {SUB, 4'b0100};//sub RB,RA....<RA=1, RB=14, RC=1, RD=15>
		8'h23 : data = {OUT, 4'b0001}; //out RB
		8'h24 : data = {MOV, 4'b1000};//mov RC,RA....<RA=1, RB=14, RC=1, RD=15>
		8'h25 : data = {POP, 4'b0011};//pop RD ....<RA=1, RB=14, RC=1, RD=0>...<MEM[0]=4>
		8'h26 : data = {POP, 4'b0010};//pop RC ....<RA=1, RB=14, RC=4, RD=0>
		//*** Restore the stack for next iteration
		8'h27 : data = {PUSH, 4'b0010};//push RC ...<MEM[0]=4>
		8'h28 : data = {PUSH, 4'b0011};//push RD...<MEM[0]=4, MEM[1]=0>
		8'h29 : data = {PUSH, 4'b0001};//push RB...<MEM[0]=4, MEM[1]=0, MEM[2]=14>
		8'h2A : data = {PUSH, 4'b0000};//push RA...<MEM[0]=4, MEM[1]=0, MEM[2]=14, MEM[3]=1>
		//*** Set RB to zero
		8'h2B : data = {MVI, 4'b0000};//mvi RA,0 ...<RA=0, RB=15, RC=4, RD=0>
		8'h2C : data = {MOV, 4'b0001};//mov RA,RB ...<RA=0, RB=0, RC=4, RD=0>
		8'h2D : data = {MVI, 4'b0010};//mvi RA,main.ls ;...<RA=2, RB=0, RC=4, RD=0>
		8'h2E : data = {JMP, 4'b0001};//jmp main ?????????????????PROBLEM
		//*** Restart if user has changed input value
		8'h2F : data = {POP, 4'b0000};//pop RA   <break2:>
		8'h30 : data = {POP, 4'b0000};//pop RA
		8'h31 : data = {POP, 4'b0000};//pop RA
		8'h32 : data = {POP, 4'b0000};//pop RA
		8'h33 : data = {MVI, 4'b0000};//mvi RA,start.ls ;
		8'h34 : data = {JMP, 4'b0000};//jmp start

		default : data = 8'hFF;
	endcase
end
endmodule
