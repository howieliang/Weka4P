//*********************************************
//  B_TrainModel_LReg_Accelerometer_3_Axes : Trains a Linear Regressor from Accelorometer Data
//
//  Author:     Rong-Hao Liang <r.liang@tue.nl>
//  Edited by:  Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (22 06 2021)
//
//  Manual:
//  Drag the .arff file into this sketch window or
//  copy the .arff file to the data folder of this sketch.
//  Sketch -> Show Sketch Folder (ctrl/cmd + K)
//
//  You can generate your own data by using the A CollectData Accelometer 3 Axes example  
//
//  The program will train a LReg with the data provided
//  and visualizes the model.
//
//*********************************************

import Weka4P.*;
Weka4P wp;

void setup() {
  size(500, 500);                                      // Set a canvas
  wp = new Weka4P(this);
  
  wp.loadTrainARFF("accData.arff");                    // Load a ARFF dataset
  wp.trainLinearRegression();                          //train a linear regressor
  wp.setModelDrawing(2);                               // Set the model visualization (for 2D features)
  wp.evaluateTrainSet(5, true, true);                  // 5-fold cross validation (fold=5, isRegression=false, showEvalDetails=true)
  wp.saveModel("LinearReg.model");                     // Save the model
}

void draw() {
  background(255);
  wp.drawModel(0, 0);                                  // Draw the model visualization (for 2D features)
  wp.drawDataPoints(wp.train);                         // Draw the datapoints
  
  float[] X = {mouseX, mouseY}; 
  double Y = wp.getPredictionIndex(X);
  
  wp.drawPrediction(X, Y);                             // Draw the prediction
}
