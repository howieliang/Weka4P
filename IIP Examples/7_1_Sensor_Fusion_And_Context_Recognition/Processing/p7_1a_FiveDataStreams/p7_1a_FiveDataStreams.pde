//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import processing.serial.*;
Serial port; 

int sensorNum = 5; 
int streamSize = 500;
int[] rawData = new int[sensorNum];
float[][] sensorHist = new float[sensorNum][streamSize]; //history data to show

void setup() {
  size(500, 500, P2D);
  initSerial();
}

void draw() {
  background(255);
  noFill();
  stroke(0);
  for (int i = 0; i < sensorNum; i++) {
    lineGraph(sensorHist[i], 0, 1024, 0, (i)*height/sensorNum, width, height/sensorNum, i); //toolfunction for drawing sensor data stream
  }
}

void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');  // read the serial string until seeing a carriage return
  if (inData.charAt(0) >= 'A' && inData.charAt(0) <= ('A'+(sensorNum-1)) ) {
    int index = inData.charAt(0)-'A';
    rawData[index] = int(trim(inData.substring(1)));
    appendArray( (sensorHist[index]), map(rawData[index], 0, 1023, 0, height)); //store the data to history (for visualization)
  }
  return;
}

//Append a value to a float[] array.
float[] appendArray (float[] _array, float _val) {
  float[] array = _array;
  float[] tempArray = new float[_array.length-1];
  arrayCopy(array, tempArray, tempArray.length);
  array[0] = _val;
  arrayCopy(tempArray, 0, array, 1, tempArray.length);
  return array;
}

void initSerial() {
  //Initiate the serial port
  for (int i = 0; i < Serial.list().length; i++) println("[", i, "]:", Serial.list()[i]);
  String portName = Serial.list()[Serial.list().length-1];//MAC: check the printed list
  //String portName = Serial.list()[9];//WINDOWS: check the printed list
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n'); // arduino ends each data packet with a carriage return 
  port.clear();           // flush the Serial buffer
}
