//*********************************************
//  MPU6050_Rx_Tx_100Hz : Reads MPU Accelerometer data and sends it Processing via Serial
//
//  Author: Rong-Hao Liang <r.liang@tue.nl>
//  Edited by: Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (02 05 2021)
//
//  Manual:
//  Upload the sketch and test it via the serial monitor.
//  Make sure that the baud rate is set to 115200 at the bottom of the window
//
//  Close the Serial Monitor if you see the data flowing
//
//*********************************************

#include "MPU6050.h"
int sampleRate = 100; //samples per second
int sampleInterval = 1000000/sampleRate; //Inverse of SampleRate

long timer = micros(); //timer
MPU6050 imu;
int16_t ax, ay, az;

int ledOn = 0; //to control the LED.

void setup()
{
  Serial.begin(115200);
  Wire.begin();

  if (!imu.begin(AFS_2G, GFS_250DPS)) {
    Serial.println("MPU6050 is online...");
  }
  else {
    Serial.println("Failed to init MPU6050");
    while (true)
      ;
  }
  timer = micros();
}

void loop()
{
  if (micros() - timer >= sampleInterval) { //Timer: send sensor data in every 10ms
    timer = micros();
    if (imu.getAcc3Counts(&ax, &ay, &az)) {
      sendDataToProcessing('A', map(ax,-32768,32767,0,500));
      sendDataToProcessing('B', map(ay,-32768,32767,0,500));
      sendDataToProcessing('C', map(az,-32768,32767,0,500));
    }
  }
}

void sendDataToProcessing(char symbol, int data) {
  Serial.print(symbol);  // symbol prefix of data type
  Serial.println(data);  // the integer data with a carriage return
}

void getDataFromProcessing() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    if (inChar == 'a') { //when an 'a' character is received.
      ledOn = 1;
      digitalWrite(LED_BUILTIN, ledOn); //turn on the built in LED on Arduino Uno
    }
    if (inChar == 'b') { //when an 'b' character is received.
      ledOn = 0;
      digitalWrite(LED_BUILTIN, 0); //turn on the built in LED on Arduino Uno
    }
  }
}
