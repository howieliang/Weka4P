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

int[] clusterAssignments;

PVector[][] clusterGaussian; 

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
      em = new EM();
      em.setSeed(millis()%10);
      em.setNumClusters(K);
      em.buildClusterer(training);
      //println(em);

      clusterGaussian = new PVector[K][2];
      for (int i = 0; i < K; i++) {
        for (int j = 0; j < 2; j++) { //feature number
          clusterGaussian[i][j] = new PVector((float)em.getClusterModelsNumericAtts()[i][j][0], (float)em.getClusterModelsNumericAtts()[i][j][1], (float)em.getClusterModelsNumericAtts()[i][j][2]);
        }
      }
      weka.core.SerializationHelper.write(dataPath("em.model"), em);

      ClusterEvaluation eval = new ClusterEvaluation();
      eval.setClusterer(em);
      eval.evaluateClusterer(training);
      println(eval.clusterResultsToString());

      b_train = false;
      b_test = true;
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  for (int i = 0; i < csvData.getRowCount(); i++) { 
    TableRow row = csvData.getRow(i);
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    float[] features = { x, y }; //form a feature array
    drawDataPoint(-1, features); //draw the data on the Canvas
  }

  color colors[] = {
    color(155, 89, 182), color(63, 195, 128), color(214, 69, 65), 
    color(82, 179, 217), color(244, 208, 63), color(242, 121, 53), 
    color(0, 121, 53), color(128, 128, 0), color(52, 0, 128), 
    color(128, 52, 0), color(52, 128, 0), color(128, 52, 0)
  };

  if (b_test) {
    for (int i = 0; i < K; i++) {
      pushStyle();
      pushMatrix();
      fill(255,128);
      stroke(colors[i]);
      ellipse(clusterGaussian[i][0].x, clusterGaussian[i][1].x, 4*clusterGaussian[i][0].y, 4*clusterGaussian[i][1].y);
      textAlign(CENTER,CENTER);
      textSize(32);
      noStroke();
      fill(colors[i]);
      text(""+round(clusterGaussian[i][0].z), clusterGaussian[i][0].x, clusterGaussian[i][1].x);
      popMatrix();
      popStyle();
    }
  }

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
