const int arraySize = 5; // Size of the array
int receivedArray[arraySize]; // To store received array data
int sensorArrayData[11] = {1, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10};
int deviceProfileArrayDataTemporary [23] = {3, 10, 19, 35, 45, 5, 11, 15, 6, 20, 98, 75, 1, 10, 10, 10, 10, 1, 20, 30, 15, 1, 3};

bool recordSensorFlag = false;
bool recordDeviceProfileFlag = false;
bool sendSensorDataFlag = true;
bool sendDeviceProfileDataFlag = true;

unsigned long milis;
unsigned long milisTemp;
unsigned long milisTrigg = 1000;

void setup() {
  Serial.begin(9600); // Initialize Serial communication
}

void loop() {
  milis = millis();
  if(milis - milisTemp == milisTrigg){
    sendSensorDataFlag = true;
    sendDeviceProfileDataFlag = true;
  }

  if (Serial.available()) {
    //get transmission code
    //transmission code usage :
    //a for standby
    //b when arduino want to send sensor data
    //c when arduino want to send device profile data
    char transCode = Serial.read();
    if(transCode =='b'){
      getSensorArrayFromArduino();
      recordSensorFlag = true;
    }else if(transCode == 'c'){
      getDeviceProfileArrayFromArduino();
      recordSensorFlag = true;
    }else{
      Serial.print(transCode);
    }
    //getSensorArrayFromArduino();
    //getDeviceSensorArrayFromArduino();
  }else{
    if(sendSensorDataFlag == true){
      pingArduino('y');
      delay(100);
      sendSensorArrayDataToArduino();
    }else if(sendDeviceProfileDataFlag == true){
      pingArduino('z');
      delay(100);
      sendDeviceProfileArrayDataToArduino();
    }
  }
}
void pingArduino(char transCode){
  Serial.println(transCode);
}
void sendSensorArrayDataToArduino(){
  for (int i = 0; i < 11; i++) {
    Serial.print(sensorArrayData[i]); // Send the array element
    Serial.print(","); // Send a comma as a separator
  }
  Serial.println();
  sendSensorDataFlag = false;
}
void sendDeviceProfileArrayDataToArduino(){
  for (int i = 0; i < 23; i++) {
    Serial.print(deviceProfileArrayDataTemporary[i]); // Send the array element
    Serial.print(","); // Send a comma as a separator
  }
  Serial.println();
  sendDeviceProfileDataFlag = false;
}
void getDeviceProfileArrayFromArduino(){
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
void getSensorArrayFromArduino(){
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