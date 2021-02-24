//Draw text info
//showInfo(String s, int v, float x, float y)
void showInfo(String s, float x, float y) { 
  pushStyle();
  fill(0);
  textSize(20);
  text(s, x, y);
  popStyle();
}

//Draw a bar graph to visualize the modeArray
//barGraph(float[] data, float x, float y, float width, float height)
void barGraph(float[] data, float _x, float _y, float _w, float _h) {
  color colors[] = {
    color(255, 0, 0), color(0), color(0, 0, 255), color(255, 0, 255), 
    color(255, 0, 255)
  };
  pushStyle();
  noStroke();
  float delta = _w / data.length;
  for (int p = 0; p < data.length; p++) {
    float i = data[p];
    int cIndex = min((int) i, colors.length-1);
    if (i<0) fill(255, 100);
    else fill(colors[cIndex], 100);
    float h = map(0, -1, 0, 0, _h);
    rect(_x, _y-h, delta, h);
    _x = _x + delta;
  }
  popStyle();
}


//Draw a line graph to visualize the sensor stream
//lineGraph(float[] data, float lowerbound, float upperbound, float x, float y, float width, float height, int _index)  
void lineGraph(float[] data, float _l, float _u, float _x, float _y, float _w, float _h, int _index) {
  color colors[] = {
    color(255, 0, 0), color(0), color(0, 0, 255), color(255, 0, 255), 
    color(255, 0, 255)
  };
  int index = min(max(_index, 0), colors.length);
  pushStyle();
  float delta = _w/(data.length-1);
  beginShape();
  noFill();
  stroke(colors[index]);
  for (float i : data) {
    float h = map(i, _l, _u, 0, _h);
    vertex(_x, _y+h);
    _x = _x + delta;
  }
  endShape();
  popStyle();
}
