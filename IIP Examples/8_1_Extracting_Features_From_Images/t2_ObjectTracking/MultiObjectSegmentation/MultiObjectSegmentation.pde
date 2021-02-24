//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

int div = 2;
PImage src, threshBlur, dst, diff;
int blurSize = 12;
int grayThreshold = 80;
boolean b_save = false;

ArrayList<Contour> contours;

void setup() {
  size(960, 480,P2D);
  video = new Capture(this, 640/div, 480/div);
  opencv = new OpenCV(this, 640/div, 480/div);
  dst = new PImage(640/div, 480/div);
  diff = new PImage(640/div, 480/div);
  video.start();
  fill(255);
  textSize(18);
  textAlign(LEFT, TOP);
  frameRate(30);
}

void draw() {
  background(0);
  blurSize = (int)map(mouseX, 0, width, 1, 24);
  grayThreshold = (int)map(mouseY, 0, height, 0, 255);

  opencv.loadImage(video);
  src = opencv.getSnapshot();
  
  
  if(b_save){
    dst = opencv.getSnapshot();
    b_save = false;
  }
  
  opencv.loadImage(src);
  opencv.diff(dst);
  diff = opencv.getSnapshot();
  
  opencv.loadImage(diff);
  opencv.blur(blurSize);
  opencv.threshold(grayThreshold);
  threshBlur = opencv.getSnapshot();
  
  image(src, 0, 0);
  image(dst, 0, 240);
  image(diff, 320, 0);
  image(threshBlur, 320, 240);
  
  contours = opencv.findContours();
  for (Contour contour : contours) {
    stroke(0, 255, 0);
    fill(255);
    pushMatrix();
    translate(640, 0);
    contour.draw();
    popMatrix();

    pushMatrix();
    translate(640, 240);
    
    beginShape();
    contour.setPolygonApproximationFactor(2); 
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
      stroke(255, 0, 0);
      fill(255);
      vertex(point.x, point.y);
    }
    endShape();
    Rectangle r = contour.getBoundingBox();
    stroke(255, 0, 0);
    fill(255);
    rect(r.x, r.y, r.width, r.height);
    noStroke();
    fill(255, 0, 0);
    ellipse(r.x+r.width/2, r.y+r.height/2, 10, 10);

    popMatrix();
  }
  
  pushMatrix();
  translate(10,10);
  text("Source", 0, 0);
  text("Background", 0, 240);
  text("Diff", 320, 0);
  text("Threshold (Mouse Y):"+grayThreshold+"\n+ Blur (MouseX):"+blurSize, 320, 240);
  text("Contours", 640, 0);
  text("Features", 640, 240);
  popMatrix();
}

void captureEvent(Capture c) {
  c.read();
}

void mousePressed() {
  if (b_save == true) b_save = false;
  else b_save = true;
}
