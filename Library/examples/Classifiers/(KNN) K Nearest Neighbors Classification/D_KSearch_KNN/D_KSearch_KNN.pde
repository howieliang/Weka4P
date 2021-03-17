//*********************************************
//  D_CSearch_KNN_Mouse : Tool for testing different K values
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
//  You can generate your own dataset by using the CollectData_Mouse example  
//
//  The program will display a grid of model visualizations with their respective C value
//  Press ENTER to switch between displaying the text on top of the visualizations
//
//*********************************************

import Weka4P.*;                                       // Import the Weka4Processing library
Weka4P wp;                                             // Global Weka4P variable

int[] KArray = {1, 3, 5, 7, 9, 11, 13, 15, 17};     // Array of K values to search
boolean showModelOnly = false;                         // Boolean to control the text output

void setup() {
  size(500, 500);
  wp = new Weka4P(this);                               // Initialize Weka4P object

  wp.loadTrainARFF("mouseTrain.arff");                 // Load a ARFF dataset
  wp.KSearch(KArray);                                  // Train a model with every K in KArray
}

void draw() {
  wp.drawKSearchModels(0, 0, width, height);           // Draw the model visualization (for 2D features)

  if (!showModelOnly)
    wp.drawKSearchResults(0, 0, width, height);        // Draw the statistics
}

/* Switches showModelOnly Boolean on ENTER */
void keyPressed() {
  if (key == ENTER || key == RETURN) {
    showModelOnly = (showModelOnly ? false : true);     // Short hand if statement with Ternary operator
  }
}
