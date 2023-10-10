#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/RTDBHelper.h"
#include "addons/TokenHelper.h"
#include<string>  
 
String firebaseDatabaseEndpoint = "https://controllercoral-default-rtdb.asia-southeast1.firebasedatabase.app/";
String apiKey = "AIzaSyCklfDKO6I3_ZuAzdwgBKZd7lLetzo9tYk";
String wifiSSID = "Kiran2";
String wifiPassword = "Spectrum";
FirebaseData fbsData;
FirebaseAuth fbsAuth;
FirebaseConfig config;
int programCycle = 0;
bool signupStatus = false;

int firebaseOpFlag = 1; //1 for upload new sensor data, 2 for upload new device info data, 3 for fetch new device profile data, 4 for fetch sensor/calibration data
int sensorArrayData[11] = {1, 15, 11, 39, 24, 8, 5, 29, 2, 1025, 20};
int retrievedSensorArray[11]={1,1,1,1,1,1,1,1,1,1,1};

void setup() {
  // put your setup code here, to run once:
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);

  Serial.begin(9600);
  WiFi.begin(wifiSSID, wifiPassword);
  Serial.print("connecting");
  while(WiFi.status( )!=WL_CONNECTED){
    Serial.print("fail to connect to network");
  }Serial.print("connected with ip : ");
  Serial.println(WiFi.localIP());
  config.api_key = apiKey;
  config.database_url = firebaseDatabaseEndpoint;
  if(Firebase.signUp(&config, &fbsAuth, "", "")){
    Serial.println("signup ok");
    signupStatus = true;
  }else{
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }
  config.token_status_callback = tokenStatusCallback;
  Firebase.begin(&config, &fbsAuth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  //program cycle to keep duty cycle on track
  programCycle ++;

  //do data upload sequence
  if( programCycle==5){
      recordSensorData();
      //Serial.println(getBoolData("testBool"));
      //Serial.println(getIntData("testInt"));
  }else{
    Serial.println("-");
  }
  
  //reset program cycle
  if(programCycle == 5){
    programCycle = 0;
  }
  delay(1000);
}

void recordSensorData(){
  Serial.print("test loop");
  for(int i=0; i<11; i++){
    Serial.println(i);
    recordIntData("sensor/"+ String(i), sensorArrayData[i]);
  }
}

int getIntData(String entityPath){
  int tempVal = 0;
  if (signupStatus){
    if(Firebase.ready()){
      Serial.print("firebase ready, try to get int data");
      if(Firebase.RTDB.getInt(&fbsData, ("Data/"+entityPath))){
        ledBlink();
        tempVal = fbsData.to<int>();
        Serial.println("success get data, at : " + fbsData.dataPath());
        Serial.println("(" + fbsData.dataType() + ")");
      }else{
        Serial.println("Failed saving data cuz : " + fbsData.errorReason());
      }
    }else{
      Serial.println("firebase not ready");
    }
  }else{
    Serial.println("not sign up");
  }
  return tempVal;
}

bool getBoolData(String entityPath){
  bool tempVal = false;
  if (signupStatus){
    if(Firebase.ready()){
      Serial.print("firebase ready, try to get bool data");
      if(Firebase.RTDB.getBool(&fbsData, ("Data/"+entityPath))){
        ledBlink();
        tempVal = fbsData.to<bool>();
        Serial.println("success get data, at : " + fbsData.dataPath());
        Serial.println("(" + fbsData.dataType() + ")");
      }else{
        Serial.println("Failed saving data cuz : " + fbsData.errorReason());
      }
    }else{
      Serial.println("firebase not ready");
    }
  }else{
    Serial.println("not sign up");
  }
  return tempVal;
}

void recordIntData(String entityPath, int entityValue){
  if (signupStatus){
    if(Firebase.ready()){
      Serial.print("firebase ready, try to saving int data");
      if(Firebase.RTDB.setInt(&fbsData, ("Data/"+ entityPath), entityValue)){
        ledBlink();
        Serial.println("success saving to db, at : " + fbsData.dataPath());
        Serial.println("(" + fbsData.dataType() + ")");
      }else{
        Serial.println("Failed saving data cuz : " + fbsData.errorReason());
      }
    }else{
      Serial.println("firebase not ready");
    }
  }else{
    Serial.println("not sign up");
  }
  
}

void recordBoolData(String entityPath, bool entityValue){
  if (signupStatus){
    if(Firebase.ready()){
      Serial.print("firebase ready, try to saving bool data");
      if(Firebase.RTDB.setBool(&fbsData, ("Data/"+ entityPath), entityValue)){
        ledBlink();
        Serial.println("success saving to db, at : " + fbsData.dataPath());
        Serial.println("(" + fbsData.dataType() + ")");
      }else{
        Serial.println("Failed saving data cuz : " + fbsData.errorReason());
      }
    }else{
      Serial.println("firebase not ready");
    }
  }else{
    Serial.println("not sign up");
  }
  
}

void ledBlink(){
  digitalWrite(LED_BUILTIN, LOW);
  delay(10); 
  digitalWrite(LED_BUILTIN, HIGH); 
}