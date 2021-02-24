//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import weka.core.Attribute; //https://weka.sourceforge.io/doc.dev/weka/core/Attribute.html
import weka.classifiers.Classifier; //https://weka.sourceforge.io/doc.stable-3-8/weka/classifiers/Classifier.html
import weka.core.Instances; //https://weka.sourceforge.io/doc.dev/weka/core/Instances.html

import Weka4P.*;
Weka4P wp;

ArrayList<Attribute>[] attributes = new ArrayList[2];
Instances[] instances = new Instances[2];
Classifier[] classifiers = new Classifier[2];

void setup() {
  size(500, 500);             //set a canvas
  wp = new Weka4P(this);
  instances[0] = wp.loadTrainARFFToInstances("mouseTrainNum.arff");
  instances[1] = wp.loadTrainARFFToInstances("mouseTrain.arff");
  attributes[0] = wp.loadAttributesFromInstances(instances[0]);
  attributes[1] = wp.loadAttributesFromInstances(instances[1]);
  classifiers[0] = wp.loadModelToClassifier("LSVR.model");
  classifiers[1] = wp.loadModelToClassifier("LinearSVC.model");
}
void draw() {
  background(255);
  float[] X = {mouseX, mouseY};
  double Y0 = wp.getPredictionIndex(X, classifiers[0], attributes[0]);
  String Y1 = wp.getPrediction(X, classifiers[1], attributes[1],instances[1]);
  wp.drawPrediction(X, Y0, wp.colors[0]);
  wp.drawPrediction(X, Y1, wp.colors[1]);
}
