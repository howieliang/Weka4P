//*********************************************
//  B_Train_LSVC : Trains a Linear Support Vector Classifier from Histogram Data
//
//  Author:     Rong-Hao Liang <r.liang@tue.nl>
//  Edited by:  Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (23 06 2021)
//
//  Manual:
//  Drag the .arff file into this sketch window or
//  copy the .arff file to the data folder of this sketch.
//  Sketch -> Show Sketch Folder (ctrl/cmd + K)
//
//  You can generate your own data by using the A CollectData example  
//
//  The program will train a LSVC with the data provided
//  and visualizes the model.
//
//*********************************************

import papaya.*;
import Weka4P.*;
Weka4P wp;

import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import org.opencv.core.Mat;

Capture video;
OpenCV opencv;

PImage img, imgGray, imgR, imgG, imgB, imgH, imgS, imgV;
Histogram grayHist; 
Histogram rHist, gHist, bHist;
Histogram hHist, sHist, vHist;

int div = 2, binNum = 16;


int sensorNum = binNum*3;                                           //number of sensors in use
int dataNum = 500;                                                  //number of data to show
float[] rawData = new float[sensorNum];
float[][] sensorHist = new float[sensorNum][dataNum];               //history data to show
float[] modeArray = new float[dataNum];                             //classification to show

//Save
Table csvData;
boolean b_saveCSV = false;
String dataSetName = "RGBHistTrain"; 
String[] attrNames;
boolean[] attrIsNominal;
int labelIndex = 0;

boolean b_sampling = false;                                         //flag to keep data collection non-preemptive
int sampleCnt = 0;                                                  //counter of samples

int w = 160, h = 120, d = 10;

String lastPredY = "";
void setDataType() {
  attrNames =  new String[sensorNum+1];
  attrIsNominal = new boolean[sensorNum+1];
  for (int j = 0; j < sensorNum; j++) {
    attrNames[j] = "h_"+j;
    attrIsNominal[j] = false;
  }
  attrNames[sensorNum] = "label";
  attrIsNominal[sensorNum] = true;
}

void setup() {
  size(500, 500);
  wp = new Weka4P(this);
  video = new Capture(this, 640/div, 480/div, Capture.list()[0]);
  opencv = new OpenCV(this, 640/div, 480/div);
  video.start();
  wp.loadTrainARFF("RGBHistTrain.arff");                            //load a ARFF dataset
  wp.trainLinearSVC(64);                                            //train a SV classifier C=64
  wp.evaluateTrainSet(5, false, true);                              //5-fold cross validation (fold=5, isRegression=false, showEvalDetails=true)
  wp.saveModel("LinearSVC.model");                                  //save the models
}

void draw() {
  background(255);
  updateChannels();
  Mat matR = rHist.getMat();
  Mat matG = gHist.getMat();
  Mat matB = bHist.getMat();
  for (int i = 0; i < binNum; i++) {
    rawData[0*binNum+i] = (float)matR.get(i, 0)[0];
    rawData[1*binNum+i] = (float)matG.get(i, 0)[0];
    rawData[2*binNum+i] = (float)matB.get(i, 0)[0];
  }

  float[] X = new float[sensorNum];                                 //Form a feature vector X;
  for (int i = 0; i < sensorNum; i++) {
    X[i] = rawData[i];
  }
  lastPredY = wp.getPrediction(X);
  double yID = wp.getPredictionIndex(X);
  appendArrayTail(modeArray, (float)yID);                           //the class is null without mouse pressed.

  image(img, 0, 0, w, h);
  drawImage(imgR, rHist, 0*(w+d), 1*(h+d), w, h, color(255, 0, 0), "Red");
  drawImage(imgG, gHist, 1*(w+d), 1*(h+d), w, h, color(0, 255, 0), "Green");
  drawImage(imgB, bHist, 2*(w+d), 1*(h+d), w, h, color(0, 0, 255), "Blue");
  barGraph(modeArray, 0, height, 0, height-50, 500., 50);
  showInfo("Predict: "+lastPredY, 320+20, 20, 16);

  if (b_saveCSV) {
    saveCSV(dataSetName, csvData);
    saveARFF(dataSetName, csvData);
    b_saveCSV = false;
  }
}

void captureEvent(Capture c) {
  c.read();
}

void updateChannels() {
  opencv.useGray();
  opencv.loadImage(video);
  imgGray = opencv.getSnapshot();
  grayHist = opencv.findHistogram(opencv.getGray(), binNum);

  opencv.useColor();
  opencv.loadImage(video);
  rHist = opencv.findHistogram(opencv.getR(), binNum);
  gHist = opencv.findHistogram(opencv.getG(), binNum);
  bHist = opencv.findHistogram(opencv.getB(), binNum);
  imgR = opencv.getSnapshot(opencv.getR());
  imgG = opencv.getSnapshot(opencv.getG());
  imgB = opencv.getSnapshot(opencv.getB());
  img = opencv.getSnapshot();

  opencv.useColor(HSB);
  opencv.loadImage(video);
  hHist = opencv.findHistogram(opencv.getH(), binNum);
  sHist = opencv.findHistogram(opencv.getS(), binNum);  
  vHist = opencv.findHistogram(opencv.getV(), binNum);
  imgH = opencv.getSnapshot(opencv.getH());
  imgS = opencv.getSnapshot(opencv.getS());  
  imgV = opencv.getSnapshot(opencv.getV());
}
void drawChannels() {
  image(img, 0, 0, w, h);
  drawImage(imgGray, grayHist, 1*(w+d), 0*(h+d), w, h, color(255), "Gray");
  drawImage(imgR, rHist, 0*(w+d), 1*(h+d), w, h, color(255, 0, 0), "Red");
  drawImage(imgG, gHist, 1*(w+d), 1*(h+d), w, h, color(0, 255, 0), "Green");
  drawImage(imgB, bHist, 2*(w+d), 1*(h+d), w, h, color(0, 0, 255), "Blue");
  drawImage(imgH, hHist, 0*(w+d), 2*(h+d), w, h, color(255), "Hue");
  drawImage(imgS, sHist, 1*(w+d), 2*(h+d), w, h, color(255), "Saturation");
  drawImage(imgV, vHist, 2*(w+d), 2*(h+d), w, h, color(255), "Brightness");
}

void drawImage(PImage imgR, Histogram rHist, int x, int y, int w, int h, color c, String name) {
  pushMatrix();
  translate(x, y);
  pushStyle();
  stroke(c); 
  noFill();
  pushStyle();
  imageMode(CORNER);
  tint(c);
  image(imgR, 0, 0, w, h);
  popStyle();
  rHist.draw( 0, 0, w, h);
  stroke(c); 
  noFill();  
  rect( 0, 0, w, h);
  fill(255);
  noStroke();
  textSize(18);
  text(name, 4, 22);
  popStyle();
  popMatrix();
}

float[] appendArrayTail (float[] _array, float _val) {
  float[] array = _array;
  float[] tempArray = new float[_array.length-1];
  arrayCopy(array, 1, tempArray, 0, tempArray.length);
  array[tempArray.length] = _val;
  arrayCopy(tempArray, 0, array, 0, tempArray.length);
  return array;
}
