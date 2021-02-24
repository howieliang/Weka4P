//*********************************************
// Time-Series Signal Processing
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

#define PIN_NUM 3
int sampleRate = 100; //samples per second
int sampleInterval = 1000000/sampleRate; //Inverse of SampleRate
int  data[PIN_NUM]; //data array
char dataID[PIN_NUM] = {'A','B','C'}; //data label
int  pinID[PIN_NUM]  = {A0, A1, A2}; //corresponding pins

long timer = micros(); //timer

void setup() {
  Serial.begin(115200); //serial
}

void loop() {
  if (micros() - timer >= sampleInterval) { //Timer: send sensor data in every 10ms
    timer = micros();
    for (int i = 0 ; i < PIN_NUM ; i++) {
      data[i] = analogRead(pinID[i]); //get the analog reading
      sendDataToProcessing(dataID[i], data[i]);
    }
  }
}

void sendDataToProcessing(char symbol, int data) {
  Serial.print(symbol);  // symbol prefix of data type
  Serial.println(data);  // the integer data with a carriage return
}
