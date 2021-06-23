void mousePressed() {
  if (mouseButton == RIGHT) {
    ++labelIndex;
    labelIndex %= 10;
  }
}

void keyPressed() {
  if (key == 'S' || key == 's') {
    b_saveCSV = true;
  }
  if (key == ' ') {
    dataIndex = 0;
  }
  if (key == '/') {
    ++labelIndex;
    labelIndex %= 10;
  }
  if (key == '0') {
    labelIndex = 0;
  }
  if (key == 'C' || key == 'c') {
    csvData.clearRows();
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
