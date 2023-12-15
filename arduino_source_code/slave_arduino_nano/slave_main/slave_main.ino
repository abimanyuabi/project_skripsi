#include "uRTCLib.h" //rtc
#include <OneWire.h> //onewire serial comms
#include <DallasTemperature.h> //dallas ds18b20 temp sensor
#include <Wire.h>

#define slaveAddr 9

//sensor parameters declaration
//top up parameters declaration
#define waterLevelSensorPin 3
int waterLevelStatus = 0;

//temp parameter declaration
#define temperatureSensorPin 2
float temperatureReading = 0;
OneWire tempDataLine(temperatureSensorPin);
DallasTemperature temperatureSensor(&tempDataLine);

//ph sensor parameter declaration
#define phSensorPin A0
float phReading = 0.0;
const int phSamplingCount = 10;
const float adcResolution = 1024.0;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Wire.begin(slaveAddr);
  
  pinMode(waterLevelSensorPin,INPUT);

}

void loop() {
  Wire.onRequest(Serial.println('p'));
  //sensor utils
    // ph read
    int phAdcRead=0;
    for (int i = 0; i < phSamplingCount; i++){
      phAdcRead += analogRead(phSensorPin)-50;
    }
    float avgPhVoltage = (phAdcRead/(phSamplingCount*1.0)) * (5 / 1024.0);
    phReading = abs(7 + ((2.5-avgPhVoltage) / 0.18)); 

    //temp read
    temperatureSensor.requestTemperatures();
    temperatureReading = temperatureSensor.getTempCByIndex(0);

    //check waterLevel
    waterLevelStatus= digitalRead(waterLevelSensorPin);
}
void sendResponse(){
    Serial.write("writing response");
    int ph = phReading*100;
    int temp = temperatureReading*100;
    //initiate comms with transCode
    Wire.write('m');
    //send the respective data
    Wire.write(temp);
    Wire.write(ph);
    Wire.write(waterLevelStatus);
}

