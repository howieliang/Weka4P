//*********************************************
//  B_TrainsModel_LSVC_Mouse : Trains a Linear Support Vector Classifier from mouse data
//
//  Author:     Rong-Hao Liang <r.liang@tue.nl>
//  Edited by:  Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (17 03 2021)
//
//  Manual:
//  Drag the .arff file into this sketch window or
//  copy the .arff file to the data folder of this sketch.
//  Sketch -> Show Sketch Folder (ctrl/cmd + K)
//
//  You can generate your own data by using the CollectData_Mouse example  
//
//  The program will train a LSVC with the data provided
//  and visualizes the model.
//
//*********************************************

import Weka4P.*;                                       // Import the Weka4Processing library
Weka4P wp;                                             // Global Weka4P variable

void setup() {
  size(500, 500);
  wp = new Weka4P(this);                               // Initialize Weka4P object
  
  wp.loadTrainARFF("mouseTrain.arff");                 // Load a ARFF dataset
  wp.trainLinearSVC(1);                                // Train a LSVC with C = 1
  wp.setModelDrawing(2);                               // Set the model visualization (for 2D features)
  wp.evaluateTrainSet(5, false, true);                 // 5-fold cross validation (fold=5, isRegression=false, showEvalDetails=true)
  wp.saveModel("LinearSVC.model");                     // Save the model to the data folder
}

void draw() {
  wp.drawModel(0, 0);                                  // Draw the model visualization (for 2D features)
  wp.drawDataPoints(wp.train);                         // Draw the datapoints
  
  float[] X = {mouseX, mouseY};                        // Store the mouse coordinates in a array
  String Y = wp.getPrediction(X);                      // Predict the value
  wp.drawPrediction(X, Y);                             // Draw the prediction
}
