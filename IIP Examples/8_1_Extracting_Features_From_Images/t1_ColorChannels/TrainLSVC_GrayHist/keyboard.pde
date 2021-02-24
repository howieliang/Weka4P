void keyPressed() {
  //if (key == 'A' || key == 'a') {
  //  energyThld = min(energyThld+5, 100);
  //}
  //if (key == 'Z' || key == 'z') {
  //  energyThld = max(energyThld-5, 10);
  //}
  if (key == 'C' || key == 'c') {
    csvData.clearRows();
    println(csvData.getRowCount());
  }
  if (key == 'X' || key == 'x') {
    csvData.removeRow(csvData.getRowCount()-1);
  }
  if (key == 'S' || key == 's') {
    b_saveCSV = true;
  }
  if (key == '/') {
    ++labelIndex;
    labelIndex %= 10;
  }
  if (key == '0') {
    labelIndex = 0;
  }
}
