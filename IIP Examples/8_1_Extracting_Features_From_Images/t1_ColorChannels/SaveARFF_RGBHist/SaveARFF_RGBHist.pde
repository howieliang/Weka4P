//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

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


int sensorNum = binNum; //number of sensors in use
int dataNum = 500; //number of data to show
float[] rawData = new float[binNum*3];
float[][] sensorHist = new float[sensorNum][dataNum]; //history data to show
float[] modeArray = new float[dataNum]; //classification to show

//Save
Table csvData;
boolean b_saveCSV = false;
String dataSetName = "FusionTrain"; 
String[] attrNames;
boolean[] attrIsNominal;
int labelIndex = 0;

boolean b_sampling = false; //flag to keep data collection non-preemptive
int sampleCnt = 0; //counter of samples

int w = 160, h = 120, d = 10;
void setDataType() {
  attrNames =  new String[binNum*3+1];
  attrIsNominal = new boolean[binNum*3+1];
  for (int j = 0; j < binNum*3; j++) {
    attrNames[j] = "h_"+j;
    attrIsNominal[j] = false;
  }
  attrNames[binNum*3] = "label";
  attrIsNominal[binNum*3] = true;
}

void setup() {
  size(500,500);
  video = new Capture(this, 640/div, 480/div);
  opencv = new OpenCV(this, 640/div, 480/div);
  video.start();
  setDataType();
  initCSV();
}

void draw() {
  background(255);
  updateChannels();
  Mat matR = rHist.getMat();
  Mat matG = gHist.getMat();
  Mat matB = bHist.getMat();
  for (int i = 0; i < binNum; i++) {
    //appendArrayTail(sensorHist[i], (float)matGray.get(i, 0)[0]);
    rawData[i] = (float)matR.get(i, 0)[0];
    rawData[i] = (float)matG.get(i, 0)[0];
    rawData[i] = (float)matB.get(i, 0)[0];
  }
  if (mousePressed && (frameCount%6==0)) b_sampling = true;
  else b_sampling = false;

  if (b_sampling == true) {
    float[] X = new float[binNum]; //Form a feature vector X;
    appendArrayTail(modeArray, labelIndex); //the class is null without mouse pressed.
    TableRow newRow = csvData.addRow();
    for (int i = 0; i < binNum; i++) {
      X[i] = rawData[i];
      newRow.setFloat("h_"+i, X[i]);
    }
    newRow.setString("label", getCharFromInteger(labelIndex));
    println(csvData.getRowCount());
    b_sampling = false;
  } else {
    appendArrayTail(modeArray, -1); //the class is null without mouse pressed.
  }
  
  image(img, 0, 0, w, h);
  //drawImage(imgGray, grayHist, 1*(w+d), 0*(h+d), w, h, color(255), "Gray");
  drawImage(imgR, rHist, 0*(w+d), 1*(h+d), w, h, color(255, 0, 0), "Red");
  drawImage(imgG, gHist, 1*(w+d), 1*(h+d), w, h, color(0, 255, 0), "Green");
  drawImage(imgB, bHist, 2*(w+d), 1*(h+d), w, h, color(0, 0, 255), "Blue");
  
  barGraph(modeArray, 0, height, 0, height-50, 500., 50);
  showInfo("Current Label: "+getCharFromInteger(labelIndex), 320+20, 20, 16);
  showInfo("Num of Data: "+csvData.getRowCount(), 320+20, 40, 16);
  showInfo("[X]:del/[C]:clear", 320+20, 60, 16);
  showInfo("[S]:save/[/]:label+", 320+20, 80, 16);
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
