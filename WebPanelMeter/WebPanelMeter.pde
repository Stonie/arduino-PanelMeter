

/*
  
  Web Meter 
  
  MCP41010 Digital pot controls a ammeter which reflects web response times. 

  Pin 10 = CS (Chip Select)
  Pin 11 = SI (Serial input)
  Pin 13 = SCK (Serial Clock)
   
  */

#include <SPI.h>
#include <Ethernet.h>
#include <HTTPClient.h>

const int PotSlaveSelectPin = 10; // set pin 10 as the slave select for the digital pot
byte potCmdByte = B00010001; // command byte to write to pot 0, from the MCP42XXX datasheet

byte mac[] = {  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192,168,1,169 };
byte server[] = { 203,18,241,16 }; //Magshop 

// configure ethernet lib
Client client(server, 80);

///
/// Setup
/// 
void setup() {

  Serial.begin(9600); // open comms for logging
  Serial.println("entering setup...");

  // set the slaveSelectPin as an output:
  pinMode (PotSlaveSelectPin, OUTPUT);
  
  // start the Ethernet connection:
  Ethernet.begin(mac, ip);
  
  // initialize SPI:
  SPI.begin(); 
  SPI.setBitOrder(MSBFIRST);

  Serial.println("completed setup...");
}

///
/// Main control loop
///
void loop() {

 
   //change the resistance on this channel from min to max:
    for (int level = 0; level < 255; level++) {
      digitalPotWrite(level);
      delay(100);
    }
    
    //wait a second at the top:
    delay(1000);
    
    // change the resistance on this channel from max to min:
    for (int level = 0; level > 0; level++) {
      digitalPotWrite(255 - level);
      delay(100);
    }



  unsigned long StartTime = millis();

/*
  // Web Client code

   HTTPClient client("magshop.com.au",server);
   // client.debug(-1);

    FILE* result = client.getURI("/LbHealthCheck.ashx");
    
    int returnCode = client.getLastReturnCode();
    
    if (result!=NULL) {
      // do i need to read the response or just time the action?
      client.closeStream(result);
    }
    else {
      Serial.println("failed to connect");
    }
    if (returnCode==200) {
      Serial.println("Http 200 OK");
  } 
    else {
      Serial.print("ERROR: Server returned ");
      Serial.println(returnCode);
    }
   
   */
   
   unsigned long EndTime = millis();

   unsigned long ElapsedTime = (EndTime - StartTime);
   Serial.println(ElapsedTime);
    
 }

int digitalPotWrite(int value) {

  Serial.println("Calling Pot...");

  // take the SS pin low to select the chip:
  digitalWrite(PotSlaveSelectPin,LOW);
  
  //  send in the address and value via SPI:
  SPI.transfer(potCmdByte);
  SPI.transfer(value);
  
  // take the SS pin high to de-select the chip:
  digitalWrite(PotSlaveSelectPin,HIGH);
}



