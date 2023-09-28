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
  int minuteCounter = 0;

//sensor parameters declaration
  //top up parameters declaration
  int waterLevelSensorPin = 2;
  #define topUpPumpPin A3
  bool isTopUp = false;
  bool isTopUpDone = false;
  int topUpCount = 0;
  int waterLoss = 6; //deciliter

  //temp parameter declaration
  #define temperatureSensorPin A7
  #define sumpFanPin P1
  float temperatureReading = 0.0;
  OneWire tempDataLine(temperatureSensorPin);
  DallasTemperature temperatureSensor(&tempDataLine);

  //ph sensor parameter declaration
  #define phSensorPin A6
  float phReading = 0.0;
  float phSamplingCount = 10;
  float adcResolution = 1024.0;

//led parameters declaration
  #define ledFanPin P0
  int ledStateFlag = 0; //0 night, 1 sunrise, 2 peak, 3 sunset
  int ledPins [4]={3, 5, 9, 6};//RGBW
  int ledBaseStrength [4] = {256, 256, 256, 256}; //RGBW
  int ledTimings [4] = {5, 10, 14, 6}; //sunrise time, peak time, sunset time, night time
  int ledTimingMultiplier [4] = {30, 100, 70, 5}; //sunrise, peak, sunset, night, to use this multiplier need to be divided by 100
  int ledFinalStrength [16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; // led final strength = base strength * float(30/100); {sunrise x4, peak x4, sunset x4, night x4} RGBW

//dose parameters declaration
  #define alkPump A2
  #define calPump A1
  #define magPump A0
  int doseDivider = 12; // divide the dose needed to several dose event
  int doseInterval = 0; // trigger when dose event should occur in minutes
  int doseEventFlag = 0;
  int doseMinuteTemp = 0;
  float dosePumpSpeed = 16.0; //speed volume/second
  int doseCounter = 0; // count every dose event
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
  int wavePumpLeft = 4;
  int wavePumpRight = 7;
  int waveMode = 3;
  int wavePumpCycle = 1;
  int wavePumpDutyDuration = 12;
  int wavePumpOffset = 2;

//return pump parameters declaration
  int returnPumpPin = 8;
  bool returnPumpState = true;

//common pin declaration
  #define sdaPin A4
  #define sclPin A5
  int mosiPin = 11;
  int misoPin = 12;
  int sckPin = 13;
  int csPin = 10;

//I/O panel parameters declaration
  #define sdPilotLampPin P3
  #define feedingModeSwitchPin P6
  #define viewingModeSwitchPin P5
  #define symmetricWaveSwitchPin P4
  #define assymmetricWaveSwitchPin P2

//setup parameters and object
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  //object init
    //rtc.set(20, 28, 18, 3, 26, 9, 23); // use when rtc out of sync // rtc.set(second, minute, hour, dayOfWeek, dayOfMonth, month, year) // set day of week (1=Sunday, 7=Saturday)
    URTCLIB_WIRE.begin();
    //begin temp sensor
    temperatureSensor.begin(); 
    lcd.init();
    lcd.backlight();
  
  // setup sensor pins
    pinMode(phSensorPin, INPUT);
    pinMode(waterLevelSensorPin, INPUT);

  // setup led fixture pins
    pinMode(ledPins[0], OUTPUT);
    pinMode(ledPins[1], OUTPUT);
    pinMode(ledPins[2], OUTPUT);
    pinMode(ledPins[3], OUTPUT);
    pinMode(ledFanPin, OUTPUT);

  // setup dosing pump pins
    pinMode(alkPump, OUTPUT);
    pinMode(calPump, OUTPUT);
    pinMode(magPump, OUTPUT);

  // setup wavemaker pins
    pinMode(wavePumpLeft, OUTPUT);
    pinMode(wavePumpRight, OUTPUT);

  // setup return pump pin
    pinMode(returnPumpPin, OUTPUT);

  // setup panel i/o pins
    gpioExpander.pinMode(symmetricWaveSwitchPin, INPUT);
    gpioExpander.pinMode(assymmetricWaveSwitchPin, INPUT);
    gpioExpander.pinMode(viewingModeSwitchPin, INPUT);
    gpioExpander.pinMode(feedingModeSwitchPin, INPUT);
    gpioExpander.pinMode(sdPilotLampPin, OUTPUT);
}
void loop() {
  // put your main code here, to run repeatedly:
  rtc.refresh(); //refresh rtc
  //check serial comm for new data in serial buffer
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
  //timing and program cycle
    minuteCounter = rtc.hour() * 60 + rtc.minute(); // track continous minute
  //run every 100ms for sensor sampling
    if(millis() - globalMillisTemp100ms == globalMillisTrig100ms){
      globalMillisTemp100ms = millis();
      sensorSampling();
    }
  //run every 1s for check wifi status with ping to esp via serial comm and evaluate led state
    if(millis() - globalMillisTemp1s == globalMillisTrig1s){ //process that run every 1s
      //re-assign the millis temporary var
      globalMillisTemp1s = millis();
      //ping esp
      if(wifiStatus == false){
          pingEsp('a');
      }
      //keep track second for wave timing
      if(wavePumpCycle <= wavePumpDutyDuration){
        wavePumpCycle = wavePumpCycle+1;
      }
      //evaluate led state with current timings and strength final
      evaluateLedState(rtc.hour());
    }
  //run every 30s for recording device profile and sensor data to sd card
    if(millis() - globalMillisTemp30s == globalMillisTrig30s){ //process that run every 30s
      globalMillisTemp30s = millis();

    }
  // run every 60s for sending sensor data to firebase rtdb
    if(millis() - globalMillisTemp60s == globalMillisTrig60s){
      globalMillisTemp60s = millis();
      if(wifiStatus == true){
        sendSensorDataToEsp(rtc);
      }
    }
  //flag check
  //check if new data is true and evaluate the existing precalculated device profile data
    if(isNewData == true){
      //when new data is true evaluate all device profile parameters with new retrieved data
        ledScheduler();
      // when new data arrived at new day minuteCounter == 0 then evaluate the new retrieved dosing data, when it's not make a schedule for the next day 
        if(minuteCounter== 0){
          dosingCalculator();
        }else if(minuteCounter !=0){
          delayNewDoseProfile = true;
        }
      //when done, dispell the isNewData flag
        isNewData = false;
    }
  //check if delayNewDoseProfile is true and change it's pre-calculated data with new data when minuteCounter == 0 indicating new day
    if(minuteCounter == 0 && delayNewDoseProfile == true){
      dosingCalculator();
      delayNewDoseProfile = false;
    }
  //scheduler
    //dosing scheduler
    dosingScheduler();
  //evaluate device state
    //evaluate dose pump profile every program cycle
    evaluateDoseState();
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
void evaluateLedState(int currentHour){
  //sunrise
  if(currentHour >= ledTimings[0] && currentHour < ledTimings[1]){
    ledStateFlag = 1;
    digitalWrite(ledFanPin, HIGH);
    analogWrite(ledPins[0], ledFinalStrength[0]);
    analogWrite(ledPins[1], ledFinalStrength[1]);
    analogWrite(ledPins[2], ledFinalStrength[2]);
    analogWrite(ledPins[3], ledFinalStrength[3]);
  }
  //peak
  else if(currentHour >= ledTimings[1] && currentHour < ledTimings[2]){
    ledStateFlag = 2;
    digitalWrite(ledFanPin, HIGH);
    analogWrite(ledPins[0], ledFinalStrength[4]);
    analogWrite(ledPins[1], ledFinalStrength[5]);
    analogWrite(ledPins[2], ledFinalStrength[6]);
    analogWrite(ledPins[3], ledFinalStrength[7]);
  }
  //sunset
  else if(currentHour >= ledTimings[2] && currentHour < ledTimings[3]){
    ledStateFlag = 3;
    digitalWrite(ledFanPin, HIGH);
    analogWrite(ledPins[0], ledFinalStrength[8]);
    analogWrite(ledPins[1], ledFinalStrength[9]);
    analogWrite(ledPins[2], ledFinalStrength[10]);
    analogWrite(ledPins[3], ledFinalStrength[11]);
  }
  //night
  else if(currentHour >= ledTimings[4] || currentHour < ledTimings[0]){
    ledStateFlag = 0;
    digitalWrite(ledFanPin, LOW);
    analogWrite(ledPins[0], ledFinalStrength[12]);
    analogWrite(ledPins[1], ledFinalStrength[13]);
    analogWrite(ledPins[2], ledFinalStrength[14]);
    analogWrite(ledPins[3], ledFinalStrength[15]);
  }
}
void dosingCalculator(){
  doseInterval = 1440 / doseDivider;
  float floatDoseDivider = doseDivider / 1.0;
  for(int z = 0; z<3; z++){
    int neededVol = (float(doseNeeded[z] / doseResolution[z]) * 100.0)/floatDoseDivider;
    doseTriggerDuration[z] = (neededVol / dosePumpSpeed) * 1000.0;
  }
}
void dosingScheduler(){
  if(minuteCounter == 0){
    doseCounter = doseCounter+1;
    doseEventFlag = 1;
  }else if(minuteCounter == 5){
    doseEventFlag = 2;
  }else if(minuteCounter == 10){
    doseEventFlag = 3;
  }
  if(minuteCounter - doseMinuteTemp == doseInterval){
    doseCounter = doseCounter+1;
    doseEventFlag = 1;
  }else if(minuteCounter - (doseMinuteTemp + doseOffset) == doseInterval){
    doseEventFlag = 2;
  }else if(minuteCounter - (doseMinuteTemp + (doseOffset*2)) == doseInterval){
    doseEventFlag = 3;
    doseMinuteTemp = minuteCounter - (doseOffset*2);
  }
}
void evaluateDoseState(){
  if(doseEventFlag > 0){
    //sync the doseMillisTemp with current millis to start counting pump duration
    if(isDoseMillisSync == false){ //in the beginnig dose millis is not synced with current millis, it needs to be synced when dose event flag occur
      doseMillisTemp = millis();
      isDoseMillisSync == true ;//when synced reassign dosemillis sync to true
    }else if(isDoseMillisSync == true){ // when true pump activated for pre-determined duration 
      digitalWrite(dosePumpPins[doseEventFlag-1], HIGH);//activate pump pin to high
      //evaluate the dose channel state
      if(millis() - doseMillisTemp == doseTriggerDuration[doseEventFlag-1]){ // when dose event has elapsed for the pre-deternmined duration, the pump de-activate and all event flag & time tracking dispelled & resetted
        digitalWrite(dosePumpPins[doseEventFlag-1], LOW);
        doseMillisTemp = 0;
        isDoseMillisSync = false;
        doseEventFlag = 0;
        doseCounter = doseCounter +1;
      }
    }
    
  }
}
void evaluateTopUpState(){
  if(isTopUp == true){
    digitalWrite(topUpPumpPin, HIGH);
    isTopUpDone = true;

  }else if(isTopUp == false && isTopUpDone == true){
    digitalWrite(topUpPumpPin, LOW);
    isTopUpDone = false;
    topUpCount = topUpCount+1;
  }
}
void wavemakerScheduler(int waveMode, int deviceMode){
  //bi-linear wave
  if(waveMode == 1){
    digitalWrite(wavePumpLeft, HIGH);
    digitalWrite(wavePumpRight, HIGH);
  }
  //symmetrical wave
  else if (waveMode == 2){
    if (wavePumpCycle>0 && wavePumpCycle <= wavePumpDutyDuration/2){
      digitalWrite(wavePumpLeft, HIGH);
      digitalWrite(wavePumpRight, LOW);
    }else if(wavePumpCycle > wavePumpDutyDuration/2 && wavePumpCycle <= wavePumpDutyDuration){
      digitalWrite(wavePumpLeft, LOW);
      digitalWrite(wavePumpRight, HIGH);
      if(wavePumpCycle == wavePumpDutyDuration){
        wavePumpCycle = 1;
      }
    }
  }
  //assymmetrical wave
  else if (waveMode == 3){
    if(minuteCounter % 2 == 0){
      if (wavePumpCycle>0 && wavePumpCycle <= wavePumpDutyDuration/3 + wavePumpOffset ){
        digitalWrite(wavePumpLeft, HIGH);
        digitalWrite(wavePumpRight, LOW);
      }else if(wavePumpCycle > wavePumpDutyDuration/3 && wavePumpCycle <= wavePumpDutyDuration){
        digitalWrite(wavePumpLeft, LOW);
        digitalWrite(wavePumpRight, HIGH);
        if(wavePumpCycle == wavePumpDutyDuration){
          wavePumpCycle = 1;
        }
      }
    }else{
      if (wavePumpCycle>0 && wavePumpCycle <= wavePumpDutyDuration/3 + wavePumpOffset ){
        digitalWrite(wavePumpLeft, LOW);
        digitalWrite(wavePumpRight, HIGH);
      }else if(wavePumpCycle > wavePumpDutyDuration/3 && wavePumpCycle <= wavePumpDutyDuration){
        digitalWrite(wavePumpLeft, HIGH);
        digitalWrite(wavePumpRight, LOW);
        if(wavePumpCycle == wavePumpDutyDuration){
          wavePumpCycle = 1;
        }
      }
    }
  }
}
void evaluateSumpFanState(int temperature){
  if(temperature > 26){
    digitalWrite(sumpFanPin, HIGH);
  }else{
    digitalWrite(sumpFanPin, LOW);
  }
}
void evaluateLcdState(int temperature, int hour, int minute){
  //display time
  lcd.setCursor(0, 0);
  lcd.print("T:");
  lcd.setCursor(3, 0);
  lcd.print(hour);
  lcd.setCursor(5, 0);
  lcd.print(minute);
  //display wavemode
  lcd.setCursor(7, 0);
  lcd.print(" WF:");
  if(waveMode == 1){
    lcd.setCursor(10, 0);
    lcd.print("Lin--");
  }else if(waveMode == 2){
    lcd.setCursor(10, 0);
    lcd.print("Sym^");
  }else if(waveMode == 3){
    lcd.setCursor(10, 0);
    lcd.print("Asy^v");
  }
  //display led mode
  lcd.setCursor(0, 1);
  lcd.print("LS:");
  if(ledStateFlag == 0){
    lcd.setCursor(3, 1);
    lcd.print("NT");
  }else if(ledStateFlag == 1){
    lcd.setCursor(3, 1);
    lcd.print("SE");
  }else if(ledStateFlag == 2){
    lcd.setCursor(3, 1);
    lcd.print("PK");
  }else if(ledStateFlag == 3){
    lcd.setCursor(3, 1);
    lcd.print("ST");
  }
  //display dose state
  lcd.setCursor(6, 1);
  lcd.print("dsDiv"+String(doseDivider)+"");

}
void sensorSampling(){
  // ph read
  int phAdcRead=0;
  for (int i = 0; i < phSamplingCount; i++){
    phAdcRead += analogRead(phSensorPin);
  }
  float avgPhVoltage = 5 / adcResolution * phAdcRead/phSamplingCount;
  phReading = 7.0 + ((2.5 - avgPhVoltage) / 0.18);

  //temp read
  temperatureSensor.requestTemperatures();
  temperatureReading = temperatureSensor.getTempCByIndex(0); //in celcius

  //water level pins
  isTopUp = bool(digitalRead(waterLevelSensorPin));
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