//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import Weka4P.*;
Weka4P wp;

double[] CArray = {1, 8, 64};
double[] gammaArray = {1, 8, 64};
boolean showModelOnly = false;

void setup() {
  size(500, 500);             //set a canvas
  wp = new Weka4P(this);
  
  wp.loadTrainARFF("mouseTrain.arff"); //load a ARFF dataset
  wp.gridSearchSVC_RBF(CArray, gammaArray);
}

void draw() {
  wp.drawGridSearchModels(0, 0, width, height); //draw the model visualization (for 2D features)
  if (!showModelOnly) wp.drawGridSearchResults(0, 0, width, height); //draw the statistics
}

void keyPressed() {
  if (key == ENTER || key == ENTER) {
    showModelOnly = (showModelOnly? false : true);
  }
}
