//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import processing.serial.*;
Serial port; 

int sensorNum = 1; 
int streamSize = 500;
int[] rawData = new int[sensorNum];
float[][] sensorHist = new float[sensorNum][streamSize]; //history data to show

float[][] diffArray = new float[sensorNum][streamSize]; //diff calculation: substract

float[] modeArray = new float[streamSize]; //To show activated or not
float[][] thldArray = new float[sensorNum][streamSize]; //diff calculation: substract
int activationThld = 20; //The diff threshold of activiation

void setup() {
  size(500, 500, P2D);
  initSerial();
}

void draw() {
  background(255);
  lineGraph(sensorHist[0], 0, 500, 0, 0       , width, height/2, 0); //draw sensor stream
  lineGraph(diffArray[0], 0 , 500, 0, height/2, width, height/2, 1); //history of signal
  lineGraph(thldArray[0], 0 , 500, 0, height/2, width, height/2, 2); //history of signal
  barGraph (modeArray, 0 , height/2, width, height/2);
  showInfo("Thld: "+activationThld+" (A+/Z-)", 20, height-20);
  //barGraph(float[] data, float x, float y, float width, float height)
  //showInfo(String s, int v, float x, float y)
}

void keyPressed() {
  if (key == 'A' || key == 'a') {
    activationThld = min(activationThld+5, 100);
  }
  if (key == 'Z' || key == 'z') {
    activationThld = max(activationThld-5, 10);
  }
}

void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');  // read the serial string until seeing a carriage return
  if (inData.charAt(0) == 'A') {
    rawData[0] = int(trim(inData.substring(1)));
    appendArray( (sensorHist[0]) , map(rawData[0], 0, 1023, 0, height)); //store the data to history (for visualization)
    //calculating diff
    float diff = abs( (sensorHist[0])[0] - (sensorHist[0])[1]); //absolute diff
    appendArray(diffArray[0], diff);
    appendArray(thldArray[0], activationThld);
    //test activation threshold
    if (diff>activationThld) appendArray(modeArray, 2); //activate when the absolute diff is beyond the activationThld
    else appendArray(modeArray, -1); //otherwise, deactivate.
    
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
