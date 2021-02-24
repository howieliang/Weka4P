void keyPressed() {
  if (key == 'S' || key == 's') {
    b_saveCSV = true;
  }
  if (key == 'T' || key == 't') {
    b_train = true;
    b_test = false;
    b_saveCSV = true;
  }
  if (key == 'D' || key == 'd') {
    b_train = true;
    b_test = false;
  }
  if (key == ' ') {
    csvData.clearRows();
    label = 0;
  }
  if (key >= '0' && key <= '9') {
    label = key - '0';
  }
}
