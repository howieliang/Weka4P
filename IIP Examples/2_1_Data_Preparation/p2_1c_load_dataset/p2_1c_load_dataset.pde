//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import Weka4P.*;                      // import Weka for Processing libary
Weka4P wp;                            // create Weka4P variable

void setup() {
  size(500, 500);                     // set a canvas
  wp = new Weka4P(this);              // instantiate Weka for Processing
  
  wp.loadTrainARFF("testData.arff");  // load a ARFF dataset
  println(wp.train);                  // print trained data
}
