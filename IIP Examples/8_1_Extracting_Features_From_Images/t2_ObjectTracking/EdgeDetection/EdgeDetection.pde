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
ArrayList<Line> lines;

int div = 2;
PImage img, dst, diff;
PImage imgSobel, imgCannyEdges;
boolean b_save = false;

void setup() {
  size(960, 480,P2D);
  video = new Capture(this, 640/div, 480/div);
  opencv = new OpenCV(this, 640/div, 480/div);
  dst = new PImage(640/div, 480/div);
  diff = new PImage(640/div, 480/div);
  video.start();
  frameRate(30);
}

void draw() {
  background(255);
  opencv.useGray();
  opencv.loadImage(video);
  img = opencv.getSnapshot();
  if (b_save) {
    dst = opencv.getSnapshot();
    b_save = false;
  }
  opencv.loadImage(img);
  opencv.diff(dst);
  diff = opencv.getSnapshot();
  image(img, 0, 0, 320, 240);
  image(diff, 320, 0);

  opencv.loadImage(diff);
  opencv.findSobelEdges(1, 0);
  imgSobel = opencv.getSnapshot();
  image(imgSobel, 0, 240, 320, 240);
  image(imgSobel, 640, 0, 320, 240);

  opencv.loadImage(diff);
  opencv.findCannyEdges(20, 75);
  imgCannyEdges = opencv.getSnapshot();
  image(imgCannyEdges, 320, 240, 320, 240);
  
  lines = opencv.findLines(100, 30, 20); // Arguments are: threshold, minLengthLength, maxLineGap
  pushMatrix(); 
  translate(640, 0);
  for (Line line : lines) {
    stroke(0, 0, 255);
    line(line.start.x, line.start.y, line.end.x, line.end.y);
  }
  popMatrix();
  pushMatrix(); 
  translate(640, 240);
  for (Line line : lines) {
    stroke(0, 0, 255);
    line(line.start.x, line.start.y, line.end.x, line.end.y);
  }
  popMatrix();
  
  pushMatrix();
  translate(10,10);
  text("Source", 0, 0);
  text("Foreground", 320, 0);
  text("Sobel+Lines", 640, 0);
  text("CannyEdge", 320, 240);
  text("Sobel", 0, 240);
  text("Lines", 640, 240);
  popMatrix();
}

void captureEvent(Capture c) {
  c.read();
}

void mousePressed() {
  if (b_save == true) b_save = false;
  else b_save = true;
}
