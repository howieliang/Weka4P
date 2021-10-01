//*********************************************
//  B_Train_LReg : Trains a Linear Regressor from Accelorometer Data
//
//  Author:     Rong-Hao Liang <r.liang@tue.nl>
//  Edited by:  Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (22 06 2021)
//
//  Manual:
//  Drag the .arff file into this sketch window or
//  copy the .arff file to the data folder of this sketch.
//  Sketch -> Show Sketch Folder (ctrl/cmd + K)
//
//  You can generate your own data by using the A CollectData Accelometer 3 Axes example  
//
//  The program will train a LReg with the data provided
//  and visualizes the model.
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
float[][] sensorHist = new float[sensorNum][streamSize];          //history data to show

float[][] diffArray = new float[sensorNum][streamSize];           //diff calculation: substract

float[] modeArray = new float[streamSize];                        //To show activated or not
float[][] thldArray = new float[sensorNum][streamSize];           //diff calculation: substract
int activationThld = 10;                                          //The diff threshold of activiation

int windowSize = 20;                                              //The size of data window
float[][] windowArray = new float[sensorNum][windowSize];         //data window collection
boolean b_sampling = false;                                       //flag to keep data collection non-preemptive
int sampleCnt = 0;                                                //counter of samples

//Save
Table csvData;
boolean b_saveCSV = false;
String dataSetName = "A0GestTest"; 
String[] attrNames = new String[]{"m_x", "sd_x", "label"};
boolean[] attrIsNominal = new boolean[]{false, false, true};
int labelIndex = 0;

float m_x = -1;
float sd_x = -1;
boolean bShowInfo = true;

void setup() {
  size(500, 500, P2D);
  wp = new Weka4P(this);
  initSerial();
  wp.loadTrainARFF("A0GestTrainNum.arff");                        //load a ARFF dataset
  wp.trainLinearRegression();                                     //train a SV classifier
  wp.setModelDrawing(2);                                          //set the model visualization (for 2D features) with unit = 2
  wp.evaluateTrainSet(5, false, true);                            //5-fold cross validation (fold=5, isRegression=false, showEvalDetails=true)
  wp.saveModel("LinearReg.model");                                //save the model
}

void draw() {
  wp.drawModel(0, 0);                                             //draw the model visualization (for 2D features)
  wp.drawDataPoints(wp.train);                                    //draw the datapoints
  float[] X = {m_x, sd_x}; 
  double Y = wp.getPredictionIndex(X);
  wp.drawPrediction(X, Y);                                        //draw the prediction
  if (bShowInfo) {
    showInfo("Thld: "+activationThld, 20, height-40);
    showInfo("([A]:+/[Z]:-)", 20, height-20);
  }
}
