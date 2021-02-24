//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************
import Weka4P.*;
Weka4P wp;

double[] CArray = {1, 2, 4, 8, 16, 32, 64, 128, 256};
boolean showModelOnly = false;

void setup() {
  size(500, 500, P2D);
  wp = new Weka4P(this);
  wp.loadTrainARFF("A0GestTrain.arff");//load a ARFF dataset
  wp.CSearchLSVC(CArray);
}

void draw() {
  wp.drawCSearchModels(0, 0, width, height);
  if (!showModelOnly) wp.drawCSearchResults(0, 0, width, height);
}

void keyPressed() {
  if (key == ENTER || key == ENTER) {
    showModelOnly = (showModelOnly? false : true);
  }
}
