//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import Weka4P.*;
Weka4P wp;

void setup() {
  size(500, 500);             //set a canvas
  wp = new Weka4P(this);
  
  wp.loadTrainARFF("mouseTrainNum.arff"); //load a ARFF dataset
  wp.trainRBFSVR(0.001, 1);             //train a SV classifier (epsilon=0.001, gamma=1)
  wp.setModelDrawing(2);         //set the model visualization (for 2D features) with unit = 2
  wp.evaluateTrainSet(5, true, true);  //5-fold cross validation (fold=5, isRegression=true, showEvalDetails=true)
  wp.saveModel("KSVR.model"); //save the model
}

void draw() {
  wp.drawModel(0, 0); //draw the model visualization (for 2D features)
  wp.drawDataPoints(wp.train); //draw the datapoints
  float[] X = {mouseX, mouseY}; 
  double Y = wp.getPredictionIndex(X);
  wp.drawPrediction(X, Y); //draw the prediction
}
