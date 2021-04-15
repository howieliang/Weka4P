//*********************************************
//  C_LoadModel_LSVR_Mouse : Load a Linear Support Vector Regressor model
//
//  Author:     Rong-Hao Liang <r.liang@tue.nl>
//  Edited by:  Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (17 03 2021)
//
//  Manual:
//  Drag the .model and .arff file into this sketch window or
//  copy the .model and .arff file to the data folder of this sketch.
//  Sketch -> Show Sketch Folder (ctrl/cmd + K)
//
//  You can generate your own model by using the TrainModel_LSVR_Mouse example  
//
//  The program will read a LSVR trained model and the .arff
//  and visualizes the model and shows you the prediction.
//
//*********************************************

import Weka4P.*;                                       // Import the Weka4Processing library
Weka4P wp;                                             // Global Weka4P variable

void setup() {
  size(500, 500);
  wp = new Weka4P(this);                               // Initialize Weka4P object
  
  wp.loadTrainARFF("mouseTrainNum.arff");              // Load a ARFF dataset
  wp.loadModel("LSVR.model");                          // Load a pretrained model.
  wp.setModelDrawing(2);                               // Set the model visualization (for 2D features) with unit = 2
}

void draw() {
  wp.drawModel(0, 0);                                  // Draw the model visualization (for 2D features)
  wp.drawDataPoints(wp.train);                         // Draw the datapoints
  
  float[] X = {mouseX, mouseY};                        // Store the mouse coordinates in a array
  double Y = wp.getPredictionIndex(X);                 // Predict the index
  wp.drawPrediction(X, Y);                             // Draw the prediction
}
