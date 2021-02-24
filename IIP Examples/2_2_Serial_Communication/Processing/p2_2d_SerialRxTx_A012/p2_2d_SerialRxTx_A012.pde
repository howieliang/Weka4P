//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import processing.serial.*;
Serial port; 

int dataNum = 100;
int sensorNum = 3;
int[][] rawData = new int[sensorNum][dataNum];
int dataIndex = 0;

void setup() {
  size(500, 500);

  //Initialize the serial port
  for (int i = 0; i < Serial.list().length; i++) println("[", i, "]:", Serial.list()[i]);
  String portName = Serial.list()[Serial.list().length-1];//MAC: check the printed list
  //String portName = Serial.list()[9];//WINDOWS: check the printed list
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n'); // arduino ends each data packet with a carriage return 
  port.clear();           // flush the Serial buffer
}

void draw() {
  background(255);
  float pointSize = height/dataNum;
  for (int i = 0; i < dataIndex; i++) {
    for (int n = 0; n < sensorNum; n++) {
      noStroke();
      if(n==0) fill(255, 0, 0);
      if(n==1) fill(0, 255, 0);
      if(n==2) fill(0, 0, 255);
      ellipse(i*pointSize, rawData[n][i], pointSize, pointSize);
    }
  }
}

void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');  // read the serial string until seeing a carriage return
  if (dataIndex<dataNum) {
    if (inData.charAt(0) == 'A') {
      rawData[0][dataIndex] = int(trim(inData.substring(1)));
    }
    if (inData.charAt(0) == 'B') {
      rawData[1][dataIndex] = int(trim(inData.substring(1)));
    }
    if (inData.charAt(0) == 'C') {
      rawData[2][dataIndex] = int(trim(inData.substring(1)));
      ++dataIndex;
    }
  }
  return;
}

void keyPressed() {
  if (key == ' ') {
    dataIndex = 0;
  }
  if (key == 'L' || key == 'l') {
    port.write('a');
  }
  if (key == 'K' || key == 'k') {
    port.write('b');
  }
}
