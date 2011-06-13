/*
  Digital Pot Control
 
 This example controls an Analog Devices AD5206 digital potentiometer.
 The AD5206 has 6 potentiometer channels. Each channel's pins are labeled
 A - connect this to voltage
 W - this is the pot's wiper, which changes when you set it
 B - connect this to ground.
 
 The AD5206 is SPI-compatible,and to command it, you send two bytes, 
 one with the channel number (0 - 5) and one with the resistance value for the
 channel (0 - 255).  
 
 The circuit:
 * All A pins  of AD5206 connected to +5V
 * All B pins of AD5206 connected to ground
 * An LED and a 220-ohm resisor in series connected from each W pin to ground
 * CS - to digital pin 10  (SS pin)
 * SDI - to digital pin 11 (MOSI pin)
 * CLK - to digital pin 13 (SCK pin)
 
 created 10 Aug 2010 
 by Tom Igoe
 
 Thanks to Heather Dewey-Hagborg for the original tutorial, 2005
 
 */

// inslude the SPI library:
#include <SPI.h>


// set pin 10 as the slave select for the digital pot:
const int PotSlaveSelectPin = 10;

byte cmd_byte0 = B00010001; // command byte to write to pot 0, from the MCP42XXX datasheet
byte cmd_byte1 = B00010010; // command byte to write to pot 1, from the MCP42XXX datasheet
byte cmd_byte2 = B00010011; // command byte to write to pots 0 and 1, from the MCP42XXX datasheet

void setup() {

  Serial.begin(9600); // open comms for logging
  Serial.println("entering setup...");

  // set the slaveSelectPin as an output:
  pinMode (PotSlaveSelectPin, OUTPUT);
  
  // initialize SPI:
  SPI.begin(); 
  
  SPI.setBitOrder(MSBFIRST);

  Serial.println("completed setup...");
}

void loop() {
 
    // change the resistance on this channel from min to max:
    for (int level = 0; level < 255; level++) {
      digitalPotWrite(level);
      delay(10);
    }
    
    // wait a second at the top:
    delay(100);
    
    // change the resistance on this channel from max to min:
    for (int level = 0; level < 255; level++) {
      digitalPotWrite(255 - level);
      delay(10);
    }
}

int digitalPotWrite(int value) {

  Serial.println("Calling Pot...");

  // take the SS pin low to select the chip:
  //digitalWrite(MasterSlaveSelectPin,HIGH);
  digitalWrite(PotSlaveSelectPin,LOW);
  
  //  send in the address and value via SPI:
  SPI.transfer(cmd_byte0);
  SPI.transfer(value);
  
  // take the SS pin high to de-select the chip:
  digitalWrite(PotSlaveSelectPin,HIGH);
  //digitalWrite(MasterSlaveSelectPin,LOW);
}


