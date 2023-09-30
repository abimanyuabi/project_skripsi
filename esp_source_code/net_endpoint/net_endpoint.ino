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

    }
  }

}
bool getSensorArrayFromArduino(){
  // Read the incoming data and populate the array
  bool recordStatus = false;
    for (int i = 0; i < 8; i++) {
      int data = Serial.parseInt(); // Read and convert to integer
      recordStatus = recordIntData("sensor/"+String(i), data);
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
void pingArduino(char transCode){
  Serial.println(transCode);
}
bool pingFirebase(){
  bool rtData = false;
  return rtData;
}
void ledBlink(){
  digitalWrite(LED_BUILTIN, LOW);
  delay(1);
  digitalWrite(LED_BUILTIN, HIGH); 
}
