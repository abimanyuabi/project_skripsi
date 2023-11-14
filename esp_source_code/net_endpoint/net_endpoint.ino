#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/RTDBHelper.h"
#include "addons/TokenHelper.h"
#include<string>

//program timings
unsigned long millisTemp = 0;
unsigned long millisTrigg = 1000;

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

#define netPilotLamp D0
bool calledOnce = true;

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
    //do nothing
    Serial.print("fail to wifi");
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
  unsigned long currMillis = millis();
  if(wifiStatus == false){
    networkReconnect();
  }else if(wifiStatus == true && signupStatus == false){
    firebaseReconnect();
  }
  
  // put your main code here, to run repeatedly:
  if(Serial.available()){
    char transCode = '-';
    transCode = Serial.read();
    if(transCode == 'a'){
      if(pingFirebase() == true){
        pingArduino('n');
      }else if(pingFirebase() == false){
        pingArduino('f');
      }else if(wifiStatus == false){
        pingArduino('w');
      }
    }else if(transCode == 'b'){
      getSensorArrayFromArduino();
    }
  }
  // run every 1 second to ping firebase is there new data on firebase devprof
  if(currMillis - millisTemp > millisTrigg){
    millisTemp = currMillis;
    if(pingFirebase() == true){
      fetchNewDeviceData();
    }
    if(pingFirebaseDebug()==true){
      fetchDebugDataFromFirebase();
    }
    if(checkNetwork() == false){
      pingArduino('w');
    }else if(signupStatus == false){
      pingArduino('f');
    }
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
      Serial.println("ready");
    }else{
      firebaseErrorMsg = config.signer.signupError.message.c_str();
    }
  }
}
void fetchNewDeviceData(){
  int arrBuffer [18];
  for(int x = 0; x<18;x++){
    int tempVals = getIntData("devprof/"+String(x));
    if(tempVals>=0){
      arrBuffer[x] = tempVals;
    }
  }
  recordBoolData("devprof/isNewData", false);
  pingArduino('z');
  for(int y = 0; y<18; y++){
    Serial.print(arrBuffer[y]); // Send the array element
    Serial.print(","); // Send a comma as a separator
  }
  Serial.println();

}
bool recordBoolData(String entityPath, bool entityData){
  bool isSuccess = false;
  if(Firebase.ready()){
    if(Firebase.RTDB.setBool(&fbsData, ("aquariums_data/"+ entityPath), entityData)){
      ledBlink();
      isSuccess = true;
    }
  }
  return isSuccess;
}
int getIntData(String entityPath){
  int tempVal = -1;
  if(Firebase.ready()){
    if(Firebase.RTDB.getInt(&fbsData, ("aquariums_data/"+entityPath))){
        ledBlink();
        tempVal = fbsData.to<int>();
    }
  }
  return tempVal;
}
bool getSensorArrayFromArduino(){
  // Read the incoming data and populate the array
  bool recordStatus = true;
  for (int i = 0; i < 8; i++) {
      int data = Serial.parseInt(); // Read and convert to integer
      if(recordIntData("sensor/"+String(i), data) == false){
        recordStatus = false;
      }
      Serial.read(); // Read the comma separator
    }
  return recordStatus;
}
bool recordIntData(String entityPath, int entityValue){
  bool isRecordDataSuccess = false;
  if (signupStatus){
    if(Firebase.ready()){
      //firebase ready, try to saving int data
      if(Firebase.RTDB.setInt(&fbsData, ("aquariums_data/"+ entityPath), entityValue)){
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
  bool fireStat = false;
  if(Firebase.ready()){
    if(Firebase.RTDB.getBool(&fbsData, "aquariums_data/devprof/isNewData")){
      ledBlink();
      fireStat = fbsData.to<bool>();
    }
  }
  else{
    fireStat =  false;
  }
  return fireStat;
}

bool pingFirebaseDebug(){
  bool fireStat = false;
  if(Firebase.ready()){
    if(Firebase.RTDB.getBool(&fbsData, "debug/isNewData")){
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
          Serial.println("Failed saving data cuz : " + fbsData.errorReason());
        }
      }
    }
  }
  if(Firebase.ready()){
    if(Firebase.RTDB.setBool(&fbsData, ("debug/isNewData"), false)){
      ledBlink();
    }
  }
  pingArduino('x');
  for(int y = 0; y<13; y++){
    Serial.print(arrBuffer[y]); // Send the array element
    Serial.print(","); // Send a comma as a separator
  }
  Serial.println();
}

void ledBlink(){
  digitalWrite(LED_BUILTIN, LOW);
  delay(1);
  digitalWrite(LED_BUILTIN, HIGH); 
}
