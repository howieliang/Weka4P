/* Event that is triggered on every incoming Serial packet */
void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');                   // Read the serial string until seeing a carriage return
  if (!dataUpdated) 
  {
    if (inData.charAt(0) == 'A') {                              // X
      rawData[0] = int(trim(inData.substring(1)));
    }
    if (inData.charAt(0) == 'B') {                              // Y
      rawData[1] = int(trim(inData.substring(1)));
    }
    if (inData.charAt(0) == 'C') {                              // Z
      rawData[2] = int(trim(inData.substring(1)));
      dataUpdated = true;
    }
  }
  return;
}
