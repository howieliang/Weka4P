//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import gab.opencv.*;
import processing.video.*;

Capture video;
OpenCV opencv;

int div = 2;
PImage src, dst, diff;
boolean b_save = false;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/div, 480/div);
  opencv = new OpenCV(this, 640/div, 480/div);
  dst = new PImage(640/div, 480/div);
  diff = new PImage(640/div, 480/div);
  video.start();
}

void draw() {
  background(0);
  opencv.loadImage(video);
  src = opencv.getSnapshot();
  if (b_save) {
    dst = opencv.getSnapshot();
    b_save = false;
  }
  opencv.loadImage(src);
  opencv.diff(dst);
  diff = opencv.getSnapshot();
  image(src, 0, 0); 
  image(diff, 320, 0);
}

void captureEvent(Capture c) {
  c.read();
}

void mousePressed() {
  if (b_save == true) b_save = false;
  else b_save = true;
}
