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
float[] rawData = new float[sensorNum];
float[][] sensorHist = new float[sensorNum][dataNum]; //history data to show
float[] modeArray = new float[dataNum]; //classification to show
int w = 160, h = 120, d = 10;
void setup() {
  size(500,500);
  video = new Capture(this, 640/div, 480/div);
  opencv = new OpenCV(this, 640/div, 480/div);
  video.start();
}

void draw() {
  background(255);
  updateChannels();
  drawChannels();
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
