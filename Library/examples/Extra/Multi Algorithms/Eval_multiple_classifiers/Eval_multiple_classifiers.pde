//*********************************************
//  Eval_multiple_classifiers : Evaluates multiple Classifiers
//
//  Author: Rong-Hao Liang <r.liang@tue.nl>
//  Edited by: Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (23 06 2021)
//
//  Manual:
//  Load multiple models in the setup.
//  All predictions of those models are visualized 
//
//  Evaluation details can be found in the console
//
//*********************************************

import weka.core.Attribute; //https://weka.sourceforge.io/doc.dev/weka/core/Attribute.html
import weka.classifiers.Classifier; //https://weka.sourceforge.io/doc.stable-3-8/weka/classifiers/Classifier.html
import weka.core.Instances; //https://weka.sourceforge.io/doc.dev/weka/core/Instances.html

import Weka4P.*;
Weka4P wp;

ArrayList<Attribute>[] attributes = new ArrayList[1];
Instances[] instances = new Instances[1];
Classifier[] classifiers = new Classifier[3];

void setup() {
  size(500, 500);             //set a canvas
  wp = new Weka4P(this);
  
  instances[0] = wp.loadTrainARFFToInstances("mouseTrain.arff");
  attributes[0] = wp.loadAttributesFromInstances(instances[0]);
  classifiers[0] = wp.loadModelToClassifier("RBFSVC.model");            //load a pretrained model.
  classifiers[1] = wp.loadModelToClassifier("LinearSVC.model");         //load a pretrained model.
  classifiers[2] = wp.loadModelToClassifier("KNN.model");               //load a pretrained model.
  wp.loadTestARFF("mouseTrain.arff");                                   //load a ARFF dataset
  wp.evaluateTestSet(classifiers[0],wp.test,false, true);               //5-fold cross validation (, , isRegression = false, showEvalDetails=true)
  wp.evaluateTestSet(classifiers[1],wp.test,false, true);               //5-fold cross validation (, , isRegression = false, showEvalDetails=true)
  wp.evaluateTestSet(classifiers[2],wp.test,false, true);               //5-fold cross validation (, , isRegression = false, showEvalDetails=true)
}
void draw() {
  background(255);
  float[] X = {mouseX, mouseY};
  String[] Y = new String[classifiers.length];
  for(int i = 0 ; i < classifiers.length ; i++){
    Y[i] = wp.getPrediction(X, classifiers[i], attributes[0],instances[0]);
    wp.drawPrediction(X, Y[i], wp.colors[i]);                            //draw the prediction
  }
}
