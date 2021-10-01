//*********************************************
//  D_GridSearch_KSVR : Tool for testing different Epsilon and gamma values
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
//  You can generate your own dataset by using the CollectDataNum_Mouse example  
//
//  The program will display a grid of model visualizations with their respective Epsilon and gamma value
//  Press ENTER to switch between displaying the text on top of the visualizations
//
//*********************************************

import Weka4P.*;                                       // Import the Weka4Processing library
Weka4P wp;                                             // Global Weka4P variable

double[] EpsArray = {0.1, 0.1/4., 0.1/16.};            // Array of Epsilon values to search
double[] gammaArray = {1, 8, 64};                      // Array of gamma values to search
boolean showModelOnly = false;                         // Boolean to control the text output

void setup() {
  size(500, 500);
  wp = new Weka4P(this);                               // Initialize Weka4P object

  wp.loadTrainARFF("mouseTrainNum.arff");              // Load a ARFF dataset
  wp.gridSearchSVR_RBF(EpsArray, gammaArray);          // Train a model with every Epsilon in EpsArray
}

void draw() {
  wp.drawGridSearchModels_SVR(0, 0, width, height);         // Draw the model visualization (for 2D features)

  if (!showModelOnly)
    wp.drawGridSearchResults_SVR(0, 0, width, height);      // Draw the statistics
}

/* Switches showModelOnly Boolean on ENTER */
void keyPressed() {
  if (key == ENTER || key == RETURN) {
    showModelOnly = (showModelOnly ? false : true);     // Short hand if statement with Ternary operator
  }
}
