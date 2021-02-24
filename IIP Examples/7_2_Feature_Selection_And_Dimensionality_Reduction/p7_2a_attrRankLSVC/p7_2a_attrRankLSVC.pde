//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import Weka4P.*;
Weka4P wp;

void setup() {
  size(500, 500);             //set a canvas
  wp = new Weka4P(this);
  wp.loadTrainARFF("iris.arff"); //load a ARFF dataset
  wp.rankAttrLSVC(1);        // C = 1
}
