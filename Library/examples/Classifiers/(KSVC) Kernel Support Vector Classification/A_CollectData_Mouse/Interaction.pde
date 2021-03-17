
/* Draws the mouse cursor with the current label */
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
  text(getCharFromInteger(_index), mouseX, mouseY);

  popStyle();
}

/* When the S "save" key is pressed the data will be stored in the data folder of this sketch */
void keyPressed() {
  if (key == 'S' || key == 's') {
    saveData();
  }
  if (key == ' ') {
    csvData.clearRows();
    label = 0;
  }
}

/* When the right mouse button is pressed the lable will change */
/* The number of labels is limited to a set amount (default = 10)  */
void mousePressed() {
  if (mouseButton == RIGHT) {
    ++label;
    label %= labelLimit;
  }
}

/* When the mouse is dragged the X and Y coordinates will be stored in the Table object */
/* The rate of the data stored is limited to every 10th frame */
void mouseDragged() {
  //add a row with new data 
  if (frameCount%10 == 0) {
    TableRow newRow = csvData.addRow();
    newRow.setFloat("x", mouseX);
    newRow.setFloat("y", mouseY);
    newRow.setString("label", getCharFromInteger(label));
  }
}
