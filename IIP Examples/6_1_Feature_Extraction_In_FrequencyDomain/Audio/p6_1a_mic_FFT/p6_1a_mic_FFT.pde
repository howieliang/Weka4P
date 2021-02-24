//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
FFT fft;

int streamSize = 500;
float sampleRate = 44100/5;
int numBins = 1025;
int bufferSize = (numBins-1)*2;
//FFT parameters
float[][] FFTHist;
final int LOW_THLD = 1; //low threshold of band-pass frequencies
final int HIGH_THLD = 200; //high threshold of band-pass frequencies 
int numBands = HIGH_THLD-LOW_THLD+1; //number of feature
float[] modeArray = new float[streamSize]; //classification to show

void setup()
{
  size(700, 700, P2D);
  // setup audio input
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.window(FFT.NONE);
  FFTHist = new float[numBands][streamSize]; //history data to show
  for (int i = 0; i < modeArray.length; i++) { //Initialize all modes as null
    modeArray[i] = -1;
  }
}

void draw()
{
  background(255);
  fft.forward(in.mix.toArray());
  drawSpectrogram();
  drawFFTInfo(20, height-100, 18);
}

void stop()
{
  // always close Minim audio classes when you finish with them
  in.close();
  minim.stop();
  super.stop();
}
