//*********************************************
//  A_CollectData : Collects data from a microphone with Arduino
//
//  Author: Rong-Hao Liang <r.liang@tue.nl>
//  Edited by: Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (22 06 2021)
//
//  Manual:
//  Upload the Arduino sketch (ThreeSensors_500Hz) to your Arduino 
//  (or other board like Teensy), make sure the device is connected.
//
//  You can find this sketch in the Arduino folder of the microphone examples.
//
//  Start the program and make vibrations as a gesture
//
//  Press the "s" key on your keyboard to save 
//  the data to an ARFF and a CSV file.
//
//  You have to press 's' for save for every new label.
//
//  You can find these files in the data folder
//  in your sketch folder.
//  Sketch -> Show Sketch Folder (ctrl/cmd + K)
// 
//  To increase the label press '/' or right click (max 10 labels)
//  To reset the label to 0 press '0' 
//
//  To clear the data table press "c"
//
//*********************************************


import papaya.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
FFT fft;

int streamSize = 500;
float sampleRate = 44100/5;
int numBins = 1025;
int bufferSize = (numBins-1)*2;

//FFT parameters
float[][] FFTHist;
final int LOW_THLD = 1;                                   //low threshold of band-pass frequencies
final int HIGH_THLD = 200;                                //high threshold of band-pass frequencies 
int numBands = HIGH_THLD-LOW_THLD+1;                      //number of feature
float[] modeArray = new float[streamSize];                //classification to show
float[] thldArray = new float[streamSize];                //diff calculation: substract

//segmentation parameters
float energyMax = 0;
float energyThld = 5;
float[] energyHist = new float[streamSize];               //history data to show

//window
int windowSize = 10;                                      //The size of data window
float[][] windowArray = new float[numBands][windowSize];  //data window collection
boolean b_sampling = false;                               //flag to keep data collection non-preemptive
int sampleCnt = 0;                                        //counter of samples

//Statistical Features
float[] windowM = new float[numBands];                    //mean
float[] windowSD = new float[numBands];                   //standard deviation

//Save
Table csvData;
boolean b_saveCSV = false;
String dataSetName = "MicTrain"; 
String[] attrNames;
boolean[] attrIsNominal;
int labelIndex = 0;

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
  // setup audio input
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.window(FFT.NONE);
  FFTHist = new float[numBands][streamSize];               //history data to show
  for (int i = 0; i < modeArray.length; i++) {             //Initialize all modes as null
    modeArray[i] = -1;
  }
  setDataType();
  initCSV();
}

void draw()
{
  background(255);
  fft.forward(in.mix.toArray());
  
  float[] X = new float[numBands];                         //Form a feature vector X;
  
  energyMax = 0;                                           //reset the measurement of energySum
  for (int i = 0; i < HIGH_THLD-LOW_THLD; i++) {
    float x = fft.getBand(i+LOW_THLD);
    if (x>energyMax) energyMax = x;
    if (b_sampling == true) {
      if (x>X[i]) X[i] = x;                                //simple windowed max
      windowArray[i][sampleCnt-1] = x;                     //windowed statistics
    }
  }
  
  if (energyMax>energyThld) {
    if (b_sampling == false) {                              //if not sampling
      b_sampling = true;                                    //do sampling
      sampleCnt = 0;                                        //reset the counter
      for (int j = 0; j < numBands; j++) {
        X[j] = 0;                                           //reset the feature vector
        for (int k = 0; k < windowSize; k++) {
          (windowArray[j])[k] = 0;                          //reset the window
        }
      }
    }
  } 
  
  if (b_sampling == true) {
    ++sampleCnt;
    appendArrayTail(modeArray, labelIndex);                 //the class is null without mouse pressed.
    if (sampleCnt == windowSize) {
      TableRow newRow = csvData.addRow();
      for (int j = 0; j < numBands; j++) {
        //windowM[j] = Descriptive.mean(windowArray[j]);        //mean
        //windowSD[j] = Descriptive.std(windowArray[j], true); //standard deviation
        X[j] = max(windowArray[j]);
        newRow.setFloat("f_"+j, X[j]);
      }
      newRow.setString("label", getCharFromInteger(labelIndex));
      println(csvData.getRowCount());
      b_sampling = false;
    }
  } else {
    appendArrayTail(modeArray, -1);                           //the class is null without mouse pressed.
  }
  
  appendArrayTail(energyHist, energyMax);                     //the class is null without mouse pressed.
  appendArrayTail(thldArray, energyThld);
  barGraph(modeArray, 0, height, 0, height-100, 500., 50);
  drawSpectrogram();
  lineGraph(energyHist, 0, 50, 0, height-150, 500., 50, 0, color(0, 255, 0));
  lineGraph(thldArray, 0, 50, 0, height-150, 500., 50, 0, color(128, 0, 255));
  
  showInfo("Window size: "+windowSize, 20, height-126, 18);
  showInfo("Threshold: "+energyThld+" ([A]:+/[Z]:-)", 20, height-108, 18);
  showInfo("Current Label: "+getCharFromInteger(labelIndex), 520+20, 20,16);
  showInfo("Num of Data: "+csvData.getRowCount(), 520+20, 40,16);
  showInfo("[X]:del/[C]:clear", 520+20, 60,16);
  showInfo("[S]:save/[/]:label+", 520+20, 80,16);
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
