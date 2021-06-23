import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;

Minim minim;

class ezFFT {
  FFT fft;
  int fftSize;
  float[] fftSamples;
  int[] spectrum;
  int[][] sgram;

  int col;
  int leftedge;
  int window_len;
  int colmax = 500;
  int rowmax = 500;

  ezFFT(int _fftSize, float sampleRate) {
    fftSize = _fftSize;
    fft = new FFT( fftSize, sampleRate );
    fft.window(FFT.NONE);
    fftSamples = new float[fftSize];
    spectrum = new int[fft.specSize()];
    sgram = new int[fft.specSize()][fft.specSize()];
    colmax = fft.specSize() ;
    rowmax = fft.specSize() ;
    window_len = fftSize;
  }

  int getSpecSize() {
    return fft.specSize();
  }

  int getBand(int i) { 
    return (int)fft.getBand(i);
  }

  void updateFFT(float[] array) {
    System.arraycopy( array, // source of the copy
      array.length-1-fftSize, // index to start in the source
      fftSamples, // destination of the copy
      0, // index to copy to
      fftSize // how many samples to copy
      );

    // apply Hanning (raised cosine) windowing
    for (int i = 0; i < fftSamples.length/2; ++i) {
      float winval = (float)(0.5+0.5*Math.cos(Math.PI*(float)i/(float)(fftSize/2)));
      if (i > fftSize/2)  winval = 0;
      fftSamples[fftSamples.length/2 + i] *= winval;
      fftSamples[fftSamples.length/2 - i] *= winval;
    }

    fftSamples[0] = 0;
    fft.forward( fftSamples );
    for (int i = 0; i < fft.specSize(); i++)
    {
      spectrum[i] = (int)fft.getBand(i);
    }
  }
  
  void updateSpectrum(int[] array) {
    for (int i = 0; i < fft.specSize(); i++)
    {
      spectrum[i] = array[i];
    }
  }
  
  void updateSpectrum(float[] array) {
    for (int i = 0; i < fft.specSize(); i++)
    {
      spectrum[i] = (int) array[i];
    }
  }

  void drawFFT(float scale) {
    pushStyle();
    noStroke();
    fill(0,100);
    //stroke(0);
    for (int i = 0; i < fft.specSize(); i++)
    {
      float y = ((fft.specSize()-1)-(i-1))*(int)scale + (int)scale/2;
      //line( 0, y, min(fft.getBand(i)*0.02, 100), y);
      rect( 0, y, min(fft.getBand(i)*0.02, 100), scale);
      
    }
    popStyle();
  }

  void drawSpectrogram(float scale, float upperBound) {
    drawSpectrogram(scale, upperBound, true);
  }
  void drawSpectrogram(float scale, float upperBound, boolean bShowFFT) {
    //int h = ceil((height-150)/(HIGH_THLD-LOW_THLD));
    for (int i = 0; i < rowmax; i++) {
      sgram[i][col] = spectrum[i];
    }
    col = col + 1; 
    if (col == colmax) { 
      col = 0;
    }
    pushMatrix();
    pushStyle();
    rectMode(CORNER);
    stroke(0);
    fill(255);
    rect(0, 0, (colmax+1)*scale, (rowmax+2)*scale);
    noStroke();

    for (int i = 1; i < colmax-leftedge; i++) {
      for (int j = 0; j < rowmax; j++) {
        //stroke(255-map(FFTHist[j][i+leftedge], 0, 10, 0, 255));
      
        fill(max(255-map(sgram[j][i+leftedge], upperBound/3., 0, 255, 0), 0));
        rect(i*scale, (rowmax-j)*scale, scale, scale);
      }
    }

    // Draw the rest of the image as the beginning of the array (up to leftedge)
    for (int i = 0; i < leftedge; i++) {
      for (int j = 0; j < rowmax; j++) {
        fill(max(255-map(sgram[j][i], upperBound/3., 0, 255, 0), 0));
        rect((i+colmax-leftedge)*scale, (rowmax-j)*scale, scale, scale);
      }
    }

    int x = 1*(int)scale + (int)scale/2; // to right of spectrogram display
    stroke(100);
    fill(100);
    textSize(12);
    line(x, 0, x, rowmax*(int)scale); // vertical line
    textAlign(LEFT, CENTER);
    for (float freq = 0.0; freq <= 250; freq += 50.0) {
      int y = (rowmax - fft.freqToIndex(freq))*(int)scale + (int)scale/2; // which bin holds this frequency?
      line(x, y, x+3, y); // add tick mark
      text(Math.round(freq)+" Hz", x+5, y); // add text label
    }

    if (bShowFFT) {
      translate((colmax+1)*(int)scale, 0);
      drawFFT(scale);
    }

    leftedge = leftedge + 1; // Next time around, we move the left edge over by one, to have the whole thing scroll left
    if (leftedge == colmax) {// Make sure it wraps around 
      leftedge = 0;
    }

    popStyle();
    popMatrix();
  }
  
  float[] getSpectrum(){
    float[] fSpec = new float[spectrum.length];
    for (int i=0 ; i < spectrum.length ; i++){
      fSpec[i] = (int) spectrum[i]; 
    }
    return fSpec;
  }
};
