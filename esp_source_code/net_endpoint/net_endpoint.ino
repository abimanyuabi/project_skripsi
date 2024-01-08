#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/RTDBHelper.h"
#include "addons/TokenHelper.h"
#include <string>

// declaration of communication flag
bool isHalted = false;
char transCode = '-';

// declaration of net endpoint timings
const unsigned long timingTriggers = 1000;
unsigned long timingTimeStamp = 0;
unsigned long timingCurrMillis = 0;

// declaration of wifi connection parameters
const String wifiSSID = "Kiran2";
const String wifiPassword = "Spectrum";
bool wifiStatus = false;

//declaration of firebase credential and parameters
const String firebaseDatabaseEndpoint = "https://controllercoral-default-rtdb.asia-southeast1.firebasedatabase.app/";
const String apiKey = "AIzaSyCklfDKO6I3_ZuAzdwgBKZd7lLetzo9tYk";
const String userId = "asdowZLkuRgia6K2FF0tyHEjuxv1";
const String baseDataPath = "aquariums_data_prod";
const String deviceProfileDataFlagPath = "/is_new_data/device_profile";
const String deviceDebugDataFlagPath = "/is_new_data/debug";
const String sensorDataFlagPath = "/is_new_data/sensor_data";
const String sensorDataPath= "/water_parameters/sensor_readings";
int errorCount = 0;
String errorMsg = "-";
FirebaseData fbsData;
FirebaseAuth fbsAuth;
FirebaseConfig config;
bool signupStatus = false;
#define USER_EMAIL "timorisu5@gmail.com"
#define USER_PASSWORD "Password123"
String firebaseErrorMsg = "";
#define netPilotLamp D0

void setup() {
  // put your setup code here, to run once:
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
  //check the wifi and try to connect to firebase
  if(WiFi.status()!=WL_CONNECTED){
    //fail to connect to network, proceed on offline mode and retry on program cycle
    wifiStatus = false;
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
  // executed once a second has elapsed
  timingCurrMillis = millis();
  if(timingCurrMillis - timingTimeStamp >=timingTriggers){
    timingTimeStamp = timingCurrMillis;
    if(pingFirebase() == true ){
        if(isHalted == false){
          fetchNewDeviceData();
        }
      }
    if(pingFirebaseDebug()==true ){
      if(isHalted == false){
        fetchDebugDataFromFirebase();
      }
    }
    if(checkNetwork() == false){
      pingArduino('g' );
    }if(signupStatus == false && wifiStatus == true ){
      pingArduino('h');
    }if(signupStatus == true){
      pingArduino('i');
    }
  }
  
  // executed every loop
  if(Serial.available()){
    transCode = '-';
    transCode = Serial.read();
    if(transCode == 'a'){
      //get the wifi auth data from arduino
    }else if(transCode == 'm' ){
      if(signupStatus == true){
        getSensorArrayFromArduino();
      }if(checkNetwork() == false){
        pingArduino('g');
      }if(signupStatus == false && wifiStatus == true ){
        pingArduino('h');
      }
      
    }
    else{
      transCode = '-';
    }
  }
  if(wifiStatus == false){
    networkReconnect();
  }else if(wifiStatus == true && signupStatus == false){
    firebaseReconnect();
  }
  
}

void networkReconnect(){
  ledBlink();
  WiFi.begin(wifiSSID, wifiPassword);
  delay(100);
  while(WiFi.status()!=WL_CONNECTED){
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
      pingArduino('i');
    }else{
      firebaseErrorMsg = config.signer.signupError.message.c_str();
    }
  }
}
void fetchNewDeviceData(){
  int arrBuffer [18];
  bool isDataValid = true;
  for(int x = 1; x<=18;x++){
    int retrievedValue = -1;
    if(x>0 && x<=12){
      retrievedValue= getIntData(baseDataPath+"/"+userId+"/led_profile/"+String(x));
      if(retrievedValue > -1){
        arrBuffer[x-1] = retrievedValue;
      }else{
      //received data is not valid
      isDataValid = false;
      }
    }else if(x>12 && x<=16){
      retrievedValue= getIntData(baseDataPath+"/"+userId+"/dosing_profile/"+String(x));
      if(retrievedValue>-1){
        arrBuffer[x-1] = retrievedValue;
      }else{
      //received data is not valid
      isDataValid = false;
      }
    }else if(x>16 && x<=18){
      retrievedValue= getIntData(baseDataPath+"/"+userId+"/device_mode/"+String(x));
      if(retrievedValue>-1){
        arrBuffer[x-1] = retrievedValue;
      }else{
      //received data is not valid
      isDataValid = false;
      }
    }

  }
  
  if(isDataValid == true){
    recordBoolData(baseDataPath+"/"+userId+deviceProfileDataFlagPath, false);
    pingArduino('j');
    for(int y = 0; y<18; y++){
      Serial.print(arrBuffer[y]); // Send the array element
      Serial.print(","); // Send a comma as a separator
    }
    Serial.println();
    pingArduino('l');
  }
}
bool recordBoolData(String entityPath, bool entityData){
  bool isSuccess = false;
  if(Firebase.ready()){
    if(Firebase.RTDB.setBool(&fbsData, entityPath, entityData)){
      ledBlink();
      isSuccess = true;
    }
  }
  return isSuccess;
}
int getIntData(String entityPath){
  int tempVal = -1;
  if(Firebase.ready()){
    if(Firebase.RTDB.getInt(&fbsData, (entityPath))){
        ledBlink();
        tempVal = fbsData.to<int>();
    }
  }
  return tempVal;
}
bool getSensorArrayFromArduino(){
  // Read the incoming data and populate the array
  bool recordStatus = true;
  for (int i = 0; i < 3; i++) {
    int data = Serial.parseInt(); // Read and convert to integer
    if(
      recordIntData(baseDataPath+"/"+userId+sensorDataPath+"/"+String(i+1), data) == false){
      recordStatus = false;
    }    
    Serial.read(); // Read the comma separator
  }
  if(recordStatus == true){
    recordBoolData(baseDataPath+"/"+userId+sensorDataFlagPath, true);
  }
  return recordStatus;
}
bool recordIntData(String entityPath, int entityValue){
  bool isRecordDataSuccess = false;
  if (signupStatus){
    if(Firebase.ready()){
      //firebase ready, try to saving int data
      if(Firebase.RTDB.setInt(&fbsData, entityPath, entityValue)){
        ledBlink();
        //success saving to db
        isRecordDataSuccess = true;
      }else{
        Serial.println("Failed saving data cuz : " + fbsData.errorReason());
        //Failed saving data
        isRecordDataSuccess = false;
      }
    }else{
      //firebase not ready
      Serial.print("firebase not ready");
      isRecordDataSuccess = false;
    }
  }else{
    //not sign up
    isRecordDataSuccess = false;
  }
  return isRecordDataSuccess;
  
}
void pingArduino(char transCode){
  Serial.println(transCode);
}
bool pingFirebase(){
  ledBlink();
  bool fireStat = false;
  if(Firebase.ready()){
    if(Firebase.RTDB.getBool(&fbsData, baseDataPath+"/"+userId+deviceProfileDataFlagPath)){
      fireStat = fbsData.to<bool>();
    }else{
      errorCount++;
      if(errorCount == 3){
        errorMsg = fbsData.errorReason();
        errorCount = 0;
      }
    }
  }
  return fireStat;
}

bool pingFirebaseDebug(){
  bool fireStat = false;
  if(Firebase.ready()){
    if(Firebase.RTDB.getBool(&fbsData, baseDataPath+"/"+userId+deviceDebugDataFlagPath)){
      ledBlink();
      fireStat = fbsData.to<bool>();
    }
  }
  else{
    fireStat =  false;
  }
  return fireStat;
}

void fetchDebugDataFromFirebase(){
  int arrBuffer [13];
  for(int x = 0; x<13;x++){
    if(Firebase.ready()){
      if(x<12){
        if(Firebase.RTDB.getInt(&fbsData, ("debug/"+String(x+1)))){
          ledBlink();
          int tempVal = fbsData.to<int>();
          if(tempVal>=0){
            arrBuffer[x] = tempVal;
          }
        }
      }else{
        if(Firebase.RTDB.getBool(&fbsData, "debug/debugStatus")){
          ledBlink();
          bool debugStat = fbsData.to<bool>();
          arrBuffer[12] = debugStat?1:0;
        }else{
          Serial.println("Failed saving data : " + fbsData.errorReason());
        }
      }
    }
  }
  if(Firebase.ready()){
    if(Firebase.RTDB.setBool(&fbsData, (baseDataPath+"/"+userId+deviceDebugDataFlagPath), false)){
      ledBlink();
    }
  }
  pingArduino('k');
  for(int y = 0; y<13; y++){
    Serial.print(arrBuffer[y]); // Send the array element
    Serial.print(","); // Send a comma as a separator
  }
  pingArduino('l');
  Serial.println();
}

void ledBlink(){
  digitalWrite(LED_BUILTIN, LOW);
  delay(1);
  digitalWrite(LED_BUILTIN, HIGH); 
}
