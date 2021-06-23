//*********************************************
//  C_LoadModel_LSVC_Accelometer_3Axes : Load a Linear Support Vector Classifier model
//
//  Author:     Rong-Hao Liang <r.liang@tue.nl>
//  Edited by:  Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (22 06 2021)
//
//  Manual:
//  Drag the .model and .arff file into this sketch window or
//  copy the .model and .arff file to the data folder of this sketch.
//  Sketch -> Show Sketch Folder (ctrl/cmd + K)
//
//  You can generate your own model by using the TrainModel_LSVC_Mouse example  
//
//  The program will read a LSVC trained model and the .arff
//  and visualizes the model and shows you the prediction.
//
//*********************************************

import Weka4P.*;
Weka4P wp;

import processing.serial.*;                                               // Import the Serial Library
Serial port; 

int sensorNum = 3;
int[] rawData = new int[sensorNum];
boolean dataUpdated = false;

void setup() {
  size(500, 500);                                                         //set a canvas
  wp = new Weka4P(this);

                                                                          // Setup Serial communication                                                
  printArray(Serial.list());                                              // Print a list of available Serial devices to console 
  String portName = Serial.list()[0];                                     // Replace '0' with the index of your Arduino or Teensy
  
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n');                                                 // Arduino ends each data packet with a new line character
  port.clear();                                                           // Flush the Serial buffer to start clean

  wp.loadTrainARFF("accData.arff");                                       // Load a ARFF dataset
  wp.loadModel("postureSVC.model");                                       // Save the model

  background(52);
}

void draw() {                                                             // Show the incoming data and predicted label
  if (dataUpdated) {

    background(52);
    fill(255);
    
    float[] X = {rawData[0], rawData[1], rawData[2]}; 
    String Y = wp.getPrediction(X);
    
    textSize(32);
    textAlign(CENTER, CENTER);
    
    String text = 
      "Prediction: "+Y+
      "\n X="+rawData[0]+
      "\n Y="+rawData[1]+
      "\n Z="+rawData[2];
    
    text(text, width/2, height/2);

    dataUpdated = false;
  }
}
