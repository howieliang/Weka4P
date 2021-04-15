//*********************************************
//  A_CollectDataNum_mouse : Collects data from user input with the mouse
//
//  Author: Rong-Hao Liang <r.liang@tue.nl>
//  Edited by: Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (18 03 2021)
//
//  Manual:
//  Start the program and draw with your mouse.
//  When pressing your right mouse button the number 
//  of the label will increase by 1.
// 
//  Press the "s" key on your keyboard to save 
//  the data to an ARFF and a CSV file.
//  You can find these files in the data folder
//  in your sketch folder.
//  Sketch -> Show Sketch Folder (ctrl/cmd + K)
// 
//  To reset the data press spacebar.
//
//*********************************************

Table csvData;                                                  // Main Table object to store the dataset

String dataSetName = "mouseTrainNum";                           // Name fo the dataset file
//String dataSetName = "mouseTestNum";                            // Name fo the test dataset file
String[] attrNames = new String[]{"x", "y", "label"};           // Names of the headers
boolean[] attrIsNominal = new boolean[]{false, false, false};   // Boolean array to address if the values are Nominal or not


int label = 0;                                                  // Current label value
int labelLimit = 10;                                            // Max number of labels in the dataset

void setup() {
  
  size(500, 500);
  background(255);

  /* Initiate the dataList (Table object) and set the header of table */
  csvData = new Table();
  for (int i = 0; i < attrNames.length; i++) {
    csvData.addColumn(attrNames[i]);
    if (attrIsNominal[i]) csvData.setColumnType(i, Table.STRING);
    else csvData.setColumnType(i, Table.FLOAT);
  }
}

void draw() {
  background(255);
 
  drawDataPoints();
  drawMouseCursor(label);
}
