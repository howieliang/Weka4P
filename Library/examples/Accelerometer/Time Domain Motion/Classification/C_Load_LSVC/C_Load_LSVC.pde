//*********************************************
//  C_LoadModel_LSVC : Load a Linear Support Vector Classifier model
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

import papaya.*;
import processing.serial.*;
Serial port; 

int sensorNum = 1; 
int streamSize = 500;
int[] rawData = new int[sensorNum];
float[][] sensorHist = new float[sensorNum][streamSize];        //history data to show

float[][] diffArray = new float[sensorNum][streamSize];         //diff calculation: substract

float[] modeArray = new float[streamSize];                      //To show activated or not
float[][] thldArray = new float[sensorNum][streamSize];         //diff calculation: substract
int activationThld = 20;                                        //The diff threshold of activiation

int windowSize = 20;                                            //The size of data window
float[][] windowArray = new float[sensorNum][windowSize];       //data window collection
boolean b_sampling = false;                                     //flag to keep data collection non-preemptive
int sampleCnt = 0;                                              //counter of samples

float m_x = -1;
float sd_x = -1;
boolean bShowInfo = true;

void setup() {
  size(500, 500, P2D);
  wp = new Weka4P(this);
  initSerial();
  wp.loadTrainARFF("A0GestTrain.arff");                         //load a ARFF dataset
  wp.loadModel("LinearSVC.model");                              //load a pretrained model.
  wp.setModelDrawing(2);                                        //set the model visualization (for 2D features) with unit 2
}

void draw() {
  wp.drawModel(0, 0);                                           //draw the model visualization (for 2D features)
  float[] X = {m_x, sd_x}; 
  String Y = wp.getPrediction(X);
  wp.drawPrediction(X, Y);                                      //draw the prediction
  if (bShowInfo) {
    showInfo("Thld: "+activationThld, 20, height-40);
    showInfo("([A]:+/[Z]:-)", 20, height-20);
  }
}
