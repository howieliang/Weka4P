//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

Table csvData;

boolean b_saveCSV = false;

String dataSetName = "mouseTrainNum"; 
String[] attrNames = new String[]{"x", "y", "label"};
boolean[] attrIsNominal = new boolean[]{false, false, false};

int label = 0;

void setup() {
  size(500, 500);
  background(255);

  //Initiate the dataList and set the header of table
  csvData = new Table();
  for (int i = 0; i < attrNames.length; i++) {
    csvData.addColumn(attrNames[i]);
    if (attrIsNominal[i]) csvData.setColumnType(i, Table.STRING);
    else csvData.setColumnType(i, Table.FLOAT);
  }
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
    drawDataPoint(index, features);
  }
  drawMouseCursor(label);

  if (b_saveCSV) {
    //Save the table to the file folder
    saveCSV(dataSetName, csvData);
    saveARFF(dataSetName, csvData);
    //reset b_saveCSV;
    b_saveCSV = false;
  }
}

String getCharFromInteger(double i) { //0 = A, 1 = B, and so forth
  return ""+char(min((int)(i+'A'), 90));
}

void keyPressed() {
  if (key == 'S' || key == 's') {
    b_saveCSV = true;
  }
  if (key == ' ') {
    csvData.clearRows();
    label = 0;
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
  if (frameCount%10 == 0) {
    TableRow newRow = csvData.addRow();
    newRow.setFloat("x", mouseX);
    newRow.setFloat("y", mouseY);
    newRow.setFloat("label", label);
  }
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

void drawDataPoint(String _label, float[] _features) {
  pushMatrix();
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);

  stroke(0);
  fill(255);
  ellipse(_features[0], _features[1], 20, 20);
  noStroke();
  fill(0);
  translate(0, -1);
  text(_label, _features[0], _features[1]);
  popStyle();
  popMatrix();
}

void drawDataPoint(int _index, float[] _features) {
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);

  stroke(0);
  fill(255);
  ellipse(_features[0], _features[1], 20, 20);

  noStroke();
  fill(0);
  text(_index, _features[0], _features[1]);

  popStyle();
}

void saveCSV(String dataSetName, Table csvData) {
  saveTable(csvData, dataPath(dataSetName+".csv")); //save table as CSV file
  println("Saved as: ", dataSetName+".csv");
}

void saveARFF(String dataSetName, Table csvData) {
  String[] attrNames = csvData.getColumnTitles();
  int[] attrTypes = csvData.getColumnTypes();
  int lineCount = 1 + attrNames.length + 1 + (csvData.getRowCount()); //@relation + @attribute + @data + CSV
  String[] text = new String[lineCount];
  text[0] = "@relation "+dataSetName;
  for (int i = 0; i < attrNames.length; i++) {
    String s = "";
    ArrayList<String> dict = new ArrayList<String>();
    s += "@attribute "+attrNames[i];
    if (attrTypes[i]==0) {
      for (int j = 0; j < csvData.getRowCount(); j++) {
        TableRow row = csvData.getRow(j);
        String l = row.getString(attrNames[i]);
        boolean found = false;
        for (String d : dict) {
          if (d.equals(l)) found = true;
        }
        if (!found) dict.add(l);
      }
      s += " {";
      for (int n=0; n<dict.size(); n++) {
        s += dict.get(n);
        if (n != dict.size()-1) s += ",";
      }
      s += "}";
    } else s+=" numeric";
    text[1+i] = s;
  }
  text[1+attrNames.length] = "@data";
  for (int i = 0; i < csvData.getRowCount(); i++) {
    String s = "";
    TableRow row = csvData.getRow(i);
    for (int j = 0; j < attrNames.length; j++) {
      if (attrTypes[j]==0) s += row.getString(attrNames[j]);
      else s += row.getFloat(attrNames[j]);
      if (j!=attrNames.length-1) s +=",";
    }
    text[2+attrNames.length+i] = s;
  }
  saveStrings(dataPath(dataSetName+".arff"), text);
  println("Saved as: ", dataSetName+".arff");
}
