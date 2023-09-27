#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/RTDBHelper.h"
#include "addons/TokenHelper.h"
#include<string>

String firebaseDatabaseEndpoint = "https://controllercoral-default-rtdb.asia-southeast1.firebasedatabase.app/";
String apiKey = "AIzaSyCklfDKO6I3_ZuAzdwgBKZd7lLetzo9tYk";
String wifiSSID = "Kiran2";
String wifiPassword = "Spectrum";
bool wifiStatus = false;
unsigned long dataMillis = 0;

FirebaseData fbsData;
FirebaseAuth fbsAuth;
FirebaseConfig config;
bool signupStatus = false;
#define USER_EMAIL "timorisu5@gmail.com"
#define USER_PASSWORD "Password123"
String firebaseErrorMsg = "";

bool sensorDataRecordFlag = true;
bool sensorDataFetchFlag = true;
int sensorArrayData[11] = {1, 20, 19, 34, 24, 8, 5, 29, 2, 1025, 10};
int sensorArrayDataFirebase[11] = {1, 15, 19, 34, 24, 8, 5, 29, 2, 1011, 9};
bool sensorRecordDataStatus [11] = {false, false, false, false, false, false, false, false, false, false, false};
bool sensorFetchDataStatus [11] = {false, false, false, false, false, false, false, false, false, false, false};

bool deviceProfileRecordFlag = true;
bool deviceProfileFetchFlag = true;
bool deviceProfileRecordDataStatus [23] = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false};
bool deviceProfileIncomingDataStatus [23] = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false};
int deviceProfileArrayDataTemporary [23] = {3, 20, 19, 35, 45, 5, 11, 15, 6, 20, 98, 75, 1, 200, 200, 255, 255, 1, 20, 30, 15, 1, 3};
int deviceProfileArrayDataIncoming [23] = {3, 15, 19, 35, 45, 5, 11, 15, 6, 20, 98, 75, 1, 255, 255, 255, 255, 1, 20, 30, 15, 1, 3};

#define netPilotLamp D0

void setup() {
  // put your setup code here, to run once:
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(netPilotLamp, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);

  fbsAuth.user.email = USER_EMAIL;
  fbsAuth.user.password = USER_PASSWORD;
  config.api_key = apiKey;
  config.database_url = firebaseDatabaseEndpoint;

  Serial.begin(9600);

  WiFi.begin(wifiSSID, wifiPassword);
  delay(100);

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
void loop() {
  if(wifiStatus == false){
    digitalWrite(netPilotLamp, LOW);
    //network off, running on offline mode and try to reconnect
    networkReconnect();
  }else if(wifiStatus == true && signupStatus == false){
    firebaseReconnect();
  }else{
    digitalWrite(netPilotLamp, HIGH);
    if(deviceProfileFetchFlag == true){
      fetchDeviceProfileData();
    }else if(deviceProfileRecordFlag == true){
      recordDeviceProfileData();
    }else if(sensorDataRecordFlag == true){
      recordSensorData();
    }else if(sensorDataFetchFlag == true){
      fetchSensorData();
    }
    
  }
}
void ledBlink(){
  digitalWrite(LED_BUILTIN, LOW);
  delay(1);
  digitalWrite(LED_BUILTIN, HIGH); 
}
void recordDeviceProfileData(){
  //record run once, once the record sequence done the event flag is dispelled
  //Begin record  data sequence : device profile
  for(int t = 0; t<23; t++){
    deviceProfileRecordDataStatus[t] = recordIntData("device_profile/"+String(t), deviceProfileArrayDataTemporary[t]);
  }
  deviceProfileRecordFlag = false;
}
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
void recordSensorData(){
  //record run once, once the record sequence done the event flag is dispelled
  //Begin record data sequence : sensor
  for(int i=0; i<11; i++){
    sensorRecordDataStatus[i] = recordIntData("sensor/"+ String(i), sensorArrayData[i]);
  }
  sensorDataRecordFlag = false;
}
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
