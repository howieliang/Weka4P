//*********************************************
//  A_CollectData_Accelerometer_1_Axis : Collects data from a accelerometer with Arduino with nominal labels
//
//  Author: Rong-Hao Liang <r.liang@tue.nl>
//  Edited by: Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (22 06 2021)
//
//  Manual:
//  Upload the Arduino sketch (Serial_Rx_Tx_MPU6050_500Hz) to your Arduino 
//  (or other board like Teensy), make sure the device is connected.
//
//  You can find this sketch in the Arduino folder of the Accelerometer examples.
//
//  Start the program and make a short gesture.
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
//*********************************************

import papaya.*;

import processing.serial.*;
Serial port; 

int sensorNum = 1; 
int streamSize = 500;
int[] rawData = new int[sensorNum];
float[][] sensorHist = new float[sensorNum][streamSize];                //history data to show

float[][] diffArray = new float[sensorNum][streamSize];                 //diff calculation: substract

float[] modeArray = new float[streamSize];                              //To show activated or not
float[][] thldArray = new float[sensorNum][streamSize];                 //diff calculation: substract
int activationThld = 20;                                                //The diff threshold of activiation

int windowSize = 20;                                                    //The size of data window
float[][] windowArray = new float[sensorNum][windowSize];               //data window collection
boolean b_sampling = false;                                             //flag to keep data collection non-preemptive
int sampleCnt = 0;                                                      //counter of samples

//Statistical Features  
float[] windowM = new float[sensorNum];                                 //mean
float[] windowSD = new float[sensorNum];                                //standard deviation

//Save
Table csvData;
boolean b_saveCSV = false;
String dataSetName = "A0GestTrain"; 
String[] attrNames = new String[]{"m_x", "sd_x", "label"};
boolean[] attrIsNominal = new boolean[]{false, false, true};
int labelIndex = 0;

void setup() {
  size(500, 500, P2D);
  initSerial();
  initCSV();
}

void draw() {
  background(255);
  
  lineGraph(sensorHist[0], 0, 500, 0, 0, width, height/3, 0);           //draw sensor stream
  lineGraph(diffArray[0], 0, 500, 0, height/3, width, height/3, 1);     //history of signal
  lineGraph(thldArray[0], 0, 500, 0, height/3, width, height/3, 2);     //history of signal
 
  barGraph (modeArray, 0, height/3, width, height/3);
  
  showInfo("Thld: "+activationThld, 20, 2*height/3-20);
  showInfo("([A]:+/[Z]:-)", 20, 2*height/3);
  
  lineGraph(windowArray[0], 0, 1023, 0, 2*height/3, width, height/3, 3); //history of window
  
  showInfo("M: "+nf(windowM[0], 0, 2), 20, 2*height/3-60);
  showInfo("SD: "+nf(windowSD[0], 0, 2), 20, 2*height/3-40);
  showInfo("Current Label: "+getCharFromInteger(labelIndex), 20, 20);
  showInfo("Num of Data: "+csvData.getRowCount(), 20, 40);
  showInfo("[X]:del/[C]:clear/[S]:save", 20, 60);
  showInfo("[/]:label+", 20, 80);

  if (b_saveCSV) {
    saveCSV(dataSetName, csvData);
    saveARFF(dataSetName, csvData);
    b_saveCSV = false;
  }
}
