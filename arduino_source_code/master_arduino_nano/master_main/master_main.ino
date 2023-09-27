//library declaration
#include "uRTCLib.h" //rtc
#include <OneWire.h> //onewire serial comms
#include <DallasTemperature.h> //dallas ds18b20 temp sensor
#include "PCF8574.h" //GPIO expander
#include <LiquidCrystal_I2C.h>


//object declaration
uRTCLib rtc(0x68); //rtc i2c address 0x68
PCF8574 gpioExpander(0x20); // gpio expander object
LiquidCrystal_I2C lcd(0x27, 16, 2);

//status declaration
bool wifiStatus = true;
bool sdCardStatus = false;
bool offlineMode = true;
bool isNewData = false;
int deviceMode = 1;

//program time tracker declaration
unsigned long globalMillisTemp100ms = 0;
unsigned long globalMillisTemp1s = 0;
unsigned long globalMillisTemp30s = 0;
unsigned long globalMillisTemp60s = 0;
unsigned long globalMillisTrig100ms = 100;
unsigned long globalMillisTrig1s = 1000;
unsigned long globalMillisTrig30s = 30000;
unsigned long globalMillisTrig60s = 60000;
int wavePumpCycle = 0;
int minuteCounter = 1;

//sensor parameters declaration
#define waterLevelSensorPin P7
#define temperatureSensorPin A7
#define phSensorPin A6
bool isTopUp = false;
float temperatureReading = 0.0;
float phReading = 0.0;
float phSamplingCount = 10;
float adcResolution = 1024.0;
OneWire tempDataLine(temperatureSensorPin);
DallasTemperature temperatureSensor(&tempDataLine);

//led parameters declaration
int ledBaseStrength [4] = {256, 256, 256, 256};
int ledTimings [4] = {5, 10, 14, 6}; //sunrise time, peak time, sunset time, night time
int ledTimingMultiplier [4] = {30, 100, 70, 5}; //sunrise, peak, sunset, night, to use this multiplier need to be divided by 100
int ledFinalStrength [16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; // led final strength = base strength * float(30/100);


//dose parameters declaration
int doseDivider = 12; // divide the dose needed to several dose event
int doseTriggerTime = 0; // trigger when dose event should occur in minutes
float dosePumpSpeed = 16.0; //speed volume/second
int doseCount = 0; // count every dose event
int errorDose = 0; // subtraction of doseDivider - doseCount
int doseOffset = 5; // dose offset between every dose event to separate each dose event
int dosePumpPins [3] = {19, 20, 21}; //dosing pump output pins
int doseTriggerDuration [3] = {0, 0, 0}; //dosing trigger duration in millisecond according to millis counter
int doseNeeded [3] = {0, 0, 0}; // needed dose for alk, cal, mag
float doseResolution [3] ={1.0, 10.0, 10.0}; //alk 1Dkh / 100ml, cal 10ppm / 100ml, mag 10ppm / 100ml
unsigned long doseMillisTemp = 0;
bool isDoseMillisSync = false;
bool delayNewDoseProfile = false;

//wavemaker parameters declaration

int waveMode = 3;

//top up parameters declaration
int topUpCount = 0;
int waterLoss = 6; //deciliter


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  URTCLIB_WIRE.begin();
  //rtc.set(20, 28, 18, 3, 26, 9, 23); // use when rtc out of sync
  // rtc.set(second, minute, hour, dayOfWeek, dayOfMonth, month, year)
  // set day of week (1=Sunday, 7=Saturday)
  temperatureSensor.begin(); //begin temp sensor
  gpioExpander.pinMode(waterLevelSensorPin, INPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  rtc.refresh(); //refresh rtc
  minuteTracker(); //track minute in a day
  if(Serial.available()){
    char transCode = Serial.read();
    if(transCode == 'z'){
      getDeviceProfileFromEsp();
    }
    if(transCode = 'p'){
      wifiStatus = false;
    }else if(transCode == 'n'){
      wifiStatus = true;
    }
  }
  if(millis() - globalMillisTemp100ms == globalMillisTrig100ms){
    globalMillisTemp100ms = millis();
    sensorSampling();
  }
  if(millis() - globalMillisTemp1s == globalMillisTrig1s){ //process that run every 1s
    globalMillisTemp1s = millis();
    if(wifiStatus == false){
      pingEsp('a');
    }
  }
  if(millis() - globalMillisTemp30s == globalMillisTrig30s){ //process that run every 30s
    globalMillisTemp30s = millis();

  }
  if(millis() - globalMillisTemp60s == globalMillisTrig60s){
    globalMillisTemp60s = millis();
    if(wifiStatus == true){
      sendSensorDataToEsp(rtc);
    }
  }
  //check if new data is true and evaluate the existing precalculated device profile data
  if(isNewData == true){
    //when new data is true evaluate all device profile parameters with new retrieved data
    ledScheduler();

    // when new data arrived at new day minuteCounter == 0 then evaluate the new retrieved dosing data, when it's not make a schedule for the next day 
    if(minuteCounter== 0){
      dosingScheduler();
    }else if(minuteCounter !=0){
      delayNewDoseProfile = true;
    }
    //when done, dispell the isNewData flag
    isNewData = false;
  }
  //check if delayNewDoseProfile is true and change it's pre-calculated data with new data when minuteCounter == 0 indicating new day
  if(minuteCounter == 0 && delayNewDoseProfile == true){
    dosingScheduler();
    delayNewDoseProfile = false;
  }
}

void minuteTracker(){
  if(rtc.minute()!=minuteCounter){
    if(minuteCounter<1440){
      minuteCounter = minuteCounter+1;
    }else{
      minuteCounter = 0;
    }
  }
}

void ledScheduler(){
  for (int x = 0; x<16 ; x++){
    //sunrise
    if(x>=0 && x<4){
      ledFinalStrength[x] = ledBaseStrength[x] * float(ledTimingMultiplier[0]/100.0);
    }
    //peak
    if(x>=4 && x<8){
      ledFinalStrength[x] = ledBaseStrength[x-4] * float(ledTimingMultiplier[1]/100.0);
    }
    //sunset
    if(x>=8 && x<12){
      ledFinalStrength[x] = ledBaseStrength[x-8] * float(ledTimingMultiplier[2]/100.0);
    }
    //night
    if(x>=12 && x<16){
      ledFinalStrength[x] = ledBaseStrength[x-8] * float(ledTimingMultiplier[3]/100.0);
    }
  }
}

void dosingScheduler(){
  doseTriggerTime = 1440 / doseDivider;
  float floatDoseDivider = doseDivider / 1.0;
  for(int z = 0; z<3; z++){
    int neededVol = (float(doseNeeded[z] / doseResolution[z]) * 100.0)/floatDoseDivider;
    doseTriggerDuration[z] = (neededVol / dosePumpSpeed) * 1000.0;
  }
}

void sensorSampling(){
  // ph read
  int phAdcRead=0;
  for (int i = 0; i < phSamplingCount; i++){
    phAdcRead += analogRead(phSensorPin);
    delay(2);
  }
  float avgPhVoltage = 5 / adcResolution * phAdcRead/phSamplingCount;
  phReading = 7.0 + ((2.5 - avgPhVoltage) / 0.18);

  //temp read
  temperatureSensor.requestTemperatures();
  temperatureReading = temperatureSensor.getTempCByIndex(0); //in celcius

  //water level pins
  isTopUp = bool(gpioExpander.digitalRead(waterLevelSensorPin));
}

void getDeviceProfileFromEsp(){
  // Read the incoming data and populate the array
  for (int i = 0; i < 18; i++) {
    int retrievedData = Serial.parseInt();
    if(i>=0 && i<=3 && retrievedData>=0){
      ledTimings[i]=retrievedData;
    }else if (i>= 4 && i<= 7 && retrievedData>=0){
      ledTimingMultiplier[i-4] = retrievedData;
    }else if (i>= 8 && i<= 11 && retrievedData>=0){
      ledBaseStrength[i-8] = retrievedData;
    }else if (i>=12 && i<=14 && retrievedData>=0){
      doseNeeded[i-12] = retrievedData;
    }else if(i == 15 && retrievedData>=0){
      doseDivider = retrievedData;
    }else if(i == 16 && retrievedData>=0){
      deviceMode = retrievedData;
    }else if(i == 17 && retrievedData>=0){
      waveMode = retrievedData;
    }
    Serial.read(); // Read the comma separator
  }
  isNewData = true;
}

void sendSensorDataToEsp(uRTCLib rtcs){
  int phValue = phReading*100;
  int waterTempValue = temperatureReading*100;
  int salinityValue = 1025; //placeholder, salinity readings is still in test
  int topUpWaterUsage = topUpCount * waterLoss;
  int sensorArrayData [8]{rtcs.day(), rtcs.hour(), rtcs.minute(), rtcs.second(), phValue, waterTempValue, salinityValue, topUpWaterUsage};
  pingEsp('b');
  for (int i = 0; i < 8; i++) {
    Serial.print(sensorArrayData[i]); // Send the array element
    Serial.print(","); // Send a comma as a separator
  }
  Serial.println();
}

void pingEsp(char transCode){
  Serial.println(transCode);
}
