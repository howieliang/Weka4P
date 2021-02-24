void keyPressed() {
  if (key == ENTER) {
    dots.clear();
    clusters.clear();
    resetData();
    iterations = 0;
  }
  if (key == ' ') {
    bUpdate = true;
  }
}
