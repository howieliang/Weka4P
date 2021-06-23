//*********************************************
//  B_TrainModel_MLP_Mouse : Trains a Multi Layer Perceptron Classifier (Neural Network) from mouse data
//
//  Author:     Rong-Hao Liang <r.liang@tue.nl>
//  Edited by:  Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (24 03 2021)
//
//  Manual:
//  Drag the .arff file into this sketch window or
//  copy the .arff file to the data folder of this sketch.
//  Sketch -> Show Sketch Folder (ctrl/cmd + K)
//
//  You can generate your own data by using the CollectData_Mouse example  
//
//  The program will train a MLP with the data provided
//  and visualizes the model.
//
//*********************************************

import Weka4P.*;                                       // Import the Weka4Processing library
Weka4P wp;                                             // Global Weka4P variable

void setup() {
  size(500, 500);
  wp = new Weka4P(this);                               // Initialize Weka4P object
  
  wp.loadTrainARFF("mouseTrain.arff");                 // Load a ARFF dataset
  wp.trainMLP("9", 200);                               // Train MLP with hiddenLayers = "9" and trainingTime = 200
  wp.setModelDrawing(2);                               // Set the model visualization (for 2D features)
  wp.evaluateTrainSet(5, false, true);                 // 5-fold cross validation (fold=5, isRegression=false, showEvalDetails=true)
  wp.saveModel("MLP.model");                           // Save the model to the data folder
}

void draw() {
  wp.drawModel(0, 0);                                  // Draw the model visualization (for 2D features)
  wp.drawDataPoints(wp.train);                         // Draw the datapoints
  
  float[] X = {mouseX, mouseY};                        // Store the mouse coordinates in a array
  String Y = wp.getPrediction(X);                      // Predict the value
  wp.drawPrediction(X, Y);                             // Draw the prediction
}
