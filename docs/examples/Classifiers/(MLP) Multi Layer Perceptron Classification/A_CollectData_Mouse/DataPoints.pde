void drawDataPoints(){
   for (int i = 0; i < csvData.getRowCount(); i++) { 
    //read the values from the file
    TableRow row = csvData.getRow(i);
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    String label = row.getString("label");
    
    //form a feature array
    float[] features = { x, y };

    //draw the data on the Canvas
    drawDataPoint(label, features);
  }
}

/* Draws a datapoint with label at the stored location */
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

/* Draws a datapoint without lable at teh stored location */
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
