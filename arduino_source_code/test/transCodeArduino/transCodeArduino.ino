const int arraySize = 5; // Size of the array
int myArray[arraySize] = {10, 20, 30, 40, 50}; // Sample array data
int sensorArrayData[11] = {1, 20, 19, 34, 24, 8, 5, 29, 2, 1025, 10};
int deviceProfileArrayDataTemporary [23] = {3, 20, 19, 35, 45, 5, 11, 15, 6, 20, 98, 75, 1, 200, 200, 255, 255, 1, 20, 30, 15, 1, 3};
unsigned long milis;
unsigned long milisTemp;
unsigned long milisTrigg = 1000;

bool sendSensorDataFlag = true;
bool sendDeviceProfileDataFlag = true;
bool evaluateSensorData = false;
bool evaluateDeviceProfileData = false;

void setup() {
  Serial.begin(9600); // Initialize Serial communication
}

void loop() {
  // Send the array data
   // Add a newline character at the end
  milis = millis();
  if (milis - milisTemp == milisTrigg){
    sendSensorDataFlag = true;
    sendDeviceProfileDataFlag = true;
    evaluateSensorData = false;
    evaluateDeviceProfileData = false;

  }
  
    if(Serial.available()){
      char transCode = Serial.read();
      if(transCode =='y'){
        getSensorArrayFromEsp();
        evaluateSensorData = true;
      }else if(transCode == 'z'){
        getDeviceProfileArrayFromEsp();
        evaluateDeviceProfileData = true;
      }else{
        //do nothing
      }
    }else{
      if(sendSensorDataFlag == true){
        pingEsp('b');
        //delay(100);
        sendSensorDataToEsp();
        sendSensorDataFlag = false;
      }else if(sendDeviceProfileDataFlag == true){
        pingEsp('c');
        //delay(100);
        sendDeviceProfileDataToEsp();
        sendDeviceProfileDataFlag = false;
      }else{
        //pingEsp('a');
      }
    }
    //sendDeviceProfileDataToEsp();
    //sendSensorData();
    milisTemp = milis;
}
void pingEsp(char transCode){
  Serial.println(transCode);
}
void sendDeviceProfileDataToEsp(){
  for (int i = 0; i < 23; i++) {
    Serial.print(deviceProfileArrayDataTemporary[i]); // Send the array element
    Serial.print(","); // Send a comma as a separator
  }
  Serial.println();
}
void sendSensorDataToEsp(){
  for (int i = 0; i < 11; i++) {
    Serial.print(sensorArrayData[i]); // Send the array element
    Serial.print(","); // Send a comma as a separator
  }
  Serial.println();
}
void getDeviceProfileArrayFromEsp(){
  // Read the incoming data and populate the array
    for (int i = 0; i < 23; i++) {
      deviceProfileArrayDataTemporary[i] = Serial.parseInt(); // Read and convert to integer
      Serial.read(); // Read the comma separator
    }

    // Process the received array data
    Serial.println("Received value at index ");
    for (int i = 0; i < 23; i++) {
      Serial.print(i);
      Serial.print(": ");
      Serial.print(deviceProfileArrayDataTemporary[i]);
      Serial.println("|");
    }
}
void getSensorArrayFromEsp(){
  // Read the incoming data and populate the array
    for (int i = 0; i < 11; i++) {
      sensorArrayData[i] = Serial.parseInt(); // Read and convert to integer
      Serial.read(); // Read the comma separator
    }

    // Process the received array data
    Serial.println("Received value at index ");
    for (int i = 0; i < 11; i++) {
      Serial.print(i);
      Serial.print(": ");
      Serial.print(sensorArrayData[i]);
      Serial.println("|");
    }
}