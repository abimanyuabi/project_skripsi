//library declaration
#include <Wire.h>
#include "uRTCLib.h" //rtc
#include <OneWire.h> //onewire serial comms
#include <DallasTemperature.h> //dallas ds18b20 temp sensor
#include "PCF8574.h" //GPIO expander
#include <LiquidCrystal_I2C.h>

#define sdaPin A4 //pin for i2c protocol (SDA)
#define sclPin A5 //pin for i2c protocol (SCL)
#define sdPilotLampPin P3 //pin for sd card indicator light relay
#define feedingModeSwitchPin P6 // pin for feeding mode switch (debug)
#define viewingModeSwitchPin P5 // pin for viewing mode switch (debug)
#define symmetricWaveSwitchPin P4 // pin for symmetric wave pattern mode switch (debug)
#define assymmetricWaveSwitchPin P2 // pin for assymmetric wave pattern mode switch (debug)

uRTCLib rtc(0x68); //object of rtc i2c address 0x68
PCF8574 gpioExpander(0x20); //object of gpio expander object
LiquidCrystal_I2C lcd(0x27, 16, 2); //object of i2c lcd

char transCode = '-'; //serial comms transmission code
bool isHalted = false; //flag that indicates master device serial comms is allowed or not
bool wifiStatus = false; //flag that indicates wifi status from esp
bool firebaseStatus = false; //flag that indicates firebase status from esp
bool isNewData = false; //flag that indicates if there's new device profile data from firebase successfully transmitted through serial communication from esp endpoint
int deviceState = 1; //device mode. 1 is default mode // 2 is viewing mode // 3 feeding mode
int debugData [13] ={255,255,255,255,255,1,1,1,1,1,1,0,0}; //debug parameters data

int minuteCounter = 0; //program minute tracker
int globalSecondTemp1s = -1; //program timing tracker container variable for seconds 
int globalMinuteTemp1m = -1; //program timing tracker container variable for minute
unsigned long currMillis = 0; //program timing tracker container variable for current millisecond from epoch

//led parameters declaration
#define ledFanPin P0 //led fixture fan pin
#define ledRedPin 3 //led fixture red channel pin
#define ledGreenPin 5 //led fixture green channel pin
#define ledBluePin 9 //led fixture blue channel pin
#define ledWhitePin 6 //led fixture white channel pin
int ledStateFlag = 0; //0 night, 1 sunrise, 2 peak, 3 sunset
int ledBaseStrength [4] = {256, 256, 256, 256}; //led base strength for respective channel (RGBW)
int ledTimings [4] = {5, 10, 14, 6}; //led fixture timings trigger time for respective time (sunrise time, peak time, sunset time, night time)
int ledTimingMultiplier [4] = {30, 100, 70, 5}; //led fixture timings multiplier in % manner for respective time (sunrise time, peak time, sunset time, night time)
int ledFinalStrength [16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; // led final strength = base strength * float(30/100); {sunrise x4, peak x4, sunset x4, night x4} RGBW

int doseDivider = 360; // divide the dose needed to several dose event
int doseInterval = 0; // trigger when dose event should occur in minutes
int doseEventFlag = 0; // dose event flag that points out which pump channel need to activate on current event, 0 for standby, 1, 2, 3 for respective channel to dispense according to it's duty duration
int doseMinuteTemp = 0;
float dosePumpSpeed = 0.25; //speed volume ml/second
int doseCounter = 0; // count every dose event
int doseOffset = 1; // dose offset between every dose event to separate each dose event
const int dosePumpPins [3] = {A2, A1, A0}; //dosing pump output pins
unsigned int doseTriggerDuration [3] = {0, 0, 0}; //dosing trigger duration in millisecond according to millis counter
int doseNeeded [3] = {1, 20, 20}; // needed dose for alk, cal, mag
const float doseResolution [3] ={1.0, 10.0, 10.0}; //alk 1Dkh / 100ml, cal 10ppm / 100ml, mag 10ppm / 100ml
unsigned long doseMillisTemp = 0; // timings container for dosing duration in millisecond
bool isDoseMillisSync = false; //flag indicating that dosing time tracking variable is not synchronize with current microcontroller millisecond
bool isDoseEventDone [3] = {false, false, false}; // flag that indicating if the respective dose event according to it's channel is done

const int wavePumpLeft = 4; // left wavemaker pin 
const int wavePumpRight = 7; // right wavemaker pin
int waveMode = 2; // 1 bi-linear, 2 symmetric, 3 assymetric
int wavePumpCycle = 0; // wave pump cycle timings, count every second up to wavePumpDutyDuration in seconds
int wavePumpDutyDuration = 12; // wavepump cycle max duration
int wavePumpOffset = 2; // wave pump activation timings offset for synchronous or asynchronous wave pattern

const int returnPumpPin = 8; // return pump pins
bool returnPumpState = true; // return pump state

//setup parameters and object
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  //object init
    // wire slave
    Wire.begin();
    //rtc.set(20, 28, 18, 3, 26, 9, 23); // use when rtc out of sync // rtc.set(second, minute, hour, dayOfWeek, dayOfMonth, month, year) // set day of week (1=Sunday, 7=Saturday)
      URTCLIB_WIRE.begin();
    // lcd begin
      lcd.init();
      lcd.backlight();
    //begin gpio expander
      gpioExpander.begin();

  // setup led fixture pins
    pinMode(ledRedPin, OUTPUT);
    pinMode(ledGreenPin, OUTPUT);
    pinMode(ledBluePin, OUTPUT);
    pinMode(ledWhitePin, OUTPUT);
    pinMode(ledFanPin, OUTPUT);
    digitalWrite(ledFanPin, HIGH);

  // setup dosing pump pins
    pinMode(dosePumpPins[0], OUTPUT);
    pinMode(dosePumpPins[1], OUTPUT);
    pinMode(dosePumpPins[2], OUTPUT);
    digitalWrite(dosePumpPins[0], HIGH);
    digitalWrite(dosePumpPins[1], HIGH);
    digitalWrite(dosePumpPins[2], HIGH);

  // setup wavemaker pins
    pinMode(wavePumpLeft, OUTPUT);
    pinMode(wavePumpRight, OUTPUT);
    digitalWrite(wavePumpLeft, HIGH);
    digitalWrite(wavePumpRight, HIGH);

  // setup return pump pin
    pinMode(returnPumpPin, OUTPUT);
    digitalWrite(returnPumpPin, HIGH);

  // setup panel i/o pins
    gpioExpander.pinMode(symmetricWaveSwitchPin, INPUT);
    gpioExpander.pinMode(assymmetricWaveSwitchPin, INPUT);
    gpioExpander.pinMode(viewingModeSwitchPin, INPUT);
    gpioExpander.pinMode(feedingModeSwitchPin, INPUT);
    gpioExpander.pinMode(sdPilotLampPin, OUTPUT);
    gpioExpander.digitalWrite(sdPilotLampPin, HIGH);
  //device profile data initialization
    rtc.refresh(); //refresh data from rtc
    minuteCounter = rtc.hour() * 60 + rtc.minute(); 
    ledScheduler();
    dosingCalculator();
}
void loop() {
  rtc.refresh(); //refresh data from rtc
  currMillis = millis(); //keep track new millis
  minuteCounter = rtc.hour() * 60 + rtc.minute(); // track continous minute
  if(Serial.available()){//check serial comm for new data in serial buffer
    transCode = '-';
    transCode = Serial.read();
    if(transCode == 'j'){ //transcode 'g' indicate there's new device profile data from firebase already transmitted in serial
      getDeviceProfileFromEsp();
    }
    if(transCode == 'k'){ //transcode 'g' indicate there's new debug data from firebase already transmitted in serial
      getDebugDataFromEsp();
    }
    if(transCode == 'g'){ //transcode 'g' indicate the wifi is offline and so do the firebase
      wifiStatus = false;
      firebaseStatus = false;
    }
    else if(transCode == 'i'){ //transcode 'i' indicate the wifi and firebase is good
      wifiStatus = true;
      firebaseStatus = true;
    }
    else if(transCode == 'h'){ //transcode 'h' indicate the wifi is online but the firebase is offline
      firebaseStatus = false;
      wifiStatus = true;
    }
    else if(transCode == 'm'){ //transcode that instruct master to halt
      isHalted = true;
    }
    else if (transCode == 'n'){ //transcode that instruct master to dispell any halt status
      isHalted = false;
    }
    else{ //when transCode dont meet any condition
      transCode = '-';
    }
  }
  if(rtc.second() != globalSecondTemp1s){//run every 1s
      globalSecondTemp1s = rtc.second();
      if(wavePumpCycle == wavePumpDutyDuration){ //when wavepump cycle is equal to its duration limit, it would be reset to zero
        wavePumpCycle = 0;
      }
      wavePumpCycle = wavePumpCycle+1;
    }
  if(rtc.minute() != globalMinuteTemp1m){//run every 1 minute to evaluate dosing scheduler
      globalMinuteTemp1m = rtc.minute();
      dosingScheduler(); //dose scheduler
      Serial.println("doseFlag : "+String(doseEventFlag));
      Serial.println("currMinute : " +String(minuteCounter));
      Serial.println("doseMinuteTemp : " +String(doseMinuteTemp));
    }
  if(isNewData == true){ //check is there new data from firebase?
    ledScheduler(); //when there's new data and valid >0 assign led final strength with new value
    dosingCalculator(); //when there's new data and valid >0 dosing profile with new value
  }
  if(debugData[12]>0){ // if debug mode debugData[12] isn't false(>0) device will enter debug mode and override any active scheduler
    analogWrite(ledRedPin, debugData[0]);
    analogWrite(ledGreenPin, debugData[1]);
    analogWrite(ledBluePin, debugData[2]);
    analogWrite(ledWhitePin, debugData[3]);
    analogWrite(ledFanPin, debugData[4]);
    digitalWrite(dosePumpPins[0], debugData[5]);
    digitalWrite(dosePumpPins[1], debugData[6]);
    digitalWrite(dosePumpPins[2], debugData[7]);
    digitalWrite(returnPumpPin, debugData[9]);
    digitalWrite(wavePumpLeft, debugData[10]);
    digitalWrite(wavePumpRight, debugData[11]);
  }else if(debugData[12]==0){ // if debug mode debugData[12] is false(==0) device will enter working mode and utilize any active scheduler
    if(deviceState == 1){ //working mode in normal mode regulate normal led, return pump and wave pump state evaluation
      evaluateLedState(rtc.hour());
      evaluateReturnPumpState(true);
    }
    else if (deviceState == 2){ //working mode in viewing mode regulate more actinic lighting led state evaluation and current return pump and wave pump profile
      digitalWrite(ledFanPin, LOW);
      analogWrite(ledRedPin, 180);
      analogWrite(ledGreenPin, 180);
      analogWrite(ledBluePin, 255);
      analogWrite(ledWhitePin, 200);
    }
    else if(deviceState == 3){ //feeding mode regulate led to display more white spectrum, wave pump and return pump to off
      waveMode = 0;
      evaluateReturnPumpState(false);
      digitalWrite(ledFanPin, LOW);
      analogWrite(ledRedPin, 0);
      analogWrite(ledGreenPin, 0);
      analogWrite(ledBluePin, 175);
      analogWrite(ledWhitePin, 255);
    }
    wavemakerScheduler(); //schedule and evaluate wavemaker state
    evaluateDoseState(); //schedule and evaluate dose pump state
    //evaluatePanelState(); //evaluate panel state
  }
}
void ledScheduler(){ //led strength calculator for respective timings
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
      ledFinalStrength[x] = ledBaseStrength[x-12] * float(ledTimingMultiplier[3]/100.0);
    }
  }
  isNewData = false;
}
void wavemakerScheduler(){ //schedule and evaluate wave pump profile
  if(waveMode == 1){ //bi-linear wave
    digitalWrite(wavePumpLeft, LOW);
    digitalWrite(wavePumpRight, LOW);
  }
  else if (waveMode == 2){ //symmetrical wave
    if (wavePumpCycle>0 && wavePumpCycle <= wavePumpDutyDuration/2){
      digitalWrite(wavePumpLeft, LOW);
      digitalWrite(wavePumpRight, HIGH);
    }else if(wavePumpCycle > wavePumpDutyDuration/2 && wavePumpCycle <= wavePumpDutyDuration){
      digitalWrite(wavePumpLeft, HIGH);
      digitalWrite(wavePumpRight, LOW);
    }
  }
  else if (waveMode == 3){ //assymmetrical wave
    if(minuteCounter == 0){
      if (wavePumpCycle>0 && wavePumpCycle <= wavePumpDutyDuration/3 + wavePumpOffset ){
        digitalWrite(wavePumpLeft, LOW);
        digitalWrite(wavePumpRight, HIGH);
      }else if(wavePumpCycle > wavePumpDutyDuration/3 && wavePumpCycle <= wavePumpDutyDuration){
        digitalWrite(wavePumpLeft, HIGH);
        digitalWrite(wavePumpRight, LOW);
      }
    }
    else if(minuteCounter >0){
      if(minuteCounter % 2 == 0){
        if (wavePumpCycle>0 && wavePumpCycle <= wavePumpDutyDuration/3 + wavePumpOffset ){
          digitalWrite(wavePumpLeft, LOW);
          digitalWrite(wavePumpRight, HIGH);
        }else if(wavePumpCycle > wavePumpDutyDuration/3 && wavePumpCycle <= wavePumpDutyDuration){
          digitalWrite(wavePumpLeft, HIGH);
          digitalWrite(wavePumpRight, LOW);
        }
      }else{
        if (wavePumpCycle>0 && wavePumpCycle <= wavePumpDutyDuration/3 + wavePumpOffset ){
          digitalWrite(wavePumpLeft, HIGH);
          digitalWrite(wavePumpRight, LOW);
        }else if(wavePumpCycle > wavePumpDutyDuration/3 && wavePumpCycle <= wavePumpDutyDuration){
          digitalWrite(wavePumpLeft, LOW);
          digitalWrite(wavePumpRight, HIGH);
        }
      }
    }
  }
  else if (waveMode == 0){ //all pump off
    digitalWrite(wavePumpLeft, HIGH);
    digitalWrite(wavePumpRight, HIGH);
  }
}
void dosingScheduler(){ //schedule dosing event according to it's divider
  if(minuteCounter == 0 && doseEventFlag == 0 && isDoseEventDone[0] == false){
    doseEventFlag = 1;
  }else if(minuteCounter>0){
    if(minuteCounter == doseOffset && doseEventFlag ==0 && isDoseEventDone[1] == false ){
      doseEventFlag = 2;
    }else if(minuteCounter == doseOffset*2 && doseEventFlag ==0 && isDoseEventDone[2] == false){
      doseEventFlag = 3;
      doseMinuteTemp = minuteCounter;
    }
    if(minuteCounter - doseMinuteTemp == doseInterval && doseEventFlag ==0 && isDoseEventDone[0] == false ){
      doseEventFlag = 1;
    }else if(minuteCounter - (doseMinuteTemp + doseOffset) == doseInterval && doseEventFlag ==0 && isDoseEventDone[1] == false){
      doseEventFlag = 2;
    }else if(minuteCounter - (doseMinuteTemp + (doseOffset*2)) == doseInterval && doseEventFlag ==0 && isDoseEventDone[2] == false){
      doseEventFlag = 3;
      doseMinuteTemp = minuteCounter - (doseOffset*2);
    }
  }
}
void dosingCalculator(){ //calculator & data parser
  doseInterval = 1440 / doseDivider;
  doseMinuteTemp = minuteCounter;
  float floatDoseDivider = doseDivider / 1.0;
  for(int z = 0; z<3; z++){
    float neededVol = (float(doseNeeded[z] / doseResolution[z]) * 100.0)/floatDoseDivider;
    doseTriggerDuration[z] = (neededVol / dosePumpSpeed) * 1000.0;
  }
}
void evaluateLedState(int currentHour){ //evaluate device state
  //sunrise
  if(currentHour >= ledTimings[0] && currentHour < ledTimings[1]){
    ledStateFlag = 1;
    digitalWrite(ledFanPin, LOW);
    analogWrite(ledRedPin, ledFinalStrength[0]);
    analogWrite(ledGreenPin, ledFinalStrength[1]);
    analogWrite(ledBluePin, ledFinalStrength[2]);
    analogWrite(ledWhitePin, ledFinalStrength[3]);
  }
  //peak
  else if(currentHour >= ledTimings[1] && currentHour < ledTimings[2]){
    ledStateFlag = 2;
    digitalWrite(ledFanPin, LOW);
    analogWrite(ledRedPin, ledFinalStrength[4]);
    analogWrite(ledGreenPin, ledFinalStrength[5]);
    analogWrite(ledBluePin, ledFinalStrength[6]);
    analogWrite(ledWhitePin, ledFinalStrength[7]);
  }
  //sunset
  else if(currentHour >= ledTimings[2] && currentHour < ledTimings[3]){
    ledStateFlag = 3;
    digitalWrite(ledFanPin, LOW);
    analogWrite(ledRedPin, ledFinalStrength[8]);
    analogWrite(ledGreenPin, ledFinalStrength[9]);
    analogWrite(ledBluePin, ledFinalStrength[10]);
    analogWrite(ledWhitePin, ledFinalStrength[11]);
  }
  //night
  else if(currentHour >= ledTimings[3] || currentHour < ledTimings[0]){
    ledStateFlag = 0;
    digitalWrite(ledFanPin, LOW);
    analogWrite(ledRedPin, ledFinalStrength[12]);
    analogWrite(ledGreenPin, ledFinalStrength[13]);
    analogWrite(ledBluePin, ledFinalStrength[14]);
    analogWrite(ledWhitePin, ledFinalStrength[15]);
  }
}
void evaluateDoseState(){
  if(doseEventFlag > 0){
    //sync the doseMillisTemp with current millis to start counting pump duration
    if(isDoseMillisSync == false){ //in the beginnig dose millis is not synced with current millis, it needs to be synced when dose event flag occur
      doseMillisTemp = currMillis;
      isDoseMillisSync = true ;//when synced reassign dosemillis sync to true
    }
    if(isDoseMillisSync == true){ // when true pump activated for pre-determined duration 
      digitalWrite(dosePumpPins[doseEventFlag-1], LOW);//activate pump pin to high
      Serial.println("dose");
      //evaluate the dose channel state
      if(currMillis - doseMillisTemp > doseTriggerDuration[doseEventFlag-1]){ // when dose event has elapsed for the pre-deternmined duration, the pump de-activate and all event flag & time tracking dispelled & resetted
        digitalWrite(dosePumpPins[doseEventFlag-1], HIGH);
        isDoseEventDone[doseEventFlag-1] = true;
        Serial.println(doseEventFlag);
        Serial.println(doseTriggerDuration[doseEventFlag-1]);
        Serial.println(currMillis - doseMillisTemp);
        doseMillisTemp = 0;
        isDoseMillisSync = false;
        doseEventFlag = 0;
        doseCounter = doseCounter +1;
        if(doseEventFlag==1){
          isDoseEventDone[1] = false;
        }else if(doseEventFlag == 2){
          isDoseEventDone[2] == false;
        }else if(doseEventFlag == 3){
          isDoseEventDone [0] == false;
        }
      }
    }
  }
}
void evaluateReturnPumpState(bool returnPumpStates){
  if(returnPumpStates == false){
    digitalWrite(returnPumpPin, HIGH);
  }else{
    digitalWrite(returnPumpPin, LOW);
  }
}
void evaluatePanelState(){
  bool feedState = false;
  bool viewingState = false;
  bool symmetricalState = false;
  bool assymmetricalState = false;
  feedState = gpioExpander.digitalRead(feedingModeSwitchPin);
  viewingState = gpioExpander.digitalRead(viewingModeSwitchPin);
  symmetricalState = gpioExpander.digitalRead(symmetricWaveSwitchPin);
  assymmetricalState = gpioExpander.digitalRead(assymmetricWaveSwitchPin);
  //check the device mode
  if(feedState == true){
    deviceState = 3;
  }else if(viewingState == true){
    deviceState = 2;
  }
  //check waveMode
  if(symmetricalState == true){
    waveMode = 2;
  }else if(assymmetricalState == true){
    waveMode = 3;
  }
}

//data transmission
void getDeviceProfileFromEsp(){ //read serial communication to receive new device profile data from esp
  if(Serial.available()){ // Read the incoming data and populate the array
    for (int i = 0; i < 18; i++) {
      int retrievedData = Serial.parseInt();
      if(i>=0 && i<=3 && retrievedData>=0 && retrievedData <=24){
        ledTimings[i]=retrievedData;
      }else if (i>= 4 && i<= 7 && retrievedData>0&& retrievedData <=100){
        ledTimingMultiplier[i-4] = retrievedData;
      }else if (i>= 8 && i<= 11 && retrievedData>0&& retrievedData <=255){
        ledBaseStrength[i-8] = retrievedData;
      }else if (i>=12 && i<=14 && retrievedData>0&& retrievedData <=10){
        doseNeeded[i-12] = retrievedData;
      }else if(i == 15 && retrievedData>0&& retrievedData <48){
        doseDivider = retrievedData;
      }else if(i == 16 && retrievedData>0&& retrievedData <=4){
        deviceState = retrievedData;
      }else if(i == 17 && retrievedData>0&& retrievedData <=3){
        waveMode = retrievedData;
      }
      Serial.read(); // Read the comma separator
    }
  }
  isNewData = true; //re-assign is new data to true indicating there's new device profile data from firebase
}
void getDebugDataFromEsp(){  //read serial communication to receive new debug data from esp
  for(int i = 0; i<13 ; i++){
    int retrievedData = Serial.parseInt();
    debugData[i]= retrievedData;
    Serial.read();
  }
}
void pingEsp(char transCode){  //initiate serial communication to send transcode data to esp
  Serial.println(transCode);
}