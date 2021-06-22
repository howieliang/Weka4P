
float[] appendArrayTail (float[] _array, float _val) {
  float[] array = _array;
  float[] tempArray = new float[_array.length-1];
  arrayCopy(array, 1, tempArray, 0, tempArray.length);
  array[tempArray.length] = _val;
  arrayCopy(tempArray, 0, array, 0, tempArray.length);
  return array;
}

void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');  // read the serial string until seeing a carriage return
  //assign data index based on the header
  if (inData.charAt(0) == 'A') {  
    rawData[0] = int(trim(inData.substring(1))); //store the value
    appendArrayTail(sensorHist[0], rawData[0]); //store the data to history (for visualization)
    float diff = abs(sensorHist[0][sensorHist[0].length-1] - sensorHist[0][sensorHist[0].length-2]); //normal diff
    appendArrayTail(diffArray[0], diff);
    return;
  }
  if (inData.charAt(0) == 'B') {  
    rawData[1] = int(trim(inData.substring(1))); //store the value
    appendArrayTail(sensorHist[1], rawData[1]); //store the data to history (for visualization)
    float diff = abs(sensorHist[1][sensorHist[1].length-1] - sensorHist[1][sensorHist[1].length-2]); //normal diff
    appendArrayTail(diffArray[1], diff);
    return;
  }
  if (inData.charAt(0) == 'C') {  
    rawData[2] = int(trim(inData.substring(1))); //store the value
    appendArrayTail(sensorHist[2], rawData[2]); //store the data to history (for visualization)
    float diff = abs(sensorHist[2][sensorHist[2].length-1] - sensorHist[2][sensorHist[2].length-2]); //normal diff
    appendArrayTail(diffArray[2], diff);
    return;
  }
}

void initSerial() {
  //Initiate the serial port
  for (int i = 0; i < Serial.list().length; i++) println("[", i, "]:", Serial.list()[i]);
  String portName = Serial.list()[Serial.list().length-1];//MAC: check the printed list
  //String portName = Serial.list()[9];//WINDOWS: check the printed list
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n'); // arduino ends each data packet with a carriage return 
  port.clear();           // flush the Serial buffer
}