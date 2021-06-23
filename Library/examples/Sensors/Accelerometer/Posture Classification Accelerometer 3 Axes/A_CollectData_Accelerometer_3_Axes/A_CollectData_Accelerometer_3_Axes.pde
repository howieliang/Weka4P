//*********************************************
//  A_CollectData_Accelerometer_3_Axes : Collects data from a accelerometer with Arduino with nominal labels
//
//  Author: Rong-Hao Liang <r.liang@tue.nl>
//  Edited by: Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (21 06 2021)
//
//  Manual:
//  Upload the Arduino sketch (Serial_Rx_Tx_MPU6050_100Hz) to your Arduino 
//  (or other board like Teensy), make sure the device is connected.
//
//  You can find this sketch in the Arduino folder of the Accelerometer examples.
//
//  Start the program and hold you device in a desired position.
//
//  Press the "s" key on your keyboard to save 
//  the data to an ARFF and a CSV file.
//
//  You have to press 's' for save for every new label.
//
//  You can find these files in the data folder
//  in your sketch folder.
//  Sketch -> Show Sketch Folder (ctrl/cmd + K)
// 
//  To reset the data press spacebar.
//
//  To increase the label press '/' or right click (max 10 labels)
//  To reset the label to 0 press '0' 
//
//  To clear the data table press "c"
//
//*********************************************

import processing.serial.*;                                               // Import the Serial Library
Serial port;                                                              // Variable for the Serial communication

int dataNum = 100;                                                        // Number of datapoints to capture
int sensorNum = 3;                                                        // Number of sensors that is being read
int[][] rawData = new int[sensorNum][dataNum];                            // Storage for sensordata
int dataIndex = 0;                                                        // Index for the data

Table csvData;                                                            // Main Table object to store the dataset
boolean b_saveCSV = false;                                                // Boolean to initiate saving
String dataSetName = "accData";                                           // Name fo the dataset file
String[] attrNames = new String[]{"x", "y", "z", "label"};                // Names of the headers
boolean[] attrIsNominal = new boolean[]{false, false, false, true};       // Boolean array to address if the values are Nominal or not
int labelIndex = 0;                                                       // Current label index                              

void setup() {
  size(500, 500);

                                                                          // Setup Serial communication                                                
  printArray(Serial.list());                                              // Print a list of available Serial devices to console 
  String portName = Serial.list()[0];                                     // Replace '0' with the index of your Arduino or Teensy
  
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n');                                                 // Arduino ends each data packet with a new line character
  port.clear();                                                           // Flush the Serial buffer to start clean

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
  
  float pointSize = height/dataNum;                                        
  for (int i = 0; i < dataIndex; i++) {                                        // Iterate over every data entry
    for (int n = 0; n < sensorNum; n++) {                                      // In every data entry there are 3 datapoints (XYX)
      noStroke();  
      if (n==0) fill(255, 0, 0);                                               // X = Red
      if (n==1) fill(0, 255, 0);                                               // Y = Green
      if (n==2) fill(0, 0, 255);                                               // Z = Blue
      ellipse(i*pointSize, rawData[n][i], pointSize, pointSize);               // Draw the point in correct color
      textSize(pointSize);                                                     // Set size of text even
      textAlign(CENTER, CENTER);                                               // Align Text vertical and horizontal in center
      fill(0);                                                                 // Make text black
      text(getCharFromInteger(labelIndex), i*pointSize, rawData[n][i]);        // Display the label
    }
  }
  
  if (dataIndex==dataNum) {                                                    // When desired number of datapoints is captured
    if (b_saveCSV) {                                                           // When user decided to save the data
      for (int n = 0; n < dataNum; n ++) {                                     // Loop trough all data points and make a new row for each in the table
        TableRow newRow = csvData.addRow();
        newRow.setFloat("x", rawData[0][n]);
        newRow.setFloat("y", rawData[1][n]);
        newRow.setFloat("z", rawData[2][n]);
        newRow.setString("label", getCharFromInteger(labelIndex));
      }
      saveCSV(dataSetName, csvData);                                           // Save data as CSV to data folder
      saveARFF(dataSetName, csvData);                                          // Save data as ARFF to data folder

      b_saveCSV = false;                                                       // Resets the save
    }
    
    drawLabel(labelIndex);                                                     // Draws the label when data is gathered
  }
}
