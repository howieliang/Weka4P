//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import Weka4P.*;
Weka4P wp;

void setup() {
  size(500, 500);             //set a canvas
  wp = new Weka4P(this);
  wp.loadTrainARFF("mouseTrain.arff");//load a ARFF dataset
  wp.loadTestARFF("mouseTest.arff");//load a ARFF dataset
  wp.loadModel("LinearSVC.model"); //load a pretrained model.
  wp.setModelDrawing(2);          //set the model visualization (for 2D features) with unit = 2
  wp.evaluateTestSet(false, true);  //5-fold cross validation
  
}
void draw() {
  wp.drawModel(0, 0); //draw the model visualization (for 2D features)
  wp.drawDataPoints(wp.test); //draw the datapoints
  float[] X = {mouseX, mouseY}; 
  String Y = wp.getPrediction(X);
  wp.drawPrediction(X, Y); //draw the prediction
}
