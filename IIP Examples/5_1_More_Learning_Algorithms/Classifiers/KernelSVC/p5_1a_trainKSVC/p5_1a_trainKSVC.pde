//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import Weka4P.*;
Weka4P wp;

void setup() {
  size(500, 500);             //set a canvas
  wp = new Weka4P(this);
  wp.loadTrainARFF("mouseTrain.arff"); //load a ARFF dataset
  wp.trainRBFSVC(64, 64);             //train a SV classifier (gamma=64, C=64)
  wp.setModelDrawing(2);         //set the model visualization (for 2D features) with unit = 2
  wp.evaluateTrainSet(5, false, true);  //5-fold cross validation (fold=5, isRegression=false, showEvalDetails=true)
  wp.saveModel("RBFSVC.model"); //save the model
}

void draw() {
  wp.drawModel(0, 0); //draw the model visualization (for 2D features)
  wp.drawDataPoints(wp.train); //draw the datapoints
  float[] X = {mouseX, mouseY}; 
  String Y = wp.getPrediction(X);
  wp.drawPrediction(X, Y); //draw the prediction
}
