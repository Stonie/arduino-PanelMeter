/*
  
  Web Meter 
  
  MCP41010 Digital pot controls a ammeter which reflects web response times. 

  Pin 10 = CS (Chip Select)
  Pin 11 = SI (Serial input)
  Pin 13 = SCK (Serial Clock)
   
  */

#include <SPI.h>
#include <Ethernet.h>

const int PotSlaveSelectPin = 10; // set pin 10 as the slave select for the digital pot
byte potCmdByte = B00010001; // command byte to write to pot 0, from the MCP42XXX datasheet

///
/// Setup
/// 
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

///
/// Main control loop
///
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
  SPI.transfer(potCmdByte);
  SPI.transfer(value);
  
  // take the SS pin high to de-select the chip:
  digitalWrite(PotSlaveSelectPin,HIGH);
  //digitalWrite(MasterSlaveSelectPin,LOW);
}


