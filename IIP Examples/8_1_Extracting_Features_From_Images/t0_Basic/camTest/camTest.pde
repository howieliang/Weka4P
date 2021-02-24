//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

int div = 1;
PImage src;

void setup() {
  size(640, 480);
  video = new Capture(this, 640/div, 480/div);
  opencv = new OpenCV(this, 640/div, 480/div);
  opencv.useColor();
  video.start();
}

void draw() {
  opencv.loadImage(video);
  src = opencv.getSnapshot();
  image(src, 0, 0);
}

void captureEvent(Capture c) {
  c.read();
}
