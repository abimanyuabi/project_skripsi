#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/RTDBHelper.h"
#include "addons/TokenHelper.h"
#include<string>

// declaration of wifi connection parameters
String wifiSSID = "Kiran2";
String wifiPassword = "Spectrum";
bool wifiStatus = false;

//declaration of firebase credential and parameters
String firebaseDatabaseEndpoint = "https://controllercoral-default-rtdb.asia-southeast1.firebasedatabase.app/";
String apiKey = "AIzaSyCklfDKO6I3_ZuAzdwgBKZd7lLetzo9tYk";
FirebaseData fbsData;
FirebaseAuth fbsAuth;
FirebaseConfig config;
bool signupStatus = false;
#define USER_EMAIL "timorisu5@gmail.com"
#define USER_PASSWORD "Password123"
String firebaseErrorMsg = "";

//data container and array
  //sensor
bool sensorDataRecordFlag = false;
bool sensorDataFetchFlag = false;
int sensorArrayData[11] = {1, 20, 19, 34, 24, 8, 5, 29, 2, 1025, 10};
int sensorArrayDataFirebase[11] = {1, 15, 19, 34, 24, 8, 5, 29, 2, 1011, 9};
bool sensorRecordDataStatus [11] = {false, false, false, false, false, false, false, false, false, false, false};
bool sensorFetchDataStatus [11] = {false, false, false, false, false, false, false, false, false, false, false};
  //device profile
bool deviceProfileRecordFlag = false;
bool deviceProfileFetchFlag = false;
bool deviceProfileRecordDataStatus [23] = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false};
bool deviceProfileIncomingDataStatus [23] = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false};
int deviceProfileArrayDataTemporary [23] = {3, 20, 19, 35, 45, 5, 11, 15, 6, 20, 98, 75, 1, 200, 200, 255, 255, 1, 20, 30, 15, 1, 3};
int deviceProfileArrayDataIncoming [23] = {3, 15, 19, 35, 45, 5, 11, 15, 6, 20, 98, 75, 1, 255, 255, 255, 255, 1, 20, 30, 15, 1, 3};

//serial comm flag 
bool sendSensorDataToArduinoFlag = false;
bool sendDeviceProfileDataToArduinoFlag = false;

//declaration of program cycle tracking parameters
unsigned long milis;
unsigned long milisTemp;
unsigned long milisTrigg = 1000;
int programCycle = 0;

//declaration of GPIO pins
#define netPilotLamp D0 // for network indicator pilot lamps

void setup() {
  //serial setup 
  Serial.begin(9600);

  //GPIO setup
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(netPilotLamp, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);

  //firebase setup
  fbsAuth.user.email = USER_EMAIL;
  fbsAuth.user.password = USER_PASSWORD;
  config.api_key = apiKey;
  config.database_url = firebaseDatabaseEndpoint;

  //wifi setup try once to connect
  WiFi.begin(wifiSSID, wifiPassword);
  delay(100);

  //check the wifi and try to connect to firebase
  if(WiFi.status()!=WL_CONNECTED){
    //fail to connect to network, proceed on offline mode and retry on program cycle
    //do nothing
  }else{
    //Success connected to wifi
    wifiStatus = true;
    //proceed try to connect firebase
    config.token_status_callback = tokenStatusCallback;
    Firebase.reconnectWiFi(true);
    Firebase.begin(&config, &fbsAuth);
    
    if(Firebase.ready()){
      //signup ok
      signupStatus = true;
    }else{
      firebaseErrorMsg = config.signer.signupError.message.c_str();
    }
    
  }


}

void loop() {
  milis = millis();
  if(milis - milisTemp == milisTrigg){
    deviceProfileFetchFlag = true;
  }

  if(Serial.available()){
    //get transmission code
    //transmission code usage :
    //a for standby
    //b when arduino want to send sensor data
    //c when arduino want to send device profile data
    char transCode = Serial.read();
    if(transCode =='b'){
      getSensorArrayFromArduino();
      sensorDataRecordFlag = true;

    }else if(transCode == 'c'){
      getDeviceProfileArrayFromArduino();
      deviceProfileRecordFlag = true;
    }else{
      Serial.print('x');
    }
  }else{
    if(deviceProfileFetchFlag == true){
      bool isDataFetchGood = true;
      fetchDeviceProfileData();
      //evaluate the data fetching process for any mistake at data transmission
      for(int a = 0; a<23; a++){
        if(deviceProfileIncomingDataStatus[a] == false){
          isDataFetchGood = false;
        }
      }
      //when data is good
      if(isDataFetchGood == true){
        //transCode z for sending sensor data to arduino through serial comm
        pingArduino('z');
        delay(100);
        sendDeviceProfileArrayDataToArduino();
      }
      //when data is not good try to fetch next second
    }else if (sensorDataRecordFlag == true){
      recordSensorData();
    }
  }
}

//--- network utils function ---//
//network reconnect function
void networkReconnect(){
  ledBlink();
  WiFi.begin(wifiSSID, wifiPassword);
  delay(100);
  while(WiFi.status( )!=WL_CONNECTED){
    ledBlink();
  }
  delay(100);
  //connection is good
  wifiStatus = true;
}
bool checkNetwork(){
  return (WiFi.status()!=WL_CONNECTED)?false:true;
}

//--- firebase utils function ---//
//firebase reconnect function
void firebaseReconnect(){
  //trying to reconnect firebase
  ledBlink();
  //double check
  if(checkNetwork() == 0){
    //not connected to network
    wifiStatus = false;
  }else{
    wifiStatus = true;
    //wifi good, try to reconnect to firebase
    config.token_status_callback = tokenStatusCallback;
    Firebase.reconnectWiFi(true);
    Firebase.begin(&config, &fbsAuth);
    
    if(Firebase.ready()){
      //signup ok
      signupStatus = true;
    }else{
      firebaseErrorMsg = config.signer.signupError.message.c_str();
    }
  }
}
//record int data to firebase function
bool recordIntData(String entityPath, int entityValue){
  bool isRecordDataSuccess = false;
  if (signupStatus){
    if(Firebase.ready()){
      //firebase ready, try to saving int data
      if(Firebase.RTDB.setInt(&fbsData, ("Data/"+ entityPath), entityValue)){
        ledBlink();
        //success saving to db
        isRecordDataSuccess = true;
      }else{
        //Failed saving data
        isRecordDataSuccess = false;
      }
    }else{
      //firebase not ready
      isRecordDataSuccess = false;
    }
  }else{
    //not sign up
    isRecordDataSuccess = false;
  }
  return isRecordDataSuccess;
  
}
//get int data from firebase function
int getIntData(String entityPath){
  int tempVal = -1;
  if (signupStatus){
    if(Firebase.ready()){
      //firebase ready, try to get int data
      if(Firebase.RTDB.getInt(&fbsData, ("Data/"+entityPath))){
        ledBlink();
        tempVal = fbsData.to<int>();
        //success get data
      }else{
        //Failed get data
        tempVal = -2;
      }
    }else{
      //firebase not ready
      tempVal = -3;
    }
  }else{
    //not sign up
    tempVal = -4;
  }
  return tempVal;
}
//record sensor data to firebase sequence function
void recordSensorData(){
  //record run once, once the record sequence done the event flag is dispelled
  //Begin record data sequence : sensor
  for(int i=0; i<11; i++){
    sensorRecordDataStatus[i] = recordIntData("sensor/"+ String(i), sensorArrayData[i]);
  }
  sensorDataRecordFlag = false;
}
//get sensor data from firebase sequence function
void fetchSensorData(){
  //fetch run once, once the fetch sequence done the event flag is dispelled
  //Begin fetch data sequence : sensor
  for(int z = 0; z<11; z++){
    int temp = getIntData("sensor/"+String(z));
    if(temp>=0){
      sensorArrayDataFirebase[z] = temp;
      sensorFetchDataStatus[z] = true;
    }else{
      sensorFetchDataStatus[z] = false;
    }
  }
  sensorDataFetchFlag = false;
}
//record device profile data to firebase sequence function
void recordDeviceProfileData(){
  //record run once, once the record sequence done the event flag is dispelled
  //Begin record  data sequence : device profile
  for(int t = 0; t<23; t++){
    deviceProfileRecordDataStatus[t] = recordIntData("device_profile/"+String(t), deviceProfileArrayDataTemporary[t]);
  }
  deviceProfileRecordFlag = false;
}
//get device profile data from firebase sequence function
void fetchDeviceProfileData(){
  //fetch run once, once the fetch sequence done the event flag is dispelled
   //Begin fetch data sequence : device profile
   for(int x = 0; x<23; x++){
    int temp = getIntData("device_profile/"+String(x));
    if(temp>=0){
      deviceProfileArrayDataIncoming[x] = temp;
      deviceProfileIncomingDataStatus[x] = true;
    }else{
      deviceProfileIncomingDataStatus[x] = false;
    }
   }
   deviceProfileFetchFlag = false;
}

//--- serial communication utils ---//
  //ping serial arduino 
void pingArduino(char transCode){
  Serial.println(transCode);
}
  //send sensor array data to arduino function
void sendSensorArrayDataToArduino(){
  for (int i = 0; i < 11; i++) {
    Serial.print(sensorArrayData[i]); // Send the array element
    Serial.print(","); // Send a comma as a separator
  }
  Serial.println();
  sendSensorDataToArduinoFlag  = false;
}
  //send device profile data to arduino function
void sendDeviceProfileArrayDataToArduino(){
  for (int i = 0; i < 23; i++) {
    Serial.print(deviceProfileArrayDataTemporary[i]); // Send the array element
    Serial.print(","); // Send a comma as a separator
  }
  Serial.println();
  sendDeviceProfileDataToArduinoFlag = false;
}
  //get device profile data from arduino 
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
  //get sensor data from arduino
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

//integrated led blink utils function
void ledBlink(){
  digitalWrite(LED_BUILTIN, LOW);
  delay(1);
  digitalWrite(LED_BUILTIN, HIGH); 
}
