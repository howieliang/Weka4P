//*********************************************
//  B_TrainModel_LReg_Mouse : Trains a Linear Neigbors Regression from mouse data
//
//  Author:     Rong-Hao Liang <r.liang@tue.nl>
//  Edited by:  Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (18 03 2021)
//
//  Manual:
//  Drag the .arff file into this sketch window or
//  copy the .arff file to the data folder of this sketch.
//  Sketch -> Show Sketch Folder (ctrl/cmd + K)
//
//  You can generate your own data by using the CollectData_Mouse example  
//
//  The program will train a LReg with the data provided
//  and visualizes the model.
//
//*********************************************

import Weka4P.*;                                       // Import the Weka4Processing library
Weka4P wp;                                             // Global Weka4P variable

void setup() {
  size(500, 500);
  wp = new Weka4P(this);                               // Initialize Weka4P object
  
  wp.loadTrainARFF("mouseTrainNum.arff");              //load a ARFF dataset
  wp.loadModel("LinearReg.model");                     //load a pretrained model.
  wp.setModelDrawing(2);                               //set the model visualization (for 2D features) with unit = 2
}

void draw() {
  wp.drawModel(0, 0);                                  // Draw the model visualization (for 2D features)
  wp.drawDataPoints(wp.train);                         // Draw the datapoints
  
  float[] X = {mouseX, mouseY};                        // Store the mouse coordinates in a array
  double Y = wp.getPredictionIndex(X);                 // Predict the index
  wp.drawPrediction(X, Y);                             // Draw the prediction
}
