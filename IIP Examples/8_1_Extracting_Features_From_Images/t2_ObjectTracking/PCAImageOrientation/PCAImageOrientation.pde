import Jama.Matrix;
import java.awt.*;

import gab.opencv.*;
import processing.video.*;

PCA pca;

PVector axis1;
PVector axis2;
PVector mean;

OpenCV opencv;
Capture video;

PImage[] img = new PImage[4];  
PImage res;

int imgWidth = 640/4;
int imgHeight = 480/4;

ArrayList<Contour> contours;

int currX = 0;
int currY = 0;

void setup() {
  size(640, 480);
  opencv = new OpenCV(this, imgWidth, imgHeight);
  for (int i = 0; i < img.length; i++) {
    img[i] = loadImage("data/pen_orientation-"+i+".png"); 
    img[i].resize(imgWidth, imgHeight);
  }
  frameRate(1);
  //noLoop();
}

void draw() {
  currX = 0;
  currY = 0;
  background(52);
  opencv.loadImage(img[frameCount%4]);
  opencv.gray();
  imageInGrid(opencv.getSnapshot(), "GRAY");

  opencv.brightness(60);
  imageInGrid(opencv.getSnapshot(), "BRIGHTNESS: 30");

  opencv.threshold(128);
  imageInGrid(opencv.getSnapshot(), "THRESHOLD: 128");
  res = opencv.getOutput();

  Matrix m = toMatrix(opencv.getSnapshot());

  float angle = 0;
  if (m.getRowDimension() > 0) {
    pca = new PCA(m);
    Matrix eigenVectors = pca.getEigenvectorsMatrix();

    eigenVectors.print(10, 2);

    axis1 = new PVector();
    axis2 = new PVector();
    axis1.x = (float)eigenVectors.get(0, 0);
    axis1.y = (float)eigenVectors.get(1, 0);

    axis2.x = (float)eigenVectors.get(0, 1);
    axis2.y = (float)eigenVectors.get(1, 1);  

    axis1.mult((float)pca.getEigenvalue(0));
    axis2.mult((float)pca.getEigenvalue(1));

    angle = atan2(axis2.x, axis2.y);

    image(opencv.getSnapshot(), 0, opencv.getSnapshot().height, opencv.getSnapshot().width*3, opencv.getSnapshot().height*3);
    contours = opencv.findContours();
    noFill();
    stroke(0, 0, 200);
    pushMatrix();
    translate(0, imgHeight);
    scale(3);

    PVector centroid = new PVector(0, 0);
    Contour contour = contours.get(0);
    contour.draw();
    Rectangle bbox = contour.getBoundingBox();
    centroid = new PVector(bbox.x+bbox.width/2, bbox.y+bbox.height/2);
    translate(centroid.x, centroid.y);

    stroke(0, 255, 0);
    line(0, 0, axis1.x, axis1.y);
    stroke(255, 0, 0);
    line(0, 0, axis2.x, axis2.y);
    popMatrix();

    fill(255, 0, 0);
    text("PCA Object Axes:\nFirst two principle components centered at blob centroid", 10, height - 20);
  }

  pushMatrix();
  translate(3*imgWidth, 0);
  translate(res.width/2, res.height/2);
  rotate(angle);
  translate(-res.width/2, -res.height/2);
  opencv.threshold(128);
  image(res, 0, 0, res.width, res.height);
  fill(255, 0, 0);
  popMatrix();

  pushMatrix();
  translate(3*imgWidth, 0);
  text("After PCA", 10, res.height-6);
  popMatrix();
}

Matrix toMatrix(PImage img) {
  ArrayList<PVector> points = new ArrayList<PVector>();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      int i = y*img.width + x;
      if (brightness(img.pixels[i]) == 0) {
        points.add(new PVector(x, y));
      }
    }
  }

  println("nBlackPixels: " + points.size() + "/" + img.width*img.height);
  Matrix result = new Matrix(points.size(), 2);

  for (int i = 0; i < points.size(); i++) {
    result.set(i, 0, points.get(i).x);
    result.set(i, 1, points.get(i).y);
  }

  return result;
}

void imageInGrid(PImage img, String message) {
  image(img, currX, currY);
  fill(255, 0, 0);
  text(message, currX + 5, currY + imgHeight - 5);

  currX += img.width;
  if (currX > width - img.width) {
    currX = 0;
    currY += img.height;
  }
}