//*********************************************
//  C_Load_LSVC : Load a Linear Support Vector Classifier model
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

int sensorNum = 3; 
int streamSize = 500;
int[] rawData = new int[sensorNum];
float[][] sensorHist = new float[sensorNum][streamSize];                            //history data to show

float[][] diffArray = new float[sensorNum][streamSize];                             //diff calculation: substract

float[] modeArray = new float[streamSize];                                          //To show activated or not
float[][] thldArray = new float[sensorNum][streamSize];                             //diff calculation: substract
int activationThld = 20;                                                            //The diff threshold of activiation

int windowSize = 20;                                                                //The size of data window
float[][] windowArray = new float[sensorNum][windowSize];                           //data window collection
boolean b_sampling = false;                                                         //flag to keep data collection non-preemptive
int sampleCnt = 0;                                                                  //counter of samples

float m_x = -1;
float sd_x = -1;
float m_y = -1;
float sd_y = -1;
float m_z = -1;
float sd_z = -1;
boolean bShowInfo = true;

void setup() {
  size(500, 500, P2D);
  wp = new Weka4P(this);
  initSerial();
  wp.loadTrainARFF("A012GestTrain.arff");                                          //load a ARFF dataset
  wp.setModelDrawing(2);                                                           //set the model visualization (for 2D features) unit=2
  wp.loadModel("LinearSVC.model");                                                 //load the model
}

void draw() {
  background(255);

  float[] X = {m_x, sd_x,m_y, sd_y,m_z, sd_z}; 

  String Y = wp.getPrediction(X);
  showInfo("Pred: "+Y,20,20);

  for(int n = 0 ; n < X.length; n++) showInfo("["+X[n]+"]",20,(n+2)*20);
}


