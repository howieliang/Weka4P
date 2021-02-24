//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import papaya.*;

import processing.serial.*;
Serial port;

import Weka4P.*;
Weka4P wp;

int sensorNum = 1; //number of sensors in use
int streamSize = 500; //number of data to show
int[] rawData = new int[sensorNum];
float[][] sensorHist = new float[sensorNum][streamSize]; //history data to show
float[][] diffArray = new float[sensorNum][streamSize]; //diff calculation: substract
float[] modeArray = new float[streamSize]; //To show activated or not
float[] thldArray = new float[streamSize]; //diff calculation: substract
//int activationThld = 10; //The diff threshold of activiation

//segmentation parameters
float energyMax = 0;
float energyThld = 50; //use energy for activation
float[] energyHist = new float[streamSize]; //history data to show

//FFT parameters
float sampleRate = 500;
int numBins = 65;
int bufferSize = (numBins-1)*2;
//Band pass filter
final int LOW_THLD = 2; //check: why 2?
final int HIGH_THLD = 64; //high threshold of band-pass frequencies
int numBands = HIGH_THLD-LOW_THLD+1;
ezFFT[] fft = new ezFFT[sensorNum]; // fft per sensor
float[][] FFTHist = new float[numBands][streamSize]; //history data to show; //history data to show

//visualization parameters
float fftScale = 5;

//window
int windowSize = 20; //The size of data window
float[][] windowArray = new float[numBands][windowSize]; //data window collection
boolean b_sampling = false; //flag to keep data collection non-preemptive
int sampleCnt = 0; //counter of samples
float[] X = new float[numBands]; //Form a feature vector X;

//Statistical Features
float[] windowM = new float[numBands]; //mean
float[] windowSD = new float[numBands]; //standard deviation

//Save
Table csvData;
boolean b_saveCSV = false;
String dataSetName = "A0VibTrain"; 
String[] attrNames;
boolean[] attrIsNominal;
int labelIndex = 0;

boolean bShowInfo = true;

String lastPredY = "";

void setDataType() {
  attrNames =  new String[numBands+1];
  attrIsNominal = new boolean[numBands+1];
  for (int j = 0; j < numBands; j++) {
    attrNames[j] = "f_"+j;
    attrIsNominal[j] = false;
  }
  attrNames[numBands] = "label";
  attrIsNominal[numBands] = true;
}


void setup() {
  size(500, 500, P2D);
  wp = new Weka4P(this);
  
  initSerial();
  for (int i = 0; i < sensorNum; i++) { //ezFFT(number of samples, sampleRate)
    fft[i] = new ezFFT(bufferSize, sampleRate);
  }
  for (int i = 0; i < streamSize; i++) { //Initialize all modes as null
    modeArray[i] = -1;
  }
  wp.loadTrainARFF("A0VibTrain.arff"); //load a ARFF dataset
  wp.trainLinearSVC(64);             //train a SV classifier with C = 64
  wp.evaluateTrainSet(5, false, true);  //5-fold cross validation (fold=5, isRegression=false, showEvalDetails=true)
  wp.saveModel("LinearSVC.model"); //save the model
}

void draw() {
  background(255);
  energyMax = 0; //reset the measurement of energySum
  //for (int i = 0; i < sensorNum; i++) {
  fft[0].updateFFT(sensorHist[0]);
  for (int j = 0; j < numBands; j++) {
    float x = fft[0].getSpectrum()[j+LOW_THLD]; //get the energy of channel j
    if (x>energyMax) energyMax = x;             //check energyMax: the max energy of all channels
    appendArrayTail(FFTHist[j], x);             //update fft history

    //X[j] = x; //make feature matrix
    if (b_sampling == true) {
      windowArray[j][sampleCnt-1] = x; //windowed statistics
    }
  }
  //}

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
    //appendArrayTail(modeArray, labelIndex); //the class is null without mouse pressed.
    if (sampleCnt == windowSize) {
      for (int j = 0; j < numBands; j++) {
        windowM[j] = Descriptive.mean(windowArray[j]); //mean
        windowSD[j] = Descriptive.std(windowArray[j], true); //standard deviation
        X[j] = max(windowArray[j]);
      }
      lastPredY = wp.getPrediction(X);
      double yID = wp.getPredictionIndex(X);
      for(int n = 0 ; n < windowSize ; n++){
        appendArrayTail(modeArray, (float)yID);
      }
      b_sampling = false;
    }
  } else {
    appendArrayTail(modeArray, -1); //the class is null without mouse pressed.
  }

  appendArrayTail(energyHist, energyMax); //update energyMax history
  appendArrayTail(thldArray, energyThld);
  fft[0].drawSpectrogram(fftScale, 1024, true);

  barGraph(modeArray, 0, height, 0, height-100, 500., 50);

  lineGraph(energyHist, 0, height, 0, height-150, 500., 50, 0, color(0, 255, 0));
  lineGraph(thldArray, 0, height, 0, height-150, 500., 50, 0, color(128, 0, 255));

  for (int j = 0; j < numBands; j++) {
    float x = 60 + 80*(j%2);
    float y = height-180-(j)*fftScale;
    //showInfo("M: "+nf(windowM[j], 0, 1)+", SD: "+nf(windowSD[j], 0, 1), x, y, (int)fftScale*2);
    showInfo("X["+j+"] = "+nf(X[j], 0, 0), x, y, (int)fftScale*2);
  }
  String Y = lastPredY;
  showInfo("Prediction: "+Y, 320+20, 20,16);
  showInfo("Threshold: "+energyThld+" ([A]:+/[Z]:-)", 20, height-118, 18);
  drawFFTInfo(20, height-100, 18);
  if (b_saveCSV) {
    saveCSV(dataSetName, csvData);
    saveARFF(dataSetName, csvData);
    b_saveCSV = false;
  }
}

void keyPressed() {
  if (key == 'A' || key == 'a') {
    energyThld = min(energyThld+5, 100);
  }
  if (key == 'Z' || key == 'z') {
    energyThld = max(energyThld-5, 10);
  }
  if (key == 'C' || key == 'c') {
    csvData.clearRows();
    println(csvData.getRowCount());
  }
  if (key == 'X' || key == 'x') {
    csvData.removeRow(csvData.getRowCount()-1);
  }
  if (key == 'S' || key == 's') {
    b_saveCSV = true;
  }
  if (key == '/') {
    ++labelIndex;
    labelIndex %= 10;
  }
  if (key == '0') {
    labelIndex = 0;
  }
}

float[] appendArrayTail (float[] _array, float _val) {
  float[] array = _array;
  float[] tempArray = new float[_array.length-1];
  arrayCopy(array, 1, tempArray, 0, tempArray.length);
  array[tempArray.length] = _val;
  arrayCopy(tempArray, 0, array, 0, tempArray.length);
  return array;
}

void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');  // read the serial string until seeing a carriage return
  //assign data index based on the header
  if (inData.charAt(0) == 'A') {  
    rawData[0] = int(trim(inData.substring(1))); //store the value
    appendArrayTail(sensorHist[0], rawData[0]); //store the data to history (for visualization)
    float diff = abs(sensorHist[0][sensorHist[0].length-1] - sensorHist[0][sensorHist[0].length-2]); //normal diff
    appendArrayTail(diffArray[0], diff);
    return;
  }
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
