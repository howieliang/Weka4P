//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import papaya.*;
import processing.serial.*;
Serial port; 

int sensorNum = 3; //number of sensors in use
int streamSize = 500; //number of data to show
int[] rawData = new int[sensorNum];
float[][] sensorHist = new float[sensorNum][streamSize]; //history data to show
float[][] diffArray = new float[sensorNum][streamSize]; //diff calculation: substract
float[] modeArray = new float[streamSize]; //To show activated or not
float[] thldArray = new float[streamSize]; //diff calculation: substract
//int activationThld = 10; //The diff threshold of activiation

//segmentation parameters
float energyMax = 0;
float energyThld = 100; //use energy for activation
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
float fftScale = 2;

//window
int windowSize = 20; //The size of data window
float[][][] windowArray = new float[sensorNum][numBands][windowSize]; //data window collection
boolean b_sampling = false; //flag to keep data collection non-preemptive
int sampleCnt = 0; //counter of samples

//Statistical Features
float[][] windowM = new float[sensorNum][numBands]; //mean
float[][] windowSD = new float[sensorNum][numBands]; //standard deviation
float[][] windowMax = new float[sensorNum][numBands]; //mean

void setup() {
  size(500, 500, P2D);
  initSerial();
  for (int i = 0; i < sensorNum; i++) { //ezFFT(number of samples, sampleRate)
    fft[i] = new ezFFT(bufferSize, sampleRate);
  }
  for (int i = 0; i < streamSize; i++) { //Initialize all modes as null
    modeArray[i] = -1;
  }
}

void draw() {
  background(255);

  float[] X = new float[numBands]; //Form a feature vector X;
  energyMax = 0; //reset the measurement of energySum
  for (int i = 0; i < sensorNum; i++) {
    fft[i].updateFFT(sensorHist[i]);
    for (int j = 0; j < numBands; j++) {
      float x = fft[i].getSpectrum()[j+LOW_THLD]; //get the energy of channel j
      if (x>energyMax) energyMax = x;             //check energyMax: the max energy of all channels
      appendArrayTail(FFTHist[j], x);             //update fft history
      if (b_sampling == true) {
        windowArray[i][j][sampleCnt-1] = x; //windowed statistics
      }
    }
  }

  if (energyMax>energyThld) {
    if (b_sampling == false) { //if not sampling
      b_sampling = true; //do sampling
      sampleCnt = 0; //reset the counter
      for (int j = 0; j < numBands; j++) {
        X[j] = 0; //reset the feature vector
      }
      for (int i = 0; i < sensorNum; i++) {
        for (int j = 0; j < numBands; j++) {
          for (int k = 0; k < windowSize; k++) {
            (windowArray[i][j])[k] = 0; //reset the window
          }
        }
      }
    }
  }

  if (b_sampling == true) {
    ++sampleCnt;
    appendArrayTail(modeArray, 0); //the class is null without mouse pressed.
    if (sampleCnt == windowSize) {
      for (int i = 0; i < sensorNum; i++) {
        for (int j = 0; j < numBands; j++) {
          //windowM[i][j] = Descriptive.mean(windowArray[i][j]); //mean
          //windowSD[i][j] = Descriptive.std(windowArray[i][j], true); //standard deviation
          windowMax[i][j] = max(windowArray[i][j]); //mean
        }
      }

      for (int j = 0; j < numBands; j++) {
        X[j] = max(windowMax[0][j], windowMax[1][j], windowMax[2][j]);
      }
      b_sampling = false;
    }
  } else {
    appendArrayTail(modeArray, -1); //the class is null without mouse pressed.
  }

  appendArrayTail(energyHist, energyMax); //update energyMax history
  appendArrayTail(thldArray, energyThld);
  
  pushMatrix();
  fft[0].drawSpectrogram(fftScale, 1024, true);
  translate(0, 200);
  fft[1].drawSpectrogram(fftScale, 1024, true);
  translate(200, 0);
  fft[2].drawSpectrogram(fftScale, 1024, true);
  popMatrix();
  
  barGraph(modeArray, 0, height, 0, height-100, 500., 50);

  lineGraph(energyHist, 0, height, 0, height-150, 500., 50, 0, color(0, 255, 0));
  lineGraph(thldArray, 0, height, 0, height-150, 500., 50, 0, color(128, 0, 255));

  showInfo("Window size: "+windowSize, 20, height-136, 18);
  showInfo("Threshold: "+energyThld+" ([A]:+/[Z]:-)", 20, height-118, 18);
}

void keyPressed() {
  if (key == 'A' || key == 'a') {
    energyThld = min(energyThld+5, 100);
  }
  if (key == 'Z' || key == 'z') {
    energyThld = max(energyThld-5, 10);
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
  if (inData.charAt(0) == 'B') {  
    rawData[1] = int(trim(inData.substring(1))); //store the value
    appendArrayTail(sensorHist[1], rawData[1]); //store the data to history (for visualization)
    float diff = abs(sensorHist[1][sensorHist[1].length-1] - sensorHist[1][sensorHist[1].length-2]); //normal diff
    appendArrayTail(diffArray[1], diff);
    return;
  }
  if (inData.charAt(0) == 'C') {  
    rawData[2] = int(trim(inData.substring(1))); //store the value
    appendArrayTail(sensorHist[2], rawData[2]); //store the data to history (for visualization)
    float diff = abs(sensorHist[2][sensorHist[2].length-1] - sensorHist[2][sensorHist[2].length-2]); //normal diff
    appendArrayTail(diffArray[2], diff);
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
