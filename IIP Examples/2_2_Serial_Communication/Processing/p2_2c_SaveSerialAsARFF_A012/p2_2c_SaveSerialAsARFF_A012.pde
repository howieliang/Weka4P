//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import processing.serial.*;
Serial port; 

int dataNum = 100;
int sensorNum = 3;
int[][] rawData = new int[sensorNum][dataNum];
int dataIndex = 0;

Table csvData;
boolean b_saveCSV = false;
String dataSetName = "accData"; 
String[] attrNames = new String[]{"x", "y", "z", "label"};
boolean[] attrIsNominal = new boolean[]{false, false, false, true};
int labelIndex = 0;

void setup() {
  size(500, 500);

  //Initialize the serial port
  for (int i = 0; i < Serial.list().length; i++) println("[", i, "]:", Serial.list()[i]);
  String portName = Serial.list()[Serial.list().length-1];//MAC: check the printed list
  //String portName = Serial.list()[9];//WINDOWS: check the printed list
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n'); // arduino ends each data packet with a carriage return 
  port.clear();           // flush the Serial buffer

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
  float pointSize = height/dataNum;
  for (int i = 0; i < dataIndex; i++) {
    for (int n = 0; n < sensorNum; n++) {
      noStroke();
      if (n==0) fill(255, 0, 0);
      if (n==1) fill(0, 255, 0);
      if (n==2) fill(0, 0, 255);
      ellipse(i*pointSize, rawData[n][i], pointSize, pointSize);
      textSize(pointSize);
      textAlign(CENTER, CENTER);
      fill(0);
      text(getCharFromInteger(labelIndex), i*pointSize, rawData[n][i]);
    }
  }
  if (dataIndex==dataNum) {
    if (b_saveCSV) {
      for (int n = 0; n < dataNum; n ++) {
        TableRow newRow = csvData.addRow();
        newRow.setFloat("x", rawData[0][n]);
        newRow.setFloat("y", rawData[1][n]);
        newRow.setFloat("z", rawData[2][n]);
        newRow.setString("label", getCharFromInteger(labelIndex));
      }
      saveCSV(dataSetName, csvData);
      saveARFF(dataSetName, csvData);
      
      b_saveCSV = false;
    }
    drawMouseCursor(labelIndex);
  }
}

void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');  // read the serial string until seeing a carriage return
  if (dataIndex<dataNum) {
    if (inData.charAt(0) == 'A') {
      rawData[0][dataIndex] = int(trim(inData.substring(1)));
    }
    if (inData.charAt(0) == 'B') {
      rawData[1][dataIndex] = int(trim(inData.substring(1)));
    }
    if (inData.charAt(0) == 'C') {
      rawData[2][dataIndex] = int(trim(inData.substring(1)));
      ++dataIndex;
    }
  }
  return;
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    ++labelIndex;
    labelIndex %= 10;
  }
}

String getCharFromInteger(double i) { //0 = A, 1 = B, and so forth
  return ""+char(min((int)(i+'A'), 90));
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
  //ellipse(mouseX, mouseY, 20, 20);
  if (mousePressed) {
    noStroke();
    fill(255);
  } else { 
    fill(100);
  }
  text(getCharFromInteger(_index), mouseX-10, mouseY-10);

  popStyle();
}


void keyPressed() {
  if (key == 'S' || key == 's') {
    b_saveCSV = true;
  }
  if (key == ' ') {
    dataIndex = 0;
  }
  if (key == 'C' || key == 'c') {
    csvData.clearRows();
  }
  
}

void saveCSV(String dataSetName, Table csvData){
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
