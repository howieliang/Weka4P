void mousePressed() {
  if (mouseButton == RIGHT) {
    ++label;
    label %= 10;
  }
}

void mouseDragged() {
  //add a row with new data 
  TableRow newRow = csvData.addRow();
  newRow.setFloat("x", (float)mouseX);
  newRow.setFloat("y", (float)mouseY);
  newRow.setFloat("label", label);
}
