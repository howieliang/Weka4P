//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import papaya.*;

import ddf.minim.analysis.*;
import ddf.minim.*;

import Weka4P.*;
Weka4P wp;

Minim minim;
AudioInput in;
FFT fft;

int streamSize = 500;
float sampleRate = 44100/5;
int numBins = 1025;
int bufferSize = (numBins-1)*2;
//FFT parameters
float[][] FFTHist;
final int LOW_THLD = 1; //low threshold of band-pass frequencies
final int HIGH_THLD = 200; //high threshold of band-pass frequencies 
int numBands = HIGH_THLD-LOW_THLD+1; //number of feature
float[] modeArray = new float[streamSize]; //classification to show
float[] thldArray = new float[streamSize]; //diff calculation: substract

//segmentation parameters
float energyMax = 0;
float energyThld = 5;
float[] energyHist = new float[streamSize]; //history data to show//segmentation parameters

//window
int windowSize = 10; //The size of data window
float[][] windowArray = new float[numBands][windowSize]; //data window collection
boolean b_sampling = false; //flag to keep data collection non-preemptive
int sampleCnt = 0; //counter of samples

//Statistical Features
float[] windowM = new float[numBands]; //mean
float[] windowSD = new float[numBands]; //standard deviation

//Save
Table csvData;
boolean b_saveCSV = false;
String dataSetName = "MicTrain"; 
String[] attrNames;
boolean[] attrIsNominal;
int labelIndex = 0;

String lastPredY = "";

void setDataType(){
  attrNames =  new String[numBands+1];
  attrIsNominal = new boolean[numBands+1];
  for (int j = 0; j < numBands; j++) {
    attrNames[j] = "f_"+j;
    attrIsNominal[j] = false;
  }
  attrNames[numBands] = "label";
  attrIsNominal[numBands] = true;
}


void setup()
{
  size(700, 700, P2D);
  wp = new Weka4P(this);
  // setup audio input
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.window(FFT.NONE);
  FFTHist = new float[numBands][streamSize]; //history data to show
  for (int i = 0; i < modeArray.length; i++) { //Initialize all modes as null
    modeArray[i] = -1;
  }
  wp.loadTrainARFF("MicTrain.arff"); //load a ARFF dataset
  wp.loadModel("LinearSVC.model"); //load a pretrained model.
}

void draw()
{
  background(255);
  fft.forward(in.mix.toArray());
  
  float[] X = new float[numBands]; //Form a feature vector X;
  
  energyMax = 0; //reset the measurement of energySum
  for (int i = 0; i < HIGH_THLD-LOW_THLD; i++) {
    float x = fft.getBand(i+LOW_THLD);
    if (x>energyMax) energyMax = x;
    if (b_sampling == true) {
      if (x>X[i]) X[i] = x; //simple windowed max
      windowArray[i][sampleCnt-1] = x; //windowed statistics
    }
  }
  
  if (energyMax>energyThld) {
    if (b_sampling == false) { //if not sampling
      b_sampling = true; //do sampling
      sampleCnt = 0; //reset the counter
      for (int j = 0; j < numBands; j++) {
        X[j] = 0; //reset the feature vector
        for (int k = 0; k < windowSize; k++) {
          (windowArray[j])[k] = 0; //reset the window
        }
      }
    }
  } 
  
  if (b_sampling == true) {
    ++sampleCnt;
    if (sampleCnt == windowSize) {
      for (int j = 0; j < numBands; j++) {
        windowM[j] = Descriptive.mean(windowArray[j]); //mean
        windowSD[j] = Descriptive.std(windowArray[j], true); //standard deviation
        X[j] = max(windowArray[j]);
      }
      b_sampling = false;
      lastPredY = wp.getPrediction(X);
      double yID = wp.getPredictionIndex(X);
      for(int n = 0 ; n < windowSize ; n++){
        appendArrayTail(modeArray, (float)yID);
      }
    }
  } else {
    appendArrayTail(modeArray, -1); //the class is null without mouse pressed.
  }
  
  appendArrayTail(energyHist, energyMax); //the class is null without mouse pressed.
  appendArrayTail(thldArray, energyThld);
  barGraph(modeArray, 0, height, 0, height-100, 500., 50);
  drawSpectrogram();
  lineGraph(energyHist, 0, 50, 0, height-150, 500., 50, 0, color(0, 255, 0));
  lineGraph(thldArray, 0, 50, 0, height-150, 500., 50, 0, color(128, 0, 255));
  
  String Y = lastPredY;
  showInfo("Prediction: "+Y, 520+20, 20,16);
  showInfo("Window size: "+windowSize, 20, height-126, 18);
  showInfo("Threshold: "+energyThld+" ([A]:+/[Z]:-)", 20, height-108, 18);
  drawFFTInfo(20, height-100, 18);
  
  if (b_saveCSV) {
    saveCSV(dataSetName, csvData);
    saveARFF(dataSetName, csvData);
    b_saveCSV = false;
  }
}

void stop()
{
  // always close Minim audio classes when you finish with them
  in.close();
  minim.stop();
  super.stop();
}
