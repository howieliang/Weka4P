/*

 Charles Fried - 2017
 ANN Tutorial 
 Part #1
 
 MAIN TAB
 
 Original from Alasdair Turner (c) 2009
 Free software: you can redistribute this program and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 */


int totalTrain = 0;
int totalTest = 0;
int totalRight = 0;
float sucess = 0;
int testCard = 0;
int trainCard = 0;

Network neuralnet;
Button trainB, testB;

float lastFrameCount = 0;

void setup() {

  size(1000, 400);
  setupSigmoid();
  loadData();

  //make a 196-49-10 neural network
  neuralnet = new Network(196, 49, 10);

  smooth();
  stroke(150);

  trainB = new Button(width*0.06, height*0.9, "Reset");
  testB = new Button(width*0.11, height*0.9, "Test");
}

void draw() {

  background(255);
  neuralnet.display();

  if ((frameCount-lastFrameCount)<=200) {
    for (int i = 0; i < 50; i++) {
      trainCard = (int) floor(random(0, training_set.length));
      neuralnet.respond(training_set[trainCard]);
      neuralnet.train(training_set[trainCard].outputs);
      totalTrain++;
    }
  }

  fill(100);
  text("Test card: #" + testCard, width*0.18, height*0.89);
  text("Train card: " + trainCard, width*0.18, height*0.93);

  text("Total train: " + totalTrain, width*0.32, height*0.89);
  text("Total test: " + totalTest, width*0.32, height*0.93);

  if (totalTest>0) sucess = float(totalRight)/float(totalTest);
  else sucess = 1;
  text("Success rate: " + nfc(sucess, 2), width*0.44, height*0.89);
  text("Card label: " + testing_set[testCard].output, width*0.44, height*0.93);

  //show the two buttons
  trainB.display();
  testB.display();
}

void mousePressed() {
  if (trainB.hover()) {
    neuralnet = new Network(196, 49, 10);
    totalTrain = 0;
    totalRight = 0;
    totalTest = 0;
    lastFrameCount = frameCount;
  } else if (testB.hover()) {
    testCard = (int) floor(random(0, testing_set.length));
    neuralnet.respond(testing_set[testCard]);
    neuralnet.display();
    if (neuralnet.bestIndex == testing_set[testCard].output) totalRight ++;
    println(testCard + "  " + neuralnet.bestIndex + "  " + testing_set[testCard].output);
    totalTest ++;
  }
  redraw();
}
