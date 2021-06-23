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
      sendDataToProcessing('D', map(analogRead(A0),0,1023,0,500));
      sendDataToProcessing('E', map(analogRead(A1),0,1023,0,500));
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
    if (inChar == 'a') { //when an 'a' charactor is received.
      ledOn = 1;
      digitalWrite(LED_BUILTIN, ledOn); //turn on the built in LED on Arduino Uno
    }
    if (inChar == 'b') { //when an 'b' charactor is received.
      ledOn = 0;
      digitalWrite(LED_BUILTIN, 0); //turn on the built in LED on Arduino Uno
    }
  }
}
