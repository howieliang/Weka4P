
int sensorNum = 10; //number of sensors in use
int dataNum = 500; //number of data to show
float[] rawData = new float[sensorNum];
float[][] sensorHist = new float[sensorNum][dataNum]; //history data to show
float[] modeArray = new float[dataNum]; //classification to show

//Save
Table csvData;
boolean b_saveCSV = false;
String dataSetName = "FingerTrain"; 
String[] attrNames;
boolean[] attrIsNominal;
int labelIndex = 0;

boolean b_sampling = false; //flag to keep data collection non-preemptive
int sampleCnt = 0; //counter of samples

void setDataType() {
  attrNames =  new String[sensorNum+1];
  attrIsNominal = new boolean[sensorNum+1];
  for (int j = 0; j < sensorNum; j++) {
    attrNames[j] = "d_"+j;
    attrIsNominal[j] = false;
  }
  attrNames[sensorNum] = "label";
  attrIsNominal[sensorNum] = true;
}

void setup() {
  size(640, 480, P3D);
  background(255);
  leap = new LeapMotion(this);
  imageMode(CENTER);
  setDataType();
  initCSV();
}

void draw() {
  background(255);
  if (leap.hasImages()) {
    for (Image camera : leap.getImages()) {
      if (camera.isLeft()) { // Left camera
        pushMatrix();
        translate(0, -height/4);
        scale(-1, 1);
        translate(-width/2, height/2);
        image(camera, 0, 0);
        popMatrix();
      }
    }
  }
  
  if (mousePressed && (frameCount%6==0)) b_sampling = true;
  else b_sampling = false;
  
  for (Hand hand : leap.getHands ()) {
    for (Finger finger : hand.getFingers()) {
      finger.draw();  // Executes drawBones() and drawJoints()
    }
  }
  
  if (b_sampling == true) {
    if(checkFingers()) appendArrayTail(modeArray, labelIndex); //the class is null without mouse pressed.
    else appendArrayTail(modeArray, -1); //the class is null without mouse pressed.
    b_sampling = false;
  } else {
    appendArrayTail(modeArray, -1); //the class is null without mouse pressed.
  }
  barGraph(modeArray, 0, height, 0, height-50, width, 50);
  showInfo("Current Label: "+getCharFromInteger(labelIndex), 320+20, 260, 16);
  showInfo("Num of Data: "+csvData.getRowCount(), 320+20, 280, 16);
  showInfo("[X]:del/[C]:clear", 320+20, 300, 16);
  showInfo("[S]:save/[/]:label+", 320+20, 320, 16);
  checkDevice();
  text("FPS: "+leap.getFrameRate(), 20, 20);
  if (b_saveCSV) {
    saveCSV(dataSetName, csvData);
    saveARFF(dataSetName, csvData);
    b_saveCSV = false;
  }
}

float[] appendArrayTail (float[] _array, float _val) {
  float[] array = _array;
  float[] tempArray = new float[_array.length-1];
  arrayCopy(array, 1, tempArray, 0, tempArray.length);
  array[tempArray.length] = _val;
  arrayCopy(tempArray, 0, array, 0, tempArray.length);
  return array;
}
