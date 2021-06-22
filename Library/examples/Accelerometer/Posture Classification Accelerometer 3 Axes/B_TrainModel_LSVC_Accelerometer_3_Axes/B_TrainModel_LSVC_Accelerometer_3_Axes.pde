//*********************************************
//  B_TrainModel_LSVC_Accelerometer_3_Axes : Trains a Linear Support Vector Classifier from Accelorometer Data
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
//  The program will train a LSVC with the data provided
//  and visualizes the model.
//
//*********************************************

import Weka4P.*;
Weka4P wp;

void setup() {
  size(500, 500);                                      // Set a canvas
  wp = new Weka4P(this);
  
  wp.loadTrainARFF("accData.arff");                    // Load a ARFF dataset
  wp.trainLinearSVC(1);                                // Train a SV classifier with C=1
  wp.setModelDrawing(2);                               // Set the model visualization (for 2D features)
  wp.evaluateTrainSet(5, false, true);                 // 5-fold cross validation (fold=5, isRegression=false, showEvalDetails=true)
  wp.saveModel("LinearSVC.model");                     // Save the model
}

void draw() {
  background(255);
  wp.drawModel(0, 0);                                  // Draw the model visualization (for 2D features)
  wp.drawDataPoints(wp.train);                         // Draw the datapoints
  
  float[] X = {mouseX, mouseY}; 
  String Y = wp.getPrediction(X);
  
  wp.drawPrediction(X, Y);                             // Draw the prediction
}
