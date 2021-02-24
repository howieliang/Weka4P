//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import processing.serial.*;
Serial port; 

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

  double[] X = new double[numBands]; //Form a feature vector X;
  energyMax = 0; //reset the measurement of energySum
  for (int i = 0; i < sensorNum; i++) {
    fft[0].updateFFT(sensorHist[i]);
    for (int j = 0; j < numBands; j++) {
      float x = fft[i].getSpectrum()[j+LOW_THLD]; //get the energy of channel j
      if (x>energyMax) energyMax = x;             //check energyMax: the max energy of all channels
      appendArrayTail(FFTHist[j], x);             //update fft history

      X[j] = x; //make feature matrix
    }
  }

  appendArrayTail(energyHist, energyMax); //update energyMax history
  appendArrayTail(thldArray, energyThld);
  fft[0].drawSpectrogram(fftScale, 1024, true);

  barGraph(modeArray, 0, height, 0, height-100, 500., 50);

  lineGraph(energyHist, 0, height, 0, height-150, 500., 50, 0, color(0, 255, 0));
  lineGraph(thldArray, 0, height, 0, height-150, 500., 50, 0, color(128, 0, 255));
  for (int i = 0; i < sensorNum; i++) {
    lineGraph(sensorHist[i], 0, height, 0, height-100, 500, 50, 0, color(255, 0, 0));
    lineGraph(diffArray[i], 0, 100, 0, height-50, 500, 50, 0, color(0, 0, 255));
  }

  showInfo("Threshold: "+energyThld, 20, height-118, 18);
  drawFFTInfo(20, height-100, 18);
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
