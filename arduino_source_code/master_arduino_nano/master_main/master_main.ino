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
  bool wifiStatus = false;
  bool firebaseStatus = false;
  bool isNewData = false;
  int deviceMode = 1; //1 is default mode // 2 is viewing mode // 3 feeding mode

//program time tracker declaration
  unsigned long globalMillisTemp1s = 0;
  unsigned long globalMillisTrig1s = 1000;
  unsigned long globalMillisTemp1m = 0;
  unsigned long globalMillisTrig1m = 60000;
  unsigned long currMillis = 0;
  int minuteCounter = 0;

//sensor parameters declaration
  //top up parameters declaration
  #define waterLevelSensorPin A6
  #define topUpPumpPin A3
  int topUpCount = 0;
  int waterLoss = 1; //deciliter
  bool isTopUpDone = false;

  //temp parameter declaration
  #define temperatureSensorPin 2
  #define sumpFanPin P1
  float temperatureReading = 0;
  OneWire tempDataLine(temperatureSensorPin);
  DallasTemperature temperatureSensor(&tempDataLine);

  //ph sensor parameter declaration
  #define phSensorPin A7
  float phReading = 0.0;
  int phSamplingCount = 10;
  float adcResolution = 1024.0;

//led parameters declaration
  #define ledFanPin P0
  #define ledRedPin 3
  #define ledGreenPin 5
  #define ledBluePin 9
  #define ledWhitePin 6
  int ledStateFlag = 0; //0 night, 1 sunrise, 2 peak, 3 sunset
  int ledBaseStrength [4] = {256, 256, 256, 256}; //RGBW
  int ledTimings [4] = {5, 10, 14, 6}; //sunrise time, peak time, sunset time, night time
  int ledTimingMultiplier [4] = {30, 100, 70, 5}; //sunrise, peak, sunset, night, to use this multiplier need to be divided by 100
  int ledFinalStrength [16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; // led final strength = base strength * float(30/100); {sunrise x4, peak x4, sunset x4, night x4} RGBW

//dose parameters declaration
  int doseDivider = 12; // divide the dose needed to several dose event
  int doseInterval = 0; // trigger when dose event should occur in minutes
  int doseEventFlag = 0;
  int doseMinuteTemp = 0;
  float dosePumpSpeed = 0.25; //speed volume ml/second
  int doseCounter = 0; // count every dose event
  int doseOffset = 5; // dose offset between every dose event to separate each dose event
  int dosePumpPins [3] = {A2, A1, A0}; //dosing pump output pins
  int doseTriggerDuration [3] = {0, 0, 0}; //dosing trigger duration in millisecond according to millis counter
  int doseNeeded [3] = {1, 20, 20}; // needed dose for alk, cal, mag
  float doseResolution [3] ={1.0, 10.0, 10.0}; //alk 1Dkh / 100ml, cal 10ppm / 100ml, mag 10ppm / 100ml
  unsigned long doseMillisTemp = 0;
  bool isDoseMillisSync = false;
  bool delayNewDoseProfile = false;

//wavemaker parameters declaration
  int wavePumpLeft = 4;
  int wavePumpRight = 7;
  int waveMode = 2; //1 bi-linear, 2 symmetric, 3 assymetric
  int wavePumpCycle = 0;
  int wavePumpDutyDuration = 12;
  int wavePumpOffset = 2;

//return pump parameters declaration
  int returnPumpPin = 8;
  bool returnPumpState = true;

//common pin declaration
  #define sdaPin A4
  #define sclPin A5

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
    // lcd begin
      lcd.init();
      lcd.backlight();
    //begin gpio expander
      gpioExpander.begin();
  // setup sensor pins
    pinMode(phSensorPin, INPUT);
    pinMode(waterLevelSensorPin, INPUT);

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

  //setup top up pin
    pinMode(topUpPumpPin, OUTPUT);
    digitalWrite(topUpPumpPin, HIGH);

  // setup panel i/o pins
    gpioExpander.pinMode(symmetricWaveSwitchPin, INPUT);
    gpioExpander.pinMode(assymmetricWaveSwitchPin, INPUT);
    gpioExpander.pinMode(viewingModeSwitchPin, INPUT);
    gpioExpander.pinMode(feedingModeSwitchPin, INPUT);
    gpioExpander.pinMode(sdPilotLampPin, OUTPUT);
    gpioExpander.pinMode(sumpFanPin, OUTPUT);
  //device profile data initialization
    ledScheduler();
    dosingCalculator();
}
void loop() {
  currMillis = millis();
  rtc.refresh();
  //timing and program cycle
    if(minuteCounter == 1439){
      waterLoss = 0;
      topUpCount = 0;
      minuteCounter = 0;
    }
    else{
      minuteCounter = rtc.hour() * 60 + rtc.minute(); // track continous minute
    }
  //check serial comm for new data in serial buffer
    if(Serial.available()){
      char transCode = Serial.read();
      //transCode z is for signalling arduino to prepare and receiving the transmitted device profile data from esp
      if(transCode == 'z'){ 
          getDeviceProfileFromEsp();
          wifiStatus = true;
          firebaseStatus = true;
      }
      //transcode 'w' indicate the wifi is offline and so do the firebase
      if(transCode == 'w'){
        wifiStatus = false;
        firebaseStatus = false;
      }
      //transcode 'n' indicate the wifi and firebase is good
      else if(transCode == 'n'){
        wifiStatus = true;
        firebaseStatus = true;
      }
      //transcode 'f' indicate the wifi is online but the firebase is offline
      else if(transCode == 'f'){
        firebaseStatus = false;
        wifiStatus = true;
      }
    }
  //run every 1s for check wifi status with ping to esp via serial comm evaluate led state, and evaluate sensor readings
    if(currMillis - globalMillisTemp1s > globalMillisTrig1s){
      globalMillisTemp1s = currMillis;
      //ping esp
        if(wifiStatus == false){
            pingEsp('a');
        }
      //evaluate sensor readings
        sensorSampling();
      //keep track wavepump cycle 
        if(wavePumpCycle == 12){
          wavePumpCycle = 0;
        }
        wavePumpCycle = wavePumpCycle+1;
      //evaluate lcd state and content
        evaluateLcdState(rtc.hour(), rtc.minute());
    }
  //run every 1 minute for sending sensor data to esp
    if(currMillis - globalMillisTemp1m > globalMillisTrig1m){
      globalMillisTemp1m = currMillis;
      if(wifiStatus == true){
        sendSensorDataToEsp(rtc);
      }
    }
  //run every program cycle
    //flag checker
      //check is there new data from firebase?
        if(isNewData == true){
          //when there's new data and valid >0 assign led final strength with new value
          ledScheduler();
          //check if its new day (minuteCounter == 1439)
          if(minuteCounter == 1439){
            dosingCalculator();
          }else{
            delayNewDoseProfile = true;
          }
        }
      //check is delayNewDoseProfile true and its on minuteCounter = 1439
        if(delayNewDoseProfile == true && minuteCounter == 1439){
          dosingCalculator();
        }
      //check device mode
        //normal mode regulate normal led state evaluation
        if(deviceMode == 1){
          evaluateLedState(rtc.hour());
          evaluateReturnPumpState(true);
        }
        //viewing mode regulate more actinic lighting led state evaluation
        else if (deviceMode == 2){
          waveMode = 3;
          evaluateReturnPumpState(true);
          digitalWrite(ledFanPin, LOW);
          analogWrite(ledRedPin, 180);
          analogWrite(ledGreenPin, 180);
          analogWrite(ledBluePin, 255);
          analogWrite(ledWhitePin, 200);
        }
        //feeding mode regulate led to display white spectrum, wave pump and return pump to off
        else if(deviceMode == 3){
          waveMode = 0;
          evaluateReturnPumpState(false);
          digitalWrite(ledFanPin, LOW);
          analogWrite(ledRedPin, 0);
          analogWrite(ledGreenPin, 0);
          analogWrite(ledBluePin, 175);
          analogWrite(ledWhitePin, 255);
        }
    //device state evaluation
      //schedule and evaluate wavemaker state
      wavemakerScheduler();
      //schedule and evaluate dose pump state
      //dose scheduler
      dosingScheduler();
      //evaluate the dose and schedule
      evaluateDoseState();
      //evaluate top up pump state
      evaluateTopUpState();
      //evaluate sumpfan state
      evaluateSumpFanState();
      //evaluate panel state
      evaluatePanelState();
}
//scheduler
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
        ledFinalStrength[x] = ledBaseStrength[x-12] * float(ledTimingMultiplier[3]/100.0);
      }
    }
    isNewData = false;
  }
  void wavemakerScheduler(){
    //bi-linear wave
      if(waveMode == 1){
        digitalWrite(wavePumpLeft, LOW);
        digitalWrite(wavePumpRight, LOW);
      }
      //symmetrical wave
      else if (waveMode == 2){
        if (wavePumpCycle>0 && wavePumpCycle <= wavePumpDutyDuration/2){
          digitalWrite(wavePumpLeft, LOW);
          digitalWrite(wavePumpRight, HIGH);
        }else if(wavePumpCycle > wavePumpDutyDuration/2 && wavePumpCycle <= wavePumpDutyDuration){
          digitalWrite(wavePumpLeft, HIGH);
          digitalWrite(wavePumpRight, LOW);
        }
      }
      //assymmetrical wave
      else if (waveMode == 3){
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
      //all pump off
      else if (waveMode == 0){
        digitalWrite(wavePumpLeft, HIGH);
        digitalWrite(wavePumpRight, HIGH);
      }
  }
  void dosingScheduler(){
    if(minuteCounter == 0){
      doseCounter = doseCounter+1;
      doseEventFlag = 1;
    }else if(minuteCounter>0){
      if(minuteCounter == doseOffset){
        doseEventFlag = 2;
      }else if(minuteCounter == doseOffset*2){
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
  }

//calculator & data parser
  void dosingCalculator(){
    doseInterval = 1440 / doseDivider;
    float floatDoseDivider = doseDivider / 1.0;
    for(int z = 0; z<3; z++){
      int neededVol = (float(doseNeeded[z] / doseResolution[z]) * 100.0)/floatDoseDivider;
      doseTriggerDuration[z] = (neededVol / dosePumpSpeed) * 1000.0;
    }
    delayNewDoseProfile = false;
  }

//evaluate device state
  void evaluateLedState(int currentHour){
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
        doseMillisTemp = millis();
        isDoseMillisSync = true ;//when synced reassign dosemillis sync to true
      }else if(isDoseMillisSync == true){ // when true pump activated for pre-determined duration 
        digitalWrite(dosePumpPins[doseEventFlag-1], LOW);//activate pump pin to high
        //evaluate the dose channel state
        if(millis() - doseMillisTemp > doseTriggerDuration[doseEventFlag-1]){ // when dose event has elapsed for the pre-deternmined duration, the pump de-activate and all event flag & time tracking dispelled & resetted
          digitalWrite(dosePumpPins[doseEventFlag-1], HIGH);
          doseMillisTemp = 0;
          isDoseMillisSync = false;
          doseEventFlag = 0;
          doseCounter = doseCounter +1;
        }
      }
      
    }
  }
  void evaluateTopUpState(){
    //water level pins
    bool isTopUp = bool(digitalRead(waterLevelSensorPin));
    if(isTopUp == true){
      digitalWrite(topUpPumpPin, LOW);
      isTopUpDone = true;

    }else if(isTopUp == false && isTopUpDone == true){
      digitalWrite(topUpPumpPin, HIGH);
      isTopUpDone = false;
      topUpCount = topUpCount+1;
      waterLoss = waterLoss + topUpCount*6;
      if(waterLoss>5000){
        waterLoss = 0;
        //force reset
      }
    }
  }
  void evaluateSumpFanState(){
    int temperature = int(temperatureReading);
    if(temperature > 26){
      gpioExpander.digitalWrite(sumpFanPin, LOW);
    }else{
      gpioExpander.digitalWrite(sumpFanPin, HIGH);
    }
  }
  void evaluateLcdState(int hour, int minute){
    String secondRow = "Ph:"+String(int(phReading))+" T:"+String(int(temperatureReading));
    String firstRow = "-";
    Serial.println(secondRow);
    if(waveMode == 1){
      firstRow = String(hour)+":"+String(minute)+" WF:Lin";
    }else if(waveMode == 2){
      firstRow = String(hour)+":"+String(minute)+" WF:Sym";
    }else if(waveMode == 3){
      firstRow = String(hour)+":"+String(minute)+" WF:Asy";
    }
    Serial.println(firstRow);
    lcd.clear();
    if(secondRow.length()<16){
      //display dose state
      lcd.setCursor(0, 1);
      lcd.print(secondRow);
    }
    if(firstRow.length()<16){
      //display time
      lcd.setCursor(0, 0);
      lcd.print(firstRow);
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
      deviceMode = 3;
    }else if(viewingState == true){
      deviceMode = 2;
    }
    //check waveMode
    if(symmetricalState == true){
      waveMode = 2;
    }else if(assymmetricalState == true){
      waveMode = 3;
    }
  }


//sensor utils
  void sensorSampling(){
    // ph read
    int phAdcRead=0;
    for (int i = 0; i < phSamplingCount; i++){
      phAdcRead += analogRead(phSensorPin)-50;
    } 
    float avgPhVoltage = (phAdcRead/(phSamplingCount*1.0)) * (4.48 / 1024.0);
    phReading = abs(6.99 + ((avgPhVoltage-2.58) / 0.18)); 
    //temp read
    temperatureSensor.requestTemperatures();
    temperatureReading = temperatureSensor.getTempCByIndex(0);
  }

//data transmission
  //firebase r/w through esp
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
    //re-assign is new data to true indicating there's new device profile data from firebase
    isNewData = true;
  }
  void sendSensorDataToEsp(uRTCLib rtcs){
    int phValue = phReading*100.0;
    int waterTempValue = temperatureReading*100.0;
    int salinityValue = 1025; //placeholder, salinity readings is still in test
    int sensorArrayData [8]{rtcs.day(), rtcs.hour(), rtcs.minute(), rtcs.second(), phValue, waterTempValue, salinityValue, waterLoss};
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
//