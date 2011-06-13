
/* INITIALISATION */

int SS1 = 10; // set slave select 1 pin
int CLK = 13; // set clock pin
int MOUT = 11; // set master out, slave in pin

byte cmd_byte0 = B00010001; // command byte to write to pot 0, from the MCP42XXX datasheet
byte cmd_byte1 = B00010010; // command byte to write to pot 1, from the MCP42XXX datasheet
byte cmd_byte2 = B00010011; // command byte to write to pots 0 and 1, from the MCP42XXX datasheet
byte work = B00000000; // setup a working byte, used to bit shift the data out

/* SETUP */

void setup() { // setup function begins here

pinMode(SS1, OUTPUT); // set CS pin to output
pinMode(CLK, OUTPUT); // set SCK pin to output
pinMode(MOUT, OUTPUT); // set MOSI pin to output
digitalWrite(SS1, HIGH); // hold slave select 1 pin high, so that chip is not selected to begin with


}

void spi_transfer(byte working) {

; // function to actually bit shift the data byte out

for(int i = 1; i <= 8; i++) { // setup a loop of 8 iterations, one for each bit

if (working > 127) { // test the most significant bit

digitalWrite (MOUT,HIGH); // if it is a 1 (ie. B1XXXXXXX), set the master out pin high

}

else {

digitalWrite (MOUT, LOW); // if it is not 1 (ie. B0XXXXXXX), set the master out pin low

}

digitalWrite (CLK,HIGH); // set clock high, the pot IC will read the bit into its register

working = working << 1;

digitalWrite(CLK,LOW); // set clock low, the pot IC will stop reading and prepare for the next iteration (next significant bit

}

}

void spi_out(int SS, byte cmd_byte, byte data_byte) { // SPI tranfer out function begins here

digitalWrite (SS, LOW); // set slave select low for a certain chip, defined in the argument in the main loop. selects the chip

work = cmd_byte; // let the work byte equal the cmd_byte, defined in the argument in the main loop

spi_transfer(work); // transfer the work byte, which is equal to the cmd_byte, out using spi

work = data_byte; // let the work byte equal the data for the pot

spi_transfer(work); // transfer the work byte, which is equal to the data for the pot

digitalWrite(SS, HIGH); // set slave select high for a certain chip, defined in the argument in the main loop. deselcts the chip

}

void loop () {

for(int j = 0; j < 256; j++) {

spi_out(SS1, cmd_byte0, j); // send out data to chip 1, pot 0

spi_out(SS1, cmd_byte1, 255 - j); // send out data to chip 1, pot 1

delay(10); // set a short delay

}

}
