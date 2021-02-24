//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************
import papaya.*;

import Weka4P.*;
Weka4P wp;

void setup() {
  size(500, 500);             //set a canvas
  wp = new Weka4P(this);
  wp.loadTrainARFF("A012GestTrain.arff"); //load a ARFF dataset
  wp.trainMLP("9", 100); // (hiddenLayers = "9", trainingTime = 100)
  //wp.setModelDrawing(unit=2);         //set the model visualization (for 2D features)
  wp.evaluateTrainSet(5, false, true);  //5-fold cross validationevaluateTrainSet(fold=5, isRegression=false, showEvalDetails=true);  //5-fold cross validation
  wp.saveModel("MLP.model"); //save the model
}

void draw() {
  //wp.drawModel(0, 0); //draw the model visualization (for 2D features)
  //wp.drawDataPoints(train); //draw the datapoints
  //float[] X = {mouseX, mouseY}; 
  //String Y = wp.getPrediction(X);
  ////double Y = wp.getPredictionIndex(X);
  //wp.drawPrediction(X, Y); //draw the prediction
}
