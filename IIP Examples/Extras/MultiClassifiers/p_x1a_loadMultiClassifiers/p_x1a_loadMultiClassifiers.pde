//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import weka.core.Attribute; //https://weka.sourceforge.io/doc.dev/weka/core/Attribute.html
import weka.core.Instances; //https://weka.sourceforge.io/doc.dev/weka/core/Instances.html
import weka.classifiers.Classifier; //https://weka.sourceforge.io/doc.stable-3-8/weka/classifiers/Classifier.html

import Weka4P.*;
Weka4P wp;

ArrayList<Attribute>[] attributes = new ArrayList[1];
Instances[] instances = new Instances[1];
Classifier[] classifiers = new Classifier[3];

void setup() {
  size(500, 500);             //set a canvas
  wp = new Weka4P(this);
  
  instances[0] = wp.loadTrainARFFToInstances("mouseTrain.arff");
  attributes[0] = wp.loadAttributesFromInstances(instances[0]);
  classifiers[0] = wp.loadModelToClassifier("RBFSVC.model"); //load a pretrained model.
  classifiers[1] = wp.loadModelToClassifier("LinearSVC.model"); //load a pretrained model.
  classifiers[2] = wp.loadModelToClassifier("KNN.model"); //load a pretrained model.
}

void draw() {
  background(255);
  float[] X = {mouseX, mouseY};
  String[] Y = new String[classifiers.length];
  for(int i = 0 ; i < classifiers.length ; i++){
    Y[i] = wp.getPrediction(X, classifiers[i], attributes[0],instances[0]);
    wp.drawPrediction(X, Y[i], wp.colors[i]); //draw the prediction
  }
}
