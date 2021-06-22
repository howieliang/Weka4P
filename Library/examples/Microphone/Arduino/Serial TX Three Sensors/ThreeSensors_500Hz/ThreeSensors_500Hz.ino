#define PIN_NUM 3
int  data[PIN_NUM]; //data array
char dataID[PIN_NUM] = {'A','B','C'}; //data label
int  pinID[PIN_NUM]  = {A0, A1, A2}; //corresponding pins
int  sampleRate = 500; //samples per second

long timer = micros(); //timer

void setup() {
  Serial.begin(115200); //serial
}

void loop() {
  if (micros() - timer >= 1000000/sampleRate) { //Timer: send sensor data in every 10ms
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