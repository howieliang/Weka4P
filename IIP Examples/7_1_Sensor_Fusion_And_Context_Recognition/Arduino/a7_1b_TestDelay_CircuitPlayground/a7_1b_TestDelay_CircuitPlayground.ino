//*********************************************
// Time-Series Signal Processing
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

#include <Adafruit_CircuitPlayground.h>
#include <Wire.h>
#include <SPI.h>
#define MICRO_S 8000 //100Hz = 1M/MICRO_S;
#define CAP_SAMPLES      20   // Number of samples to take for a capacitive touch read.
#define CAP_THRESHOLD    200

long timer = micros(); //timer
float X, Y, Z;
int capPin[7] = {A1, A2, A3, A4, A5, A6, A7};
int capVals[7];

void setup() {
  Serial.begin(115200); //initialize a serial port at a 115200 baud rate.
  pinMode(LED_BUILTIN, OUTPUT); //set the built-in LED to output  // put your setup code here, to run once:
  CircuitPlayground.begin();
  CircuitPlayground.setAccelRange(LIS3DH_RANGE_2_G);   // 2, 4, 8 or 16 G!

  for (int i = 0; i < 10; ++i) {
    CircuitPlayground.strip.setPixelColor(i, 0);
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  if (micros() - timer > MICRO_S) { //Timer: send sensor data in every 2ms
    timer = micros();
    getDataFromProcessing(); //Receive before sending out the signals
    Serial.flush(); //Flush the serial buffer

    //try the delays of functions
    CircuitPlayground.lightSensor();
    map(CircuitPlayground.mic.soundPressureLevel(1),40,120,0,1024);
    map(CircuitPlayground.motionX(), -20,20,0,1024);
    map(CircuitPlayground.motionY(), -20,20,0,1024);
    map(CircuitPlayground.motionZ(), -20,20,0,1024);
    Serial.println(micros() - timer);

    //implement the sensor stream
//    sendDataToProcessing('A', CircuitPlayground.lightSensor()); //Put the data into buffer to sent it out later.
//    sendDataToProcessing('B', map(CircuitPlayground.mic.soundPressureLevel(1), 40, 120, 0, 1024)); //Put the data into buffer to sent it out later.
//    sendDataToProcessing('C', map(CircuitPlayground.motionX(), -20, 20, 0, 1024)); //Put the data into buffer to sent it out later.
//    sendDataToProcessing('D', map(CircuitPlayground.motionY(), -20, 20, 0, 1024)); //Put the data into buffer to sent it out later.
//    sendDataToProcessing('E', map(CircuitPlayground.motionZ(), -20, 20, 0, 1024)); //Put the data into buffer to sent it out later.
//    for (int i = 0 ; i < 7; i++) {
//      capVals[i] = CircuitPlayground.readCap(capPin[i], CAP_SAMPLES);
//    }
//    for (int i = 0 ; i < 7; i++) {
//      sendDataToProcessing('F' + i, capVals[i]); //Put the data into buffer to sent it out later.
//    }
  }
}

void getDataFromProcessing() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    //    if (inChar == 'a') { //when an 'a' charactor is received.
    //      ledOn = 1 - ledOn;
    //      digitalWrite(LED_BUILTIN, ledOn); //turn on the built in LED on Arduino Uno
    //    }
  }
}

void sendDataToProcessing(char symbol, int data) {
  Serial.print(symbol);  // symbol prefix of data type
  Serial.println(data);  // the integer data with a carriage return
}
