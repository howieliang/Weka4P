//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

Table csvData;
String fileName = "data/testData.csv";
boolean b_saveCSV = false;
boolean b_train = false;
boolean b_test = false;

int label = 0;
PGraphics pg;
int K = 1;
double WCSS = 0;
int[] clusterAssignments;

void setup() {
  size(500, 500);

  //Initiate the dataList and set the header of table
  csvData = new Table();
  csvData.addColumn("x");
  csvData.addColumn("y");
  //csvData.addColumn("label");

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
      initTrainingSetNonLabel(csvData); // in Weka.pde
      kmeans = new SimpleKMeans();
      kmeans.setSeed(millis()%10);
      kmeans.setPreserveInstancesOrder(true);
      kmeans.setNumClusters(K);
      kmeans.buildClusterer(training);
      clusterAssignments = kmeans.getAssignments();
      WCSS = kmeans.getSquaredError();
      println(kmeans);
      weka.core.SerializationHelper.write(dataPath("kMean.model"), kmeans);
      //pg = getModelImage(pg, (Classifier)cls, training);
      b_train = false;
      b_test = true;
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  image(pg, 0, 0);
  for (int i = 0; i < csvData.getRowCount(); i++) { 
    TableRow row = csvData.getRow(i);
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    //float id = row.getFloat("label");
    //int index = (int) id;

    float[] features = { x, y }; //form a feature array
    if (b_test) {
      if (i<clusterAssignments.length) drawDataPoint(clusterAssignments[i], features); //draw the data on the Canvas
      else drawDataPoint(-1, features); //draw the data on the Canvas
    } else {
      drawDataPoint(-1, features); //draw the data on the Canvas
    }
  }

  if (b_test) {
    pushStyle();
    fill(0);
    textSize(24);
    text("K="+K, 20, 20);
    text("WCSS="+nf((float)WCSS,0,2), 20, 44);
    popStyle();
  }

  //if (b_test) {
  //  Instance inst = new DenseInstance(3);     
  //  inst.setValue(training.attribute(0), (float)mouseX); 
  //  inst.setValue(training.attribute(1), (float)mouseY); 

  //  // "instance" has to be associated with "Instances"
  //  Instances testData = new Instances("Test Data", attributes, 0);
  //  testData.add(inst);
  //  testData.setClassIndex(2);        

  //  //float classification = -1;
  //  //try {
  //  //  classification = (float) cls.classifyInstance(testData.firstInstance());
  //  //} 
  //  //catch (Exception e) {
  //  //  e.printStackTrace();
  //  //} 
  //  //drawMouseCursor((int)classification);
  //} else {
  //  drawMouseCursor(label);
  //}
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    ++label;
    label %= 10;
  }
}

void mouseDragged() {
  //add a row with new data 
  TableRow newRow = csvData.addRow();
  newRow.setFloat("x", mouseX);
  newRow.setFloat("y", mouseY);
  //newRow.setFloat("label", label);
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
    K = 0;
  }
  if (key >= '1' && key <= '9') {
    K = key - '0';
    b_train = true;
    b_test = false;
    b_saveCSV = true;
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
  if (_index<0) fill(255);
  else fill(colors[_index]);
  ellipse(_features[0], _features[1], 20, 20);

  noStroke();
  fill(0);
  if (_index>=0) text(_index, _features[0], _features[1]);

  popStyle();
}
