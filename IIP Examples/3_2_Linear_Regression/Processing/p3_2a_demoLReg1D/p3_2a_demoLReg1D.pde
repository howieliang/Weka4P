//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

void setup() {
  size(500, 500);
  initDemo();
}
void draw() {
  background(255);
  if (b_saveCSV) {
    saveCSV(csvData, fileName);
  }
  if (b_train) {
    try {
      initTrainingSet(csvData, 2); // in Weka.pde
      lReg = new LinearRegression();
      lReg.buildClassifier(training);
      modelEvaluation();
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
  if (b_test) {
    double Y = g((float) mouseX);
    image(pg2, 0, 0);
    drawMouseMono(Y);
  } else {
    drawMouseMono(mouseY);
  }
  drawCSVData();
  pushStyle();
  fill(52);
  text("Press 'T' to train a regressor. \nPress 'SPACE' to clear the canvas.",20,20);
  popStyle();
}
