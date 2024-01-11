#include "uRTCLib.h" //rtc
#include <OneWire.h> //onewire serial comms
#include <DallasTemperature.h> //dallas ds18b20 temp sensor
#include <Wire.h>

//communication flag 
bool isHalted = true;
char transCode = '-';

//timing declaration
const unsigned long timingTrigger = 60000;
unsigned long timingTimeStamp = 0;
unsigned long timingCurrentMillis = 0;
const unsigned long sensorTrigger = 200;
unsigned long sensorTimeStamp = 0;

//sensor parameters declaration
//top up parameters declaration
#define waterLevelSensorPin 3
#define topUpPumpPin 4
const int topUpPumpSpeed = 1; // Litre/s
int waterLevelStatus = 0;
int waterTopUpConsumption = 1;
unsigned long topUpTimingCounter = 0;
unsigned long topUpTimingTimeStamp = 0;
bool isTopUpTimingInitialized = false;


//temp parameter declaration
#define temperatureSensorPin 2
#define sumpFan 5
float temperatureReading = 1;
OneWire tempDataLine(temperatureSensorPin);
DallasTemperature temperatureSensor(&tempDataLine);

//ph sensor parameter declaration
#define phSensorPin A0
float phReading = 1.0;
float phKumulatif = 0.0;
int phCount = 0;
const int phSamplingCount = 5;
const float adcResolution = 1024.0;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(waterLevelSensorPin,INPUT);
  pinMode(topUpPumpPin, OUTPUT);
  pinMode(sumpFan, OUTPUT);
  digitalWrite(topUpPumpPin, HIGH);
  digitalWrite(sumpFan, HIGH);

}

void loop() {
  //timings
  timingCurrentMillis = millis();
  if(timingCurrentMillis - timingTimeStamp >= timingTrigger){
    timingTimeStamp = timingCurrentMillis;
    //send sensor data
    if(isHalted == false){
      phReading = phKumulatif/phCount;
      phKumulatif = 0.0;
      phCount = 0;
      sendSensorDataToEsp();
    }
  }
  if(timingCurrentMillis - sensorTimeStamp >= sensorTrigger){
    sensorTimeStamp = timingCurrentMillis;
    // ph read
    int phAdcRead=0;
    for (int i = 0; i < phSamplingCount; i++){
      phAdcRead += analogRead(phSensorPin)-110;
      delay(100);
    }
    float avgPhVoltage = (phAdcRead/phSamplingCount) * (5 / 1024.0);
    phReading = abs(7 + ((2.5-avgPhVoltage) / 0.15)); 
    //temp read
    temperatureSensor.requestTemperatures();
    temperatureReading = temperatureSensor.getTempCByIndex(0);
    //check waterLevel
    waterLevelStatus= digitalRead(waterLevelSensorPin);
    phKumulatif = phKumulatif+phReading;
    phCount = phCount+1;
    Serial.println("ph :" +String(phReading));
    Serial.println("temperature :" +String(temperatureReading));
    Serial.println("water level :"+String(waterLevelStatus));
    Serial.println("avg adc read"+String(phAdcRead/phSamplingCount));
    Serial.println("avg volt: "+String(avgPhVoltage));
  }
  //check serial comm
  if(Serial.available()){
    transCode = '-';
    transCode = Serial.read();
    if(transCode == 'a' || transCode == 'g' || transCode == 'h' || transCode =='j' || transCode =='k'){
      //apply halt comm state
      isHalted = true;
    }else if (transCode =='b' || transCode == 'i' || transCode == 'l'){
      //dispel any halt state
      isHalted = false;
    }else{
      transCode = '-';
    }
  }
  if(temperatureReading>27){
    digitalWrite(sumpFan,LOW);
  }else if(temperatureReading <=27){
    digitalWrite(sumpFan, HIGH);
  }
  
  //call evaluation function
  evaluateTopUpPumpState();
}
void evaluateTopUpPumpState(){
  if(waterLevelStatus==0){
    digitalWrite(topUpPumpPin, HIGH);
    if(isTopUpTimingInitialized == true){
      int topUpElapsed = millis() - topUpTimingTimeStamp;
      waterTopUpConsumption = waterTopUpConsumption + ((topUpElapsed/1000.0)*topUpPumpSpeed);
      isTopUpTimingInitialized = false;
      topUpTimingTimeStamp = 0;
    }
  }else{
    //activate top up pump
    digitalWrite(topUpPumpPin, LOW);
    if(isTopUpTimingInitialized == false){
      //when it's the pump first time activated program will evaluate time tracking parameters to start counting top up time elapsed 
      topUpTimingTimeStamp = millis();
      isTopUpTimingInitialized = true;
    }
  }
}

void sendSensorDataToEsp(){
  int arrBuffer[3] = {(phReading*100), (temperatureReading*100), waterTopUpConsumption};
  pingDevice('m');
  for(int y = 0; y<3; y++){
    Serial.print(arrBuffer[y]); // Send the array element
    Serial.print(","); // Send a comma as a separator
  }
  Serial.println();
  pingDevice('n');
}
void pingDevice(char transCodes){
  Serial.println(transCodes);
}

