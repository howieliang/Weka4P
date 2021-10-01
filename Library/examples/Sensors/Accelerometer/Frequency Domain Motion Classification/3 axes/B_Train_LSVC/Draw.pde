//Draw text info
//showInfo(String s, int v, float x, float y)
void showInfo(String s, float x, float y, int fs) { 
  pushStyle();
  textAlign(LEFT,BOTTOM);
  fill(0);
  textSize(fs);
  text(s, x, y);
  popStyle();
}

void drawFFTInfo(int x, int y, int fs) {
  pushStyle();
  fill(0);
  textSize(fs);
  float fps = frameRate;
  float fNormL = map(LOW_THLD, 0, numBins, 0, sampleRate/2);
  float fNormH = map(HIGH_THLD, 0, numBins, 0, sampleRate/2);
  float overlapping = (fps>0 ? 1-(sampleRate)/(numBins*fps):0);
  text("[N]umber of Bands: "+numBands+" [#"+LOW_THLD+"("+nf(fNormL,0,1)+"Hz)"+" - #"+HIGH_THLD+"("+nf(fNormH,0,1)+"Hz)]", x, y+0*fs);
  text("[S]ample Rate: "+nf(sampleRate, 0, 0)+" Hz", x, y+1*fs);
  text("[B]in Number(total): "+numBins, x, y+2*fs);
  text("[F]rame Rate: "+nf(fps, 0, 2)+" fps", x, y+3*fs);
  text("Overlapping [1-S/BF]]: "+nf((float)overlapping*100, 0, 2)+" %", x, y+4*fs);
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

//Draw a bar graph to visualize the modeArray
//barGraph(float[] data, float _l, float _u, float x, float y, float width, float height)
void barGraph(float[] data, float _l, float _u, float _x, float _y, float _w, float _h) {
  color colors[] = {
    color(155, 89, 182), color(63, 195, 128), color(214, 69, 65), color(82, 179, 217), color(244, 208, 63), 
    color(242, 121, 53), color(0, 121, 53), color(128, 128, 0), color(52, 0, 128), color(128, 52, 0)
  };
  pushStyle();
  noStroke();
  float delta = _w / data.length;
  for (int p = 0; p < data.length; p++) {
    float i = data[p];
    int cIndex = min((int) i, colors.length-1);
    if (i<0) fill(255, 100);
    else fill(colors[cIndex], 100);
    float h = map(_u, _l, _u, 0, _h);
    rect(_x, _y-h, delta, h);
    _x = _x + delta;
  }
  popStyle();
}

//lineGraph(float[] data, float lowerbound, float upperbound, float x, float y, float width, float height, int _index)
void lineGraph(float[] data, float _l, float _u, float _x, float _y, float _w, float _h, int _index, color c) {
  pushStyle();
  float delta = _w/data.length;
  beginShape();
  noFill();
  stroke(c);
  for (float i : data) {
    float h = map(i, _l, _u, 0, _h);
    vertex(_x, _y+h);
    _x = _x + delta;
  }
  endShape();
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
