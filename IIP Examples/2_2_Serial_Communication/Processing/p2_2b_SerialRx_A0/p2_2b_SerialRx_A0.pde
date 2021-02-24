//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import processing.serial.*;
Serial port; 

int dataNum = 100;
int[] rawData = new int[dataNum];
int dataIndex = 0;

void setup() {
  size(500, 500);

  // Initialize the serial port
  for (int i = 0; i < Serial.list().length; i++)                    // Loop trough all Serial devices on computer
    println("[", i, "]:", Serial.list()[i]);                        // Print all Serial device names with corrosponding index
  
  String portName = Serial.list()[Serial.list().length-1];          // MAC: check the printed list
  //String portName = Serial.list()[9];                             // WINDOWS: check the printed list
  
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n');                                           // Arduino ends each data packet with a carriage return 
  port.clear();                                                     // Flush the Serial buffer
}

void draw() {
  background(255);
  float pointSize = height/dataNum;
  for (int i = 0; i < dataIndex; i++) {
    noStroke();
    fill(255, 0, 0);
    ellipse(i*pointSize, rawData[i], pointSize, pointSize);
  }
}

void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');                        // read the serial string until seeing a carriage return
  if (dataIndex<dataNum) {
    if (inData.charAt(0) == 'A') {
      rawData[dataIndex] = int(trim(inData.substring(1)));
      ++dataIndex;
    }
  }
  return;
}

void keyPressed() {
  if (key == ' ') {                                                  // Spacebar
    dataIndex = 0;
  }
}
