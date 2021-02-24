//********************************************* //<>// //<>//
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

Table csvData;
String fileName = "data/testData.csv";
boolean b_saveCSV = false;
boolean b_train = false;
boolean b_test = false;
boolean b_showData = true;

int label = 0;
PGraphics pg;
int K = 1;

int imgGridSize = 5;

void setup() {
  size(500, 500);

  //Initiate the dataList and set the header of table
  csvData = new Table();
  csvData.addColumn("x");
  csvData.addColumn("y");
  csvData.addColumn("label");

  pg = createGraphics(width, height);
}

void draw() {
  background(255);
  if (b_saveCSV) {
    saveTable(csvData, fileName); //Save the current table as a CSV file to the file folder 
    println("Saved as: ", fileName);
    b_saveCSV = false; //reset b_saveCSV;
  }

  if (b_train) {
    try {
      initTrainingSet(csvData); // in Weka.pde
      cls = new IBk(K); //IBk(int k): kNN classifier.
      cls.buildClassifier(training); //Train the classifier
      weka.core.SerializationHelper.write(dataPath("kNN.model"), cls);
      pg = getModelImage(pg, (Classifier)cls, training,imgGridSize,imgGridSize);
      b_train = false;
      b_test = true;
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  image(pg, 0, 0);
  pushStyle();
  fill(0);
  textSize(24);
  text("K="+K+", Current Label="+label, 20, 20);
  popStyle();
  for (int i = 0; i < csvData.getRowCount(); i++) { 
    TableRow row = csvData.getRow(i);
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    float id = row.getFloat("label");
    int index = (int) id;

    float[] features = { x, y }; //form a feature array
    drawDataPoint(index, features); //draw the data on the Canvas
  }

  if (b_test) {
    Instance inst = new DenseInstance(3);     
    inst.setValue(training.attribute(0), (float)mouseX); 
    inst.setValue(training.attribute(1), (float)mouseY); 

    // "instance" has to be associated with "Instances"
    Instances testData = new Instances("Test Data", attributes, 0);
    testData.add(inst);
    testData.setClassIndex(2);        

    float classification = -1;
    try {
      classification = (float) cls.classifyInstance(testData.firstInstance());
    } 
    catch (Exception e) {
      e.printStackTrace();
    } 
    drawMouseCursor(label);
  } else {
    drawMouseCursor(label);
  }
  pushStyle();
  fill(0);
  text("Press key [0-9] to change label",20,height-20);
  popStyle();
}

void mousePressed() {
  if (b_test) {
    TableRow newRow = csvData.addRow();
    newRow.setFloat("x", mouseX);
    newRow.setFloat("y", mouseY);
    newRow.setFloat("label", label);
    
    Instance inst = new DenseInstance(3);     
    inst.setValue(training.attribute(0), (float)mouseX); 
    inst.setValue(training.attribute(1), (float)mouseY); 
    inst.setValue(training.attribute(2), label);

    // "instance" has to be associated with "Instances"
    Instances testData = new Instances("Test Data", attributes, 0);
    testData.add(inst);
    testData.setClassIndex(2);
    try {
      cls.updateClassifier(testData.firstInstance());
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    //pg = getModelImage(pg, (Classifier)cls, training);
    pg = getModelImage(pg, (Classifier)cls, training, imgGridSize, imgGridSize);
  }
}

void mouseDragged() {
  if (!b_test) {
    //add a row with new data 
    TableRow newRow = csvData.addRow();
    newRow.setFloat("x", mouseX);
    newRow.setFloat("y", mouseY);
    newRow.setFloat("label", label);
  }
}

void keyPressed() {
  if (key == 'S' || key == 's') {
    b_saveCSV = true;
  }
  if (key == 'T' || key == 't') {
    b_train = true;
    b_test = false;
    b_saveCSV = true;
  }
  if (key == 'D' || key == 'd') {
    b_train = true;
    b_test = false;
  }
  if (key == ' ') {
    csvData.clearRows();
    label = 0;
  }
  if (key >= '0' && key <= '9') {
    label = key - '0';
  }
}

void drawMouseCursor(int _index) {
  color colors[] = {
    color(155, 89, 182), color(63, 195, 128), color(214, 69, 65), 
    color(82, 179, 217), color(244, 208, 63), color(242, 121, 53), 
    color(0, 121, 53), color(128, 128, 0), color(52, 0, 128), 
    color(128, 52, 0), color(52, 128, 0), color(128, 52, 0)
  };
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);
  if (mousePressed) {
    stroke(0);
    fill(255);
  } else { 
    noStroke();
    fill(colors[_index]);
  }
  ellipse(mouseX, mouseY, 20, 20);

  if (mousePressed) {
    noStroke();
    fill(0);
  } else { 
    fill(255);
  }
  text(_index, mouseX, mouseY);

  popStyle();
}

void drawDataPoint(int _index, float[] _features) {
  color colors[] = {
    color(155, 89, 182), color(63, 195, 128), color(214, 69, 65), 
    color(82, 179, 217), color(244, 208, 63), color(242, 121, 53), 
    color(0, 121, 53), color(128, 128, 0), color(52, 0, 128), 
    color(128, 52, 0), color(52, 128, 0), color(128, 52, 0)
  };
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);

  stroke(0);
  fill(colors[_index]);
  ellipse(_features[0], _features[1], 20, 20);

  noStroke();
  fill(0);
  text(_index, _features[0], _features[1]);

  popStyle();
}
