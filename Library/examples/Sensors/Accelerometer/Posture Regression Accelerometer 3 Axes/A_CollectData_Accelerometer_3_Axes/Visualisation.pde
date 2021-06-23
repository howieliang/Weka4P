String getCharFromInteger(double i) { //0 = A, 1 = B, and so forth
  return ""+char(min((int)(i+'A'), 90));
}

void drawLabel(int _index) {
  pushStyle();
  textSize(32);
  textAlign(CENTER, CENTER);
  fill(100);
  text(_index, 50, 50);
  popStyle();
}
