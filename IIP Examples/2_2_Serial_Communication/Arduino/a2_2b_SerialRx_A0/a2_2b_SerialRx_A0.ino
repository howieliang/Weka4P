//*********************************************
// Time-Series Signal Processing
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

int sampleRate = 100;                         //samples per second
int sampleInterval = 1000000/sampleRate;      //Inverse of SampleRate
int data = 0;
long timer = micros();                        //timer

void setup() {
  Serial.begin(115200);                       //serial
}

void loop() {
  if (micros() - timer >= sampleInterval) {   //Timer: send sensor data in every 10ms
    timer = micros();
    data = analogRead(A0);                    //get the analog reading
    sendDataToProcessing('A', data);          //Put the data into buffer to sent it out later.
  }
}

void sendDataToProcessing(char symbol, int data) {
  Serial.print(symbol);                       // symbol prefix of data type
  Serial.println(data);                       // the integer data with a carriage return
}
