//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import papaya.*;
import Weka4P.*;
Weka4P wp;

int sensorNum = 10; //number of sensors in use
int dataNum = 500; //number of data to show
float[] rawData = new float[sensorNum];
float[][] sensorHist = new float[sensorNum][dataNum]; //history data to show
float[] modeArray = new float[dataNum]; //classification to show

//Save
Table csvData;
boolean b_saveCSV = false;
String dataSetName = "FingerTrain"; 
String[] attrNames;
boolean[] attrIsNominal;
int labelIndex = 0;

boolean b_sampling = false; //flag to keep data collection non-preemptive
int sampleCnt = 0; //counter of samples

String lastPredY = "";

void setDataType() {
  attrNames =  new String[sensorNum+1];
  attrIsNominal = new boolean[sensorNum+1];
  for (int j = 0; j < sensorNum; j++) {
    attrNames[j] = "d_"+j;
    attrIsNominal[j] = false;
  }
  attrNames[sensorNum] = "label";
  attrIsNominal[sensorNum] = true;
}

void setup() {
  size(640, 480, P3D);
  wp = new Weka4P(this);
  background(255);
  leap = new LeapMotion(this);
  imageMode(CENTER);
  wp.loadTrainARFF("FingerTrain.arff"); //load a ARFF dataset
  wp.trainLinearSVC(64);             //train a SV classifier C=64
  wp.evaluateTrainSet(5, false, true);  //5-fold cross validation (fold=5, isRegression=false, showEvalDetails=true)
  wp.saveModel("LinearSVC.model"); //save the models
}

void draw() {
  background(255);
  if (leap.hasImages()) {
    for (Image camera : leap.getImages()) {
      if (camera.isLeft()) { // Left camera
        pushMatrix();
        translate(0, -height/4);
        scale(-1, 1);
        translate(-width/2, height/2);
        image(camera, 0, 0);
        popMatrix();
      }
    }
  }

  for (Hand hand : leap.getHands ()) {
    for (Finger finger : hand.getFingers()) {
      finger.draw();  // Executes drawBones() and drawJoints()
    }
  }

  if (!checkFingers()) appendArrayTail(modeArray, -1); //the class is null without mouse pressed.//appendArrayTail(modeArray, labelIndex); //the class is null without mouse pressed.

  barGraph(modeArray, 0, height, 0, height-50, width, 50);
  checkDevice();
  text("FPS: "+leap.getFrameRate(), 20, 20);
  if (b_saveCSV) {
    saveCSV(dataSetName, csvData);
    saveARFF(dataSetName, csvData);
    b_saveCSV = false;
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
