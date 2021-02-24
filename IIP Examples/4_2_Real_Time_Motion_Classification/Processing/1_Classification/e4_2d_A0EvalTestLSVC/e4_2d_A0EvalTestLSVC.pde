//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************
import Weka4P.*;
Weka4P wp;

void setup() {
  size(500, 500, P2D);
  wp = new Weka4P(this);
  wp.loadTrainARFF("A0GestTrain.arff");//load a ARFF dataset
  wp.loadTestARFF("A0GestTest.arff");//load a ARFF dataset
  wp.loadModel("LinearSVC.model"); //load a pretrained model.
  wp.setModelDrawing(2);          //set the model visualization (for 2D features) with unit = 2
  wp.evaluateTestSet(false, true);  //5-fold cross validation (isRegression = false, showEvalDetails=true)
}

void draw() {
  wp.drawModel(0, 0); //draw the model visualization (for 2D features)
  wp.drawDataPoints(wp.test); //draw the datapoints
}
