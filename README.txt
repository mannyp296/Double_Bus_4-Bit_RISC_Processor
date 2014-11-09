README
by Manuel Perez

Note: This was a group project between Alex King (UCSB student) and I.

These are the verilog files used to implement a simplified double-bus
RISC processor. While the final project was done with both software
and hardware components, in order to test the main controller and the
BURP files, verilog representations of all of the hardware components
were used. The EEPROM used in the project and the verilog euqivalent
ran a program that would turn on the LED equivalents of a inputted
4 bit value, It would then alternate the state of the LED's to on and
off and viceversa (i.e 0010 to 1101), in a short period of time
depending on the clock frquency and the input value.

It is important to note that some of the hardware component
representations were not created by me or my partner:

circuit74181.v
REG_374.v
SRAM.v

A short informal video of my partner and I testing the completedproject
is included.