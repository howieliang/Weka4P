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

int div = 2;

void setup() { 
  size(940, 480);
  video = new Capture(this, 640/div, 480/div);
  opencv = new OpenCV(this, 640/div, 480/div);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
  imageMode(CENTER);

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
    println(i, faces[i].x, faces[i].y, faces[i].width, faces[i].height);
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
        fill(c);
        rect(x*10,y*10,10,10);
      }
    }
    popStyle();
    popMatrix();
  }
}

void captureEvent(Capture c) {
  c.read();
}
