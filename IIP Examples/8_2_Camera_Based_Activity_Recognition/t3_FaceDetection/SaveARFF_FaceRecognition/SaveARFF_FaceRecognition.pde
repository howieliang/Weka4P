//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

PImage photo;
int grid_r = 640;
int grid_h = 480;

Histogram grayHist; 
Histogram rHist, gHist, bHist;
Histogram hHist, sHist, vHist;
PImage img, imgGray, imgR, imgG, imgB, imgH, imgS, imgV;

int div = 2, binDiv = 5;
int w = 330, h = 250, dt = 10;

int imgW = 10;
int sensorNum = imgW*imgW; //number of sensors in use
int dataNum = 100; //number of data to show
float[] rawData = new float[sensorNum];
float[][] sensorHist = new float[sensorNum][dataNum]; //history data to show
float[] modeArray = new float[dataNum]; //classification to show

//Save
Table csvData;
boolean b_saveCSV = false;
String dataSetName = "FaceTrain"; 
String[] attrNames;
boolean[] attrIsNominal;
int labelIndex = 0;

boolean b_sampling = false; //flag to keep data collection non-preemptive
int sampleCnt = 0; //counter of samples

//SVM parameters
double C = 64; //Cost: The regularization parameter of SVM
int lastPredY = -1;

void setDataType() {
  attrNames =  new String[sensorNum+1];
  attrIsNominal = new boolean[sensorNum+1];
  for (int j = 0; j < sensorNum; j++) {
    attrNames[j] = "p_"+j;
    attrIsNominal[j] = false;
  }
  attrNames[sensorNum] = "label";
  attrIsNominal[sensorNum] = true;
}

void setup() { 
  size(940, 480);
  video = new Capture(this, 640/div, 480/div);
  opencv = new OpenCV(this, 640/div, 480/div);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
  imageMode(CENTER);
  setDataType();
  initCSV();

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
}

void draw() {
  background(52);
  opencv.loadImage(video);
  opencv.useColor();
  photo = opencv.getSnapshot();
  pushMatrix();
  scale(-div, div);
  translate(-640/(2*div), 480/(2*div));
  image(photo, 0, 0);
  popMatrix();
  
  Rectangle[] faces = opencv.detect();

  PImage[] faceImgs = new PImage[faces.length]; 
  PImage[] faceImgsGray = new PImage[faces.length]; 
  
  for (int i = 0; i < faces.length; i++) {
    faceImgs[i] = new PImage();
    faceImgsGray[i] = new PImage();
    pushMatrix();
    scale(-div, div);
    translate(-(640/div)+(faces[i].x), faces[i].y);
    //println(i, faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    rect(0, 0, faces[i].width, faces[i].height);
    faceImgs[i] = photo.get(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    faceImgs[i].resize(100, 100);
    faceImgsGray[i] = photo.get(faces[i].x, faces[i].y, faces[i].width, faces[i].height); 
    faceImgsGray[i].filter(GRAY);
    faceImgsGray[i].resize(10, 10);
    popMatrix();
  }

  for (int i = 0; i < faces.length; i++) {
    image(faceImgs[i], 640 + 50, i*100+50);
    pushMatrix();
    translate(740 + 50, i*100+50);
    scale(10);
    image(faceImgsGray[i], 0, 0);
    popMatrix();

    pushMatrix();
    pushStyle();
    translate(840, i*100);
    noStroke();
    for (int x = 0; x < faceImgsGray[i].width; x++) {
      for (int y = 0; y < faceImgsGray[i].width; y++) {
        color c = faceImgsGray[i].get(x,y);
        rawData[x+y*imgW] = faceImgsGray[0].get(x, y) & 0xFF;
        fill(c);
        rect(x*10,y*10,10,10);
      }
    }
    popStyle();
    popMatrix();
  }
  
  if (mousePressed && (frameCount%6==0)) b_sampling = true;
  else b_sampling = false;
  
  if (b_sampling == true && faces.length>0) {
    float[] X = new float[sensorNum]; //Form a feature vector X;
    appendArrayTail(modeArray, labelIndex); //the class is null without mouse pressed.
    TableRow newRow = csvData.addRow();
    for (int i = 0; i < sensorNum; i++) {
      X[i] = rawData[i];
      newRow.setFloat("p_"+i, X[i]);
    }
    newRow.setString("label", getCharFromInteger(labelIndex));
    println(csvData.getRowCount());
    b_sampling = false;
  } else {
    appendArrayTail(modeArray, -1); //the class is null without mouse pressed.
  }
  
  showInfo("Current Label: "+getCharFromInteger(labelIndex), 640+20, 220, 16);
  showInfo("Num of Data: "+csvData.getRowCount(), 640+20, 240, 16);
  showInfo("[X]:del/[C]:clear", 640+20, 260, 16);
  showInfo("[S]:save/[/]:label+", 640+20, 280, 16);
  if (b_saveCSV) {
    saveCSV(dataSetName, csvData);
    saveARFF(dataSetName, csvData);
    b_saveCSV = false;
  }
}

void captureEvent(Capture c) {
  c.read();
}

float[] appendArrayTail (float[] _array, float _val) {
  float[] array = _array;
  float[] tempArray = new float[_array.length-1];
  arrayCopy(array, 1, tempArray, 0, tempArray.length);
  array[tempArray.length] = _val;
  arrayCopy(tempArray, 0, array, 0, tempArray.length);
  return array;
}
