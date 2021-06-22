/* Event that is triggered on every incoming Serial packet */
void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');                      // read the serial string until seeing a carriage return (newline character)
  if (dataIndex<dataNum) {
    if (inData.charAt(0) == 'A') {                                 // X
      rawData[0][dataIndex] = int(trim(inData.substring(1)));
    }
    if (inData.charAt(0) == 'B') {                                 // Y
      rawData[1][dataIndex] = int(trim(inData.substring(1)));
    }
    if (inData.charAt(0) == 'C') {                                 // Z
      rawData[2][dataIndex] = int(trim(inData.substring(1)));
      ++dataIndex;
    }
  }
  return;
}
