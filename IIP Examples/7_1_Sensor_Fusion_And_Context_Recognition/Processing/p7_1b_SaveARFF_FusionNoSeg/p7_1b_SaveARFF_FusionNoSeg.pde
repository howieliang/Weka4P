//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************
import papaya.*;
import processing.serial.*;
Serial port; 

int sensorNum = 5; //number of sensors in use
int streamSize = 500; //number of data to show
int[] rawData = new int[sensorNum];
float[][] sensorHist = new float[sensorNum][streamSize]; //history data to show
float[][] diffArray = new float[sensorNum][streamSize]; //diff calculation: substract
float[] modeArray = new float[streamSize]; //To show activated or not
float[] thldArray = new float[streamSize]; //diff calculation: substract
//int activationThld = 10; //The diff threshold of activiation

//segmentation parameters
float energyMax = 0;
float energyThld = 150; //use energy for activation
float[] energyHist = new float[streamSize]; //history data to show

//FFT parameters
float sampleRate = 125;
int numBins = 33;
int bufferSize = (numBins-1)*2;
//Band pass filter
final int LOW_THLD = 2; //check: why 2?
final int HIGH_THLD = 32; //high threshold of band-pass frequencies
int numBands = HIGH_THLD-LOW_THLD+1;
ezFFT[] fft = new ezFFT[sensorNum]; // fft per sensor
float[][] FFTHist = new float[numBands][streamSize]; //history data to show; //history data to show

//visualization parameters
float fftScale = 3;

//window
int windowSize = 1; //The size of data window
float[][][] windowArray = new float[sensorNum][numBands][windowSize]; //data window collection
boolean b_sampling = false; //flag to keep data collection non-preemptive
int sampleCnt = 0; //counter of samples

//Statistical Features
float[][] windowM = new float[sensorNum][numBands]; //mean
float[][] windowSD = new float[sensorNum][numBands]; //standard deviation
float[][] windowMax = new float[sensorNum][numBands]; //mean

//Save
Table csvData;
boolean b_saveCSV = false;
String dataSetName = "FusionTrain"; 
String[] attrNames;
boolean[] attrIsNominal;
int labelIndex = 0;

float energySound = 0;
float energyLight = 0;
float lastRawLight = 0;
float lastCntLight = 0;
float lastRawSound = 0;
float lastCntSound = 0;
float[][] syncSensorHist = new float[2][numBins];
float[][] featureHist = new float[numBins+2][streamSize];


void setDataType() {
  attrNames =  new String[numBands+3];
  attrIsNominal = new boolean[numBands+3];
  for (int j = 0; j < numBands; j++) {
    attrNames[j] = "f_"+j;
    attrIsNominal[j] = false;
  }
  attrNames[numBands] = "s";
  attrIsNominal[numBands] = false;
  attrNames[numBands+1] = "l";
  attrIsNominal[numBands+1] = false;
  attrNames[numBands+2] = "label";
  attrIsNominal[numBands+2] = true;
}


void setup() {
  size(500, 500, P2D);
  initSerial();
  for (int i = 0; i < 3; i++) { //ezFFT(number of samples, sampleRate)
    fft[i] = new ezFFT(bufferSize, sampleRate);
  }
  for (int i = 0; i < streamSize; i++) { //Initialize all modes as null
    modeArray[i] = -1;
  }
  setDataType();
  initCSV();
}

void draw() {
  background(255);
  for (int i = 0; i < 3; i++) {
    fft[i].updateFFT(sensorHist[i]);
    for (int j = 0; j < numBands; j++) {
      float x = fft[i].getSpectrum()[j+LOW_THLD]; //get the energy of channel j
      appendArrayTail(FFTHist[j], x);             //update fft history
      windowArray[i][j][0] = x; //windowed statistics
    }
  }
  appendArrayTail(syncSensorHist[0], (lastCntSound>0 ? lastRawSound/lastCntSound : 0)); //store the data to history (for visualization)
  appendArrayTail(syncSensorHist[1], (lastCntLight>0 ? lastRawLight/lastCntLight : 0)); //store the data to history (for visualization)
  lastRawSound = lastCntSound = 0;
  lastRawLight = lastCntLight = 0;

  if(mousePressed && (frameCount%6==0)) b_sampling = true;
  else b_sampling = false;
  
  if (b_sampling == true) {
    float[] X = new float[numBands+2]; //Form a feature vector X;
    //float[] X = new float[2]; //Form a feature vector X;
    appendArrayTail(modeArray, labelIndex); //the class is null without mouse pressed.
    TableRow newRow = csvData.addRow();
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < numBands; j++) {
        windowMax[i][j] = max(windowArray[i][j]); //mean
      }
    }
    for (int j = 0; j < numBands; j++) {
      X[j] = max(windowMax[0][j], windowMax[1][j], windowMax[2][j]);
      newRow.setFloat("f_"+j, X[j]);
      appendArrayTail(featureHist[j], X[numBands+0]);
    }
    X[numBands+0] = syncSensorHist[0][numBands-1];//s;
    appendArrayTail(featureHist[numBands+0], X[numBands+0]);
    newRow.setFloat("s", X[numBands+0]);
    X[numBands+1] = syncSensorHist[1][numBands-1];//l;
    newRow.setFloat("l", X[numBands+1]);
    appendArrayTail(featureHist[numBands+1], X[numBands+1]);
    
    newRow.setString("label", getCharFromInteger(labelIndex));
    println(csvData.getRowCount());
    b_sampling = false;
  } else {
    appendArrayTail(modeArray, -1); //the class is null without mouse pressed.
  }
  pushMatrix();
  fft[0].drawSpectrogram(fftScale, 1024, true);
  translate(width/3, 0);
  fft[1].drawSpectrogram(fftScale, 1024, true);
  translate(width/3, 0);
  fft[2].drawSpectrogram(fftScale, 1024, true);
  translate(-2*width/3, 200);
  lineGraph(syncSensorHist[0], 0, 1024, 0, 0, numBins*fftScale, numBins*fftScale, 0, color(255, 0, 0));
  translate(width/3, 0);
  lineGraph(syncSensorHist[1], 0, 1024, 0, 0, numBins*fftScale, numBins*fftScale, 0, color(0, 128, 255));
  translate(width/3, 0);
  popMatrix();

  barGraph(modeArray, 0, height, 0, height-100, 500., 50);
  showInfo("Current Label: "+getCharFromInteger(labelIndex), 320+20, 220, 16);
  showInfo("Num of Data: "+csvData.getRowCount(), 320+20, 240, 16);
  showInfo("[X]:del/[C]:clear", 320+20, 260, 16);
  showInfo("[S]:save/[/]:label+", 320+20, 280, 16);
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
    rawData[4] = int( trim(inData.substring(1)) ); //store the value
    //appendArrayTail(sensorHist[4], rawData[4]); //store the data to history (for visualization)
    lastRawLight += rawData[4];
    lastCntLight += 1;
    return;
  }
  if (inData.charAt(0) == 'B') {  
    rawData[3] = int(trim(inData.substring(1))); //store the value
    //appendArrayTail(sensorHist[3], rawData[3]); //store the data to history (for visualization)
    lastRawSound += rawData[3];
    lastCntSound += 1;
    return;
  }
  if (inData.charAt(0) == 'C') {  
    rawData[0] = int(trim(inData.substring(1))); //store the value
    appendArrayTail(sensorHist[0], rawData[0]); //store the data to history (for visualization)
    float diff = abs(sensorHist[0][sensorHist[0].length-1] - sensorHist[0][sensorHist[0].length-2]); //normal diff
    appendArrayTail(diffArray[0], diff);
    return;
  }
  if (inData.charAt(0) == 'D') {  
    rawData[1] = int(trim(inData.substring(1))); //store the value
    appendArrayTail(sensorHist[1], rawData[1]); //store the data to history (for visualization)
    float diff = abs(sensorHist[1][sensorHist[1].length-1] - sensorHist[1][sensorHist[1].length-2]); //normal diff
    appendArrayTail(diffArray[1], diff);
    return;
  }
  if (inData.charAt(0) == 'E') {  
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
