//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import Weka4P.*;
Weka4P wp;

void setup() {
  size(500, 500);                        //set a canvas
  wp = new Weka4P(this);                 //instantiate Weka4P
  
  wp.loadTrainARFF("testData.arff");     //load a ARFF dataset
  println(wp.train);
  wp.trainLinearSVC(64);                 //train a KNN classifier with C parameter
  wp.setModelDrawing(2);                 //set the model visualization (for 2D features) with unit parameter
  wp.evaluateTrainSet(5, false, true);   //5-fold cross validation
  wp.saveModel("LinearSVC.model");       //save the model
}

void draw() {
  wp.drawModel(0, 0);                    //draw the model visualization (for 2D features)
  wp.drawDataPoints();                   //draw the datapoints
  float[] X = {mouseX, mouseY}; 
  String Y = wp.getPrediction(X);
  wp.drawPrediction(X, Y);               //draw the prediction
}
