//*********************************************
//  Serial_Rx_Tx_MPU6050_100Hz : Reads MPU Accelerometer data and sends it Processing via Serial
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

#include "MPU6050.h"                                          // Includes the provided MPU6050 library

int sampleRate = 100;                                         // Samples per second
int sampleInterval = 1000000/sampleRate;                      // Inverse of SampleRate for the interval

long timer = micros();                                        // Timer

MPU6050 imu;                                                  // Variable for the Internal Measurement Unit
int16_t ax, ay, az;                                           // Variables to store the XYZ data

bool ledOn = false;                                           // LED control

void setup(){
  
  Serial.begin(115200);                                       // Start Serial Communication
  Wire.begin();                                               // Start I2C connection

  if (!imu.begin(AFS_2G, GFS_250DPS)) {                       // Check if connection is present
    Serial.println("MPU6050 is online..."); 
  }
  else {                                                      // If the MPU6050 can not be reached, the program will halt.
    Serial.println("Failed to init MPU6050");
    while (true);
  }
  
  timer = micros();                                           // Set the timer
}

void loop()
{
  if (micros() - timer >= sampleInterval) {                   // Timer: send sensor data in every 10ms
    timer = micros();                                         // Store last time
    if (imu.getAcc3Counts(&ax, &ay, &az)) {                   // Get the X Y Z values
      sendDataToProcessing('A', map(ax,-32768,32767,0,500));
      sendDataToProcessing('B', map(ay,-32768,32767,0,500));
      sendDataToProcessing('C', map(az,-32768,32767,0,500));
    }
  }
}

// Function to send the data to Processin via Serial
void sendDataToProcessing(char symbol, int data) {
  Serial.print(symbol);                                       // Symbol (identifier) prefix of data type
  Serial.println(data);                                       // The integer data with a carriage return (new line character)
}

// Function to read incoming Serial data
void getDataFromProcessing() {
  while (Serial.available()) {                                // Check if there is new data to be read
    char inChar = (char)Serial.read();                        // Reads the serial Buffer
    if (inChar == 'a') {                                      // When an 'a' charactor is received.
      ledOn = true;
      digitalWrite(LED_BUILTIN, HIGH);                        // Turn on the built in LED on
    }
    if (inChar == 'b') {                                      // When an 'b' charactor is received.
      ledOn = false;
      digitalWrite(LED_BUILTIN, LOW);                         // Turn on the built in LED off 
    }
  }
}
