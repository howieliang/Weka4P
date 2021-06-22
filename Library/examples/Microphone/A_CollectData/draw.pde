//Global Variables for visualization
int col;
int leftedge;

void showInfo(String s, float x, float y, int fs) { 
  pushStyle();
  textAlign(LEFT,BOTTOM);
  fill(0);
  textSize(fs);
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

float[] appendArrayTail (float[] _array, float _val) {
  float[] array = _array;
  float[] tempArray = new float[_array.length-1];
  arrayCopy(array, 1, tempArray, 0, tempArray.length);
  array[tempArray.length] = _val;
  arrayCopy(tempArray, 0, array, 0, tempArray.length);
  return array;
}


void drawFFTInfo(int x, int y, int fs) {
  pushStyle();
  fill(0);
  textSize(fs);
  float fNormL = map(LOW_THLD, 0, fft.specSize(), 0, sampleRate/2);
  float fNormH = map(HIGH_THLD, 0, fft.specSize(), 0, sampleRate/2);
  float fps = frameRate;
  float overlapping = (fps>0 ? 1-(sampleRate)/(numBins*fps):0);
  text("[N]umber of Bands (in use): "+numBands+" [#"+LOW_THLD+"("+nf(fNormL,0,1)+"Hz)"+" - #"+HIGH_THLD+"("+nf(fNormH,0,1)+"Hz)]", x, y+0*fs);
  text("[S]ample Rate: "+nf(sampleRate, 0, 0)+" Hz", x, y+1*fs);
  text("[B]in Number(total): "+numBins, x, y+2*fs);
  text("[F]rame Rate: "+nf(fps, 0, 2)+" fps", x, y+3*fs);
  text("Overlapping [1-S/BF]]: "+nf((float)overlapping*100, 0, 2)+" %", x, y+4*fs);
  popStyle();
}

void drawSpectrogram() {
  int h = ceil((height-150)/(HIGH_THLD-LOW_THLD));
  // fill in the new column of spectral values  
  for (int i = 0; i < HIGH_THLD-LOW_THLD; i++) {
    //FFTHist[i][col] = Math.round(Math.max(0, 2*20*Math.log10(1000*fft.getBand(i+NUM_DC))));
    FFTHist[i][col] = fft.getBand(i+LOW_THLD);
  }
  // next time will be the next column
  col = col + 1; 
  // wrap back to the first column when we get to the end
  if (col == streamSize) { 
    col = 0;
  }

  // Draw points.  
  // leftedge is the column in the ring-filled array that is drawn at the extreme left
  // start from there, and draw to the end of the array
  for (int i = 0; i < streamSize-leftedge; i++) {
    for (int j = 0; j < HIGH_THLD-LOW_THLD; j++) {
      stroke(255-map(FFTHist[j][i+leftedge], 0, 10, 0, 255));
      //point(i, (height-150)-(j+LOW_THLD));
      float y = (j+LOW_THLD);
      line(i, (height-150)-(y*h), i, (height-150)-(y*h+(h)));
      //line(i*h, height-150-(j+LOW_THLD),i*h+(h-1), height-150-(j+LOW_THLD)); 

    }
  }
  // Draw the rest of the image as the beginning of the array (up to leftedge)
  for (int i = 0; i < leftedge; i++) {
    for (int j = 0; j < HIGH_THLD-LOW_THLD; j++) {
      stroke(255-map(FFTHist[j][i], 0, 10, 0, 255));
      float y = (j+LOW_THLD);
      line(i+streamSize-leftedge, (height-150)-(y*h), i+streamSize-leftedge, (height-150)-(y*h+(h)));
      //point(i+dataNum-leftedge, height-150-(j+LOW_THLD));
    }
  }

  // Next time around, we move the left edge over by one, to have the whole thing
  // scroll left
  leftedge = leftedge + 1; 
  // Make sure it wraps around
  if (leftedge == streamSize) { 
    leftedge = 0;
  }

  // Add frequency axis labels
  int x = streamSize + 2; // to right of spectrogram display
  stroke(0);
  line(x, 0, x, height-150); // vertical line
  fill(0);
  // Make text appear centered relative to specified x,y point 
  textAlign(LEFT, CENTER);
  for (float freq = 100.0; freq < in.sampleRate()/2; freq += 100.0) {
    float fNorm = map(fft.freqToIndex(freq), LOW_THLD, HIGH_THLD, 0, numBands);
    float y = (height-150) - fNorm*h; // which bin holds this frequency?
    line(x, y, x+3, y); // add tick 
    text(Math.round(freq)+" Hz", x+5, y); // add text label
  }
  line(0, height-150, width, height-150); // vertical line
}
