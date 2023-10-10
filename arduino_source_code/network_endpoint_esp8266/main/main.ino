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
bool deviceProfileIncomingDataStatus [23] = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false};
int deviceProfileArrayData [23] = {3, 15, 19, 35, 45, 5, 11, 15, 6, 20, 98, 75, 1, 255, 255, 255, 255, 1, 20, 30, 15, 1, 3};

//serial comm flag 
bool sendSensorDataToArduinoFlag = false;
bool sendDeviceProfileDataToArduinoFlag = false;

//declaration of program cycle tracking parameters
unsigned long millisTemp = 0;
unsigned long millisTrigg = 1000;
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
  int currMillis = millis();
  if(checkNetwork() == false){
    networkReconnect();
    if(wifiStatus == true){
      firebaseReconnect();
    }
  }
  if(currMillis - millisTemp == millisTrigg){
    if(pingFirebase() == true){
      fetchDeviceProfileData();
      if(isIncomingDataValid() == true){
        pingArduino('z');
        sendDeviceProfileArrayDataToArduino();

      }
    }
  }
  if(Serial.available()){
    char transCode = Serial.read();
    //ping
      if(transCode = 'a'){
        if(signupStatus == true){
          Serial.println('n');
        }else if(wifiStatus == false){
          Serial.println('w');
        }else if(signupStatus == false){
          Serial.println('f');
        }
      }

    //sensor record
      else if(transCode == 'b'){
        getSensorArrayFromArduino();
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
//ping firebase
  bool pingFirebase(){
    int newData = getIntData("isNewdataProfile");
    if(newData == 0){
      return false;
    }else{
      return true;
    }
  }
//record int data to firebase function
  bool recordIntData(String entityPath, int entityValue){
    bool isRecordDataSuccess = false;
    if (signupStatus){
      Serial.println("signup ok");
      if(Firebase.ready()){
        Serial.println("firebase ok");
        //firebase ready, try to saving int data
        if(Firebase.RTDB.setInt(&fbsData, ("Data/"+ entityPath), entityValue)){
          ledBlink();
          Serial.println("ok");
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
    Serial.println("begin record");
    for(int i=0; i<8; i++){
      sensorRecordDataStatus[i] = recordIntData("sensor/"+ String(i), i+1);
    }
    sensorDataRecordFlag = false;
  }
//get device profile data from firebase sequence function
  void fetchDeviceProfileData(){
    //fetch run once, once the fetch sequence done the event flag is dispelled
    //Begin fetch data sequence : device profile
    for(int x = 0; x<18; x++){
      int temp = getIntData("device_profile/"+String(x));
      if(temp>=0){
        deviceProfileArrayData[x] = temp;
        deviceProfileIncomingDataStatus[x] = true;
      }else{
        deviceProfileIncomingDataStatus[x] = false;
      }
    }
    deviceProfileFetchFlag = false;
  }
//validator
  bool isIncomingDataValid(){
    bool stat = true;
    for(int y = 0; y<18; y++){
      if(deviceProfileIncomingDataStatus[y] == false){
        stat = false;
      }
    }
    return stat;
  }

//--- serial communication utils ---//
//ping serial arduino 
  void pingArduino(char transCode){
    Serial.println(transCode);
  }
//send device profile data to arduino function
  void sendDeviceProfileArrayDataToArduino(){
    for (int i = 0; i < 18; i++) {
      Serial.print(deviceProfileArrayData[i]); // Send the array element
      Serial.print(","); // Send a comma as a separator
    }
      Serial.println();
  }
//get sensor data from arduino
  void getSensorArrayFromArduino(){
    // Read the incoming data and populate the array
      for (int i = 0; i < 8; i++) {
        recordIntData("sensor/"+ String(i), Serial.parseInt());
        Serial.read(); // Read the comma separator
      }
  }

//integrated led blink utils function
void ledBlink(){
  digitalWrite(LED_BUILTIN, LOW);
  delay(10);
  digitalWrite(LED_BUILTIN, HIGH); 
}
