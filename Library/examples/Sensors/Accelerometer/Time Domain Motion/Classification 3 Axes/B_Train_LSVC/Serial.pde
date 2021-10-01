
float diff = 0;
void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');  // read the serial string until seeing a carriage return
  if (inData.charAt(0) == 'A') {
    rawData[0] = int(trim(inData.substring(1)));
    appendArray( (sensorHist[0]), map(rawData[0], 0, 1023, 0, height)); //store the data to history (for visualization)
    //calculating diff
    diff = max(abs( (sensorHist[0])[0] - (sensorHist[0])[1]), diff); //absolute diff
    appendArray(diffArray[0], diff);
    appendArray(thldArray[0], activationThld);
  }
  if (inData.charAt(0) == 'B') {
    rawData[1] = int(trim(inData.substring(1)));
    appendArray( (sensorHist[1]), map(rawData[1], 0, 1023, 0, height)); //store the data to history (for visualization)
    //calculating diff
    diff = max(abs( (sensorHist[1])[0] - (sensorHist[1])[1]), diff); //absolute diff
    appendArray(diffArray[1], diff);
    appendArray(thldArray[1], activationThld);
  }
  if (inData.charAt(0) == 'C') {
    rawData[2] = int(trim(inData.substring(1)));
    appendArray( (sensorHist[2]), map(rawData[2], 0, 1023, 0, height)); //store the data to history (for visualization)
    //calculating diff
    diff = max(abs( (sensorHist[2])[0] - (sensorHist[2])[1]), diff); //absolute diff
    appendArray(diffArray[2], diff);
    appendArray(thldArray[2], activationThld);

    //test activation threshold
    if (diff>activationThld) { 
      appendArray(modeArray, 2); //activate when the absolute diff is beyond the activationThld
      if (b_sampling == false) { //if not sampling
        b_sampling = true; //do sampling
        sampleCnt = 0; //reset the counter
        for (int i = 0; i < sensorNum; i++) {
          for (int j = 0; j < windowSize; j++) {
            (windowArray[i])[j] = 0; //reset the window
          }
        }
      }
    } else { 
      if (b_sampling == true) appendArray(modeArray, 3); //otherwise, deactivate.
      else appendArray(modeArray, -1); //otherwise, deactivate.
    }
    diff = 0;
    if (b_sampling == true) {
      for ( int c = 0; c < sensorNum; c++) {
        appendArray(windowArray[c], rawData[c]); //store the windowed data to history (for visualization)
      }
      ++sampleCnt;
      if (sampleCnt == windowSize) {
        m_x = Descriptive.mean(windowArray[0]); //mean
        sd_x = Descriptive.std(windowArray[0], true); //standard deviation
        m_y = Descriptive.mean(windowArray[1]); //mean
        sd_y = Descriptive.std(windowArray[1], true); //standard deviation
        m_z = Descriptive.mean(windowArray[2]); //mean
        sd_z = Descriptive.std(windowArray[2], true); //standard deviation
        b_sampling = false; //stop sampling if the counter is equal to the window size
      }
    }
  }
  return;
}

//Append a value to a float[] array.
float[] appendArray (float[] _array, float _val) {
  float[] array = _array;
  float[] tempArray = new float[_array.length-1];
  arrayCopy(array, tempArray, tempArray.length);
  array[0] = _val;
  arrayCopy(tempArray, 0, array, 1, tempArray.length);
  return array;
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
