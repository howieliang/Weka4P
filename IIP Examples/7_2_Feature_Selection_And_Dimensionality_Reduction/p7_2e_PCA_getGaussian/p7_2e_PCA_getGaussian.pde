//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

Table csvData;
String fileName = "data/testData.csv";
boolean b_saveCSV = false;
boolean b_trained = false;

int label = 0;

void setup() {
  size(500, 500);

  //Initiate the dataList and set the header of table
  csvData = new Table();
  csvData.addColumn("x");
  csvData.addColumn("y");
  csvData.addColumn("label");
}

void draw() {
  background(255);

  for (int i = 0; i < csvData.getRowCount(); i++) { 
    //read the values from the file
    TableRow row = csvData.getRow(i);
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    float id = row.getFloat("label");
    int index = (int) id;

    //form a feature array
    float[] features = { x, y };

    //draw the data on the Canvas
    drawDataPoint(features);
    if (b_trained) { 
      drawDataResidual(features);
      drawDataProjection(features);
    }
  }

  if (b_trained) {
    float angle = -axis1.heading();
    noFill();
    stroke(0, 255, 0);
    line(mean.x, mean.y, mean.x+axis1.x, mean.y+axis1.y);
    stroke(255, 0, 0);
    line(mean.x, mean.y, mean.x+axis2.x, mean.y+axis2.y);
    
    pushStyle();
    pushMatrix();
    ellipseMode(CENTER);
    translate(mean.x, mean.y);
    rotate(axis1.heading());
    ellipse(0,0,4*Descriptive.std(allX, true),4*Descriptive.std(allY, true));
    popMatrix();
    popStyle();
  }

  if (b_saveCSV) {
    getEigenVectors(csvData);
    //Save the table to the file folder
    saveTable(csvData, fileName); //save table as CSV file
    println("Saved as: ", fileName);
    //reset b_saveCSV;
    b_saveCSV = false;
    b_trained = true;
  }

  drawMouseCursor(label);
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
  newRow.setFloat("label", label);
}

void keyPressed() {
  if (key == 'T' || key == 't') {
    b_saveCSV = true;
  }
  if (key == ' ') {
    b_trained = false;
    csvData.clearRows();
    label = 0;
  }
}

void drawDataProjection(float[] _features) {
  pushStyle();

  PVector p0 = PVector.sub(mean, axis1);
  PVector p1 = PVector.add(mean, axis1);
  PVector p = new PVector(_features[0], _features[1]);
  PVector crossP = point_nearest_line(p0, p1, p);
  float d = PVector.sub(crossP, p0).mag() / PVector.sub(p1, p0).mag();

  if (crossP!=null) { 
    noStroke();
    fill(0);
    ellipse(d*width, height-50, 3, 3);
    stroke(0);
    noFill();
    line(0, height-50, width, height-50);
  }

  popStyle();
}

void drawDataResidual(float[] _features) {
  pushStyle();

  stroke(0);
  fill(255);
  PVector p0 = PVector.sub(mean, axis1);
  PVector p1 = PVector.add(mean, axis1);
  PVector p = new PVector(_features[0], _features[1]);
  PVector crossP = point_nearest_line(p0, p1, p);
  float d = PVector.sub(crossP, p0).mag() / PVector.sub(p1, p0).mag();

  if (crossP!=null) { 
    noStroke();
    fill(0);
    ellipse(crossP.x, crossP.y, 3, 3);
    stroke(0);
    noFill();
    line(_features[0], _features[1], crossP.x, crossP.y);
  }

  popStyle();
}

void drawDataPoint(float[] _features) {
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);

  stroke(0);
  fill(255);
  ellipse(_features[0], _features[1], 10, 10);

  popStyle();
}

void drawMouseCursor(int _index) {
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);
  if (mousePressed) {
    stroke(0);
    fill(255);
  } else { 
    noStroke();
    fill(0);
  }
  ellipse(mouseX, mouseY, 10, 10);

  if (mousePressed) {
    noStroke();
    fill(0);
  } else { 
    fill(255);
  }
  //text(_index, mouseX, mouseY);

  popStyle();
}
