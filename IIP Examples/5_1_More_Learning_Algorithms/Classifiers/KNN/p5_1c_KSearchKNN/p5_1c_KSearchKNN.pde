//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import Weka4P.*;
Weka4P wp;

int[] KArray = {1, 3, 5, 7, 9, 11, 13, 15, 17};
boolean showModelOnly = false;

void setup() {
  size(500, 500);             //set a canvas
  wp = new Weka4P(this);
  
  wp.loadTrainARFF("mouseTrain.arff"); //load a ARFF dataset
  //wp.CSearchLSVC(CArray); //train a model with every C in CArray
  wp.KSearch(KArray);
}

void draw() {
  wp.drawKSearchModels(0, 0, width, height); //draw the model visualization (for 2D features)
  if (!showModelOnly) wp.drawKSearchResults(0, 0, width, height); //draw the statistics
}

void keyPressed() {
  if (key == ENTER || key == ENTER) {
    showModelOnly = (showModelOnly? false : true);
  }
}
