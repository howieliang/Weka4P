//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************
import papaya.*;

import Weka4P.*;
Weka4P wp;

void setup() {
  size(500, 500, P2D);             //set a canvas
  wp = new Weka4P(this);
  wp.loadTrainARFF("A012GestTrain.arff"); //load a ARFF dataset
  wp.loadTestARFF("A012GestTest.arff");//load a ARFF dataset
  //wp.loadTrainARFF("mouseTrain.arff"); //load a ARFF dataset
  //wp.loadTestARFF("mouseTest.arff");//load a ARFF dataset
  background(255);
  noStroke();
  fill(52);
  stroke(0);
  textSize(11);
  int step = 50;
  int upperLimit = 1000;
  line(0, height/2, width, height/2);
  text("Train", 11, 11+height/2 );
  text("Test", 261, 11+height/2 );
  text("Accuracy", 111, 11+height/2 );
  text("Accuracy", 361, 11+height/2 );
  text("RMSE", 181, 11+height/2 );
  text("RMSE", 431, 11+height/2 );
  for (int n = step; n<=upperLimit; n+=step) {
    wp.trainMLP("9,9", n, 0.3); // (hiddenLayers = "9,9", trainingTime = n, learningRate = 0.3)
    //wp.trainMLP("24", n, 0.3); // (hiddenLayers = "24", trainingTime = n, learningRate = 0.3)
    wp.evaluateTrainSet(5, false, false);  //5-fold cross validation (fold=5, isRegression=false, showEvalDetails=true);  //5-fold cross validation
    wp.evaluateTestSet(false, false);  //5-fold cross validation (isRegression = false, showEvalDetails=false)
    String resultTrainStr1 = "Epoch #"+n;
    String resultTrainStr2 = nf((float)wp.accuracyTrain, 0, 2)+"%";
    String resultTrainStr3 = nf((float)wp.rmseTrain, 0, 2);
    float resultTrainX = map(n, 0, upperLimit, 0, width);
    float resultTrainY = map((float)wp.accuracyTrain, 0, 100, height/2, 0);
    fill(200, 0, 0);
    text(resultTrainStr1, 11, 11+11*(n/step)+height/2 );
    text(resultTrainStr2, 111, 11+11*(n/step)+height/2 );
    text(resultTrainStr3, 181, 11+11*(n/step)+height/2 );
    ellipse(resultTrainX, resultTrainY, 6, 6);
    String resultTestStr1 = "Epoch #"+n;
    String resultTestStr2 = nf((float)wp.accuracyTest, 0, 2)+"%";
    String resultTestStr3 = nf((float)wp.rmseTest, 0, 2);    
    float resultTestX = map(n, 0, upperLimit, 0, width);
    float resultTestY = map((float)wp.accuracyTest, 0, 100, height/2, 0);
    fill(0, 0, 200);
    text(resultTestStr1, 261, 11+11*(n/step)+height/2 );
    text(resultTestStr2, 361, 11+11*(n/step)+height/2 );
    text(resultTestStr3, 431, 11+11*(n/step)+height/2 );
    ellipse(resultTestX, resultTestY, 6, 6);
  }
}

void draw() {
  //wp.drawModel(0, 0); //draw the model visualization (for 2D features)
  //wp.drawDataPoints(train); //draw the datapoints
  //float[] X = {mouseX, mouseY}; 
  //String Y = wp.getPrediction(X);
  ////double Y = wp.getPredictionIndex(X);
  //wp.drawPrediction(X, Y); //draw the prediction
}
