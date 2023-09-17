//library declaration
#include <OneWire.h>
#include <DallasTemperature.h>
#include <SPI.h>
#include <SD.h>
#include "Arduino.h"
#include "uRTCLib.h"

//declaration output pins
int dsPumpRlyPins [3]={24, 25, 26}; // relays comps = 24 for alk, 25 for cal, 26 for mag 
int wvPumpRlyPins [2] = {5, 7}; //relay
int tpPumpRlyPins = 12; //relay
int ledGreenRlyPins = 10; //relay
int ledRedRlyPins = 11; //relay
int ledWhiteMosfetsPins = 9; //mosfets
int ledBlueMosfetsPins = 8; //mosfets
int ledFanMosfetsPins = 6; //mosfets

//declaration input pins
int phProbeInputPins = 23 ; //ph probe output P0 pins
int wtrLvlInputPin = 19 ; //water level sensor pins
OneWire tempProbePins(20); // temperature pins
DallasTemperature tempSensors(&tempProbePins);

//declaration slave unit pins
int sdCardReaderModule [4] = {13, 16, 14, 15};//CS,SCK, MOSI, MISO
int i2cSdaPins = 23 ; //SDA pin for i2c comms 
int i2cSclPins = 24; //SCL pin for i2c comms
int txPins = 1; //arduino transmit pin
int rxPins = 2; //arduino receive pin
uRTCLib rtc(0x68); //rtc i2c address 0x68


//default value 
  //ph probe def val
  float defValProbeReading = 0.0;
  int defValSamples = 10;
  float defValADCResolution = 1024.0;

  //temp probe def val
  float defTempVal = 0.0;

  //time keeping def val
  char daysOfTheWeek[7][12] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
  int countMinuteInDay = 0;
  int currMinuteTemp = 0;
  int minuteInDay = 1440;
  bool isMinuteChanging = false;
  int programCycle = 0;

  //dosing pump def val
  int dsPumpEventCounter = 0; //dosing pump event counter
  int dsPumpFlowRate = 0.3; //flow rate is 0.3 per second
  int dsDivider = 2 ; //dosing event divider 
  int dsPumpDuration[3]={1,1,1}; //duration in program cycle

  //light default value
  int lightDutyTimings [4] = {5, 11, 15, 18}; //hour pointer when respective mode should active
  int lightChannelStrength [4] = {200, 220, 256, 256}; //base light channel strength for the respective RGBW channel in PWM Resolution
  int lightTimingStrengthMultiplier [4] = {40, 100, 70, 1}; //light channel strength multiplier in percentage
  int lightDutyMode = 4;
  int lightDutyStage = 0;

  //logging file
  File loggingData;

//instrument flag
  //network status
  bool isNetPresent = false;
  bool isDataRetrieved = false;
  bool manualNetModeOverride = false;

  //dosing pump
  bool dsPumpEventFlag = false;
  int dsPumpChannelFlag = 0; //max 3, default 0
  int dsDoneAtSecond = 0;
  int dsSecondTracker = 0;
  bool dsDutyFlag = false; //indicate that dosing cycle is active
  int dsPumpList[3] = {1,2,3} ;//indicate 3 channel dosing pump
  bool dsDutyTracker[3] = {false, false, false} ;//indicate 3 dosing pump duty status
  int dsCurrentActive = 0; // indicate current active pump
  int dsProgramCycleTracker = 0 ;// count and track program cycle during active dosing cycle
  int dsCurrentEstimatedDuration = 0 ;//represent estimated maximum program cycle for dosing pump to complete task
  int dsMaxPumpCount = 3 ;
  float dsFlowRate = 0.3 ;//dosing pump flow rate is 0.3 ml per second

  //solution calculation
  int alkSolutionConcentration = 1; //raise 1Dkh for 10ml pre-mixed solution
  int calSolutionConcentration = 1; //raise 1ppm calcium for 10ml pre-mixed solution
  int magSolutionConcentration = 1; //raise 1ppm magnesium for 10ml pre-mixed solution
  int alkNeededInDkh = 1;
  int calNeededInPpm = 1;
  int magNeededInPpm = 1;


  //top up pump
  bool tpReservoirPumpFlag = false;

  //wavemaker pump
  bool wvPumpChannel1Flag = false;
  bool wvPumpChannel2Flag = false;

//-------------------------------------------------------------------------------------//
//MAIN METHOD
//-------------------------------------------------------------------------------------//
void setup (){
  Serial.begin(9600);
  tempSensors.begin();
  URTCLIB_WIRE.begin();
  SD.begin(sdCardReaderModule[0]);
  pinMode(dsPumpRlyPins[0], OUTPUT);
  pinMode(dsPumpRlyPins[1], OUTPUT);
  pinMode(dsPumpRlyPins[2], OUTPUT);
  pinMode(wtrLvlInputPin, INPUT);

  loggingData = SD.open("data.json", FILE_WRITE);
}
void loop (){
  if(programCycle == 10){
    programCycle =0;
  }
  rtc.refresh();
  rtcTimeTracking(rtc);
  programCycle++;
  delay(100);
  
}

//-------------------------------------------------------------------------------------//
//PROGRAM FLOW AND MODE
//-------------------------------------------------------------------------------------//
void isModeOffline(){
  //open file, get latest configuration
  int latestLedTimings [4] = {0, 0, 0, 0};
  int latestLedStrength [4] = {0, 0, 0, 0};
  int latestLedMultiplier [4] = {0, 0, 0, 0};
  int latestWaveProfile [2] = {0, 0};
  int latestDosingNeeded [3] = {0, 0, 0};
  int latestDosingDivider = 0;
}

//-------------------------------------------------------------------------------------//
//CALCULATION AND PARSING
//-------------------------------------------------------------------------------------//

  //dsPumpDurationCalc calculate how long the pump need to active for their respective liquid needed to dispense
void dsPumpDurationCalc(){
  int alkSolutionNeeded = alkSolutionConcentration*alkNeededInDkh;
  int calSolutionNeeded = calSolutionConcentration*calNeededInPpm;
  int magSolutionNeeded = magSolutionConcentration*magNeededInPpm;
  int alkDuration = (alkSolutionNeeded/dsFlowRate)*10;
  int calDuration = (calSolutionNeeded / dsFlowRate)*10;
  int magDuration = (magSolutionNeeded / dsFlowRate) *10;
  dsPumpDuration[0]=alkDuration;
  dsPumpDuration[1]=calDuration;
  dsPumpDuration[2]=magDuration;
}

//-------------------------------------------------------------------------------------//
//INPUT/READING METHODS
//-------------------------------------------------------------------------------------//
void rtcTimeTracking(uRTCLib currentRtc){
  if(currentRtc.hour() ==23 && currentRtc.minute() == 59){
    //for resetting the time track counter
    int countHourInDay = 0;
    int countMinuteInDay = 0;
  }else{
    if(currentRtc.minute()!=currMinuteTemp){
      /*when the current rtc minute is different from current minute temporary 
      var it signify that the minute increasing therefore the counter 
      will increment by one until it reaches approx 1440 then it resseted*/
      countMinuteInDay++;
      currMinuteTemp == currentRtc.minute();
      isMinuteChanging = true;
    }
    else{
      isMinuteChanging = false;
    }
  }

}

float phProbeReadings(){
  //phProbeReading
  int result = 0;
    for (int i = 0; i < defValSamples; i++)
    {
        result += analogRead(phProbeInputPins);
        delay(10);

    }
    //find the average probe voltage readings and divide it by max return voltage
    float voltage = 5 / defValADCResolution* result/defValSamples; 
    //find the phv value
    return (7 + ((2.5 - voltage) / 0.18));
  }

int tpUpStatus(){
  return digitalRead(wtrLvlInputPin);
}

float tpPumpUtils(){
  //in celcius
  tempSensors.requestTemperatures(); 
  return tempSensors.getTempCByIndex(0);
}

//-------------------------------------------------------------------------------------//
//OUTPUT/CONTROL METHOD
//-------------------------------------------------------------------------------------//

  //dosing pump task
  //dsPumpUtils used as dosing pump activation and duty cycle method, it called every program cycle
void dsPumpUtils(){
  if (dsDutyFlag == true && dsCurrentActive == 0){ //ignitor condition and activation of first pump
    dsCurrentActive = 1; //initial set pump channel
    dsDutyTracker[dsCurrentActive-1] = true; //respective duty tracker turned to true
    dsProgramCycleTracker +=1; //dosing program cycle tracker is started
    }
  else if (dsDutyFlag == true && dsCurrentActive>0 && dsCurrentActive<=3){//repeated process in program cycle at dosing event
    if(dsProgramCycleTracker<=dsPumpDuration[dsCurrentActive-1]){
      /*when dsProgramCycleTracker less or equal from current channel duration at duration array dosing program cycle will increase by 1 
      represent 1 program cycle, and it counts until the dosing channel duration duty is done*/
      dsProgramCycleTracker +=1; //tracker will be increased by one every complete program cycle
    }else{//reset for next channel
      dsDutyTracker[dsCurrentActive-1] = false; //the current pump channel duty tracker is dispelled and waiting for the next pump activation
      dsProgramCycleTracker = 0 ; //the dosing program cycle tracker will be dispelled and resseted to 0
      dsCurrentActive+=1; //change channel;
        if (dsCurrentActive <=3){ // if one channel duty duration is done it shift to the next pump channel duty
          dsDutyTracker[dsCurrentActive-1] = true;
          }
    }
  }else if (dsDutyFlag == true && dsCurrentActive>3){ //when one instance of dosing event id done the dosing duty flag and dosing current active pump flag will be dispelled 
    //dosing event is done
    dsDutyFlag = false; //dosing duty flag will be resetted back to false, waiting for next dosing event 
    dsCurrentActive =0; //current dosing pump will be resetted back to 0 waiting for next dosing event
  }
}
  //dsPumpScheduling is used as scheduler for dosing pump array
void dsPumpScheduling(){
  if (dsPumpEventCounter ==0  && minuteInDay == minuteInDay/dsDivider*dsPumpEventCounter) {
    dsPumpEventCounter++;
    dsPumpEventFlag == true;
    // dose pump active
  }
  else if (dsPumpEventCounter >0 && dsPumpEventCounter<dsDivider && minuteInDay == minuteInDay/dsDivider*dsPumpEventCounter) {
    dsPumpEventCounter ++;
    dsPumpEventFlag == true;
    // dose pump active
  }
  else if(dsPumpEventCounter==dsDivider){
    dsPumpEventCounter =0;
    //dose schedule daily reset
  }
}
  
  //top up pump utility
void topUpActivation(int status){
  if(status == 1){
    digitalWrite(tpPumpRlyPins, HIGH);
  }
}
  
  //light scheduling and timings utility
    //light color intensity adjustment
void colorIntensityAdjustment(int red, int green, int blue, int white){
  lightChannelStrength[0] = red;
  lightChannelStrength[1] = green;
  lightChannelStrength[2] = blue ;
  lightChannelStrength[3] = white;
}
  //light strength multiplier adjustment
void lightStrengthAdjustment(int sunrise, int peak, int sunset, int night){
  lightTimingStrengthMultiplier[0] = sunrise;
  lightTimingStrengthMultiplier[1] = peak;
  lightTimingStrengthMultiplier[2] = sunset;
  lightTimingStrengthMultiplier[3] = night;
}
    //light intensity calculator
int intensityCalc(int strength, int multiplier, int lightDutyStages){
  if (lightDutyStages == 1){
    return ((strength/100)*multiplier)*0.75;
  }else if(lightDutyStages == 2){
    return ((strength/100)*multiplier)*0.25;
  }
}
    //light timings scheduling
void lightTimingsScheduling(int h, int m){
  if( h >= lightDutyTimings[0] && h < lightDutyTimings[1]){ //sunrise
  //sunrise had 2 stage
    lightCoolingFanUtils(0.85);
    lightDutyMode = 1;
    lightDutyStage = 1;
    //stage shifting
    if (h >= lightDutyTimings[0]+1 && h<lightDutyTimings[1]){
      //stage 2
      lightDutyStage =2;
    }
  }else if (h >= lightDutyTimings[1] && h<lightDutyTimings[2]){ //peak
  //peak only had 1 stage
    lightCoolingFanUtils(1);
    lightDutyMode = 2;
    lightDutyStage = 1;
  }else if(h >= lightDutyTimings[2] && h<lightDutyTimings[3]){ //sunset
  //sunset had 2 stage, inverse of sunrise
    lightCoolingFanUtils(0.8);
    lightDutyMode = 3;
    lightDutyStage = 2;
    if (h >= lightDutyTimings[3]-1 && h < lightDutyTimings[3]){
      //shift to second stage
      lightDutyStage = 1;
    }
  }else if(h >= lightDutyTimings[3] && h != lightDutyTimings[0]){ //nighttime
    lightCoolingFanUtils(0.5);
    lightDutyMode = 4;
    lightDutyStage = 1;
  }else { //unexpected condition light goes off
  lightCoolingFanUtils(0.5);
    lightDutyMode = 4;
    lightDutyStage = 1;
  }
}
    //light activation utility 
void lightTimingsUtils (){
  int lightIntensity [4] = {
    intensityCalc(lightChannelStrength[0], lightTimingStrengthMultiplier[lightDutyMode-1], lightDutyStage), 
    intensityCalc(lightChannelStrength[1], lightTimingStrengthMultiplier[lightDutyMode-1],  lightDutyStage), 
    intensityCalc(lightChannelStrength[2], lightTimingStrengthMultiplier[lightDutyMode-1], lightDutyStage), 
    intensityCalc(lightChannelStrength[3], lightTimingStrengthMultiplier[lightDutyMode-1],  lightDutyStage)};
  if(lightIntensity[0]>0){
    digitalWrite(ledRedRlyPins, HIGH);
  }else if (lightIntensity[0]==0){
    digitalWrite(ledRedRlyPins, LOW);
  }else if(lightIntensity[1]>0){
    digitalWrite(ledGreenRlyPins, HIGH);
  }else if (lightIntensity[1]==0){
    digitalWrite(ledGreenRlyPins, LOW);
  }
  analogWrite(ledBlueMosfetsPins, lightIntensity[2]);
  analogWrite(ledWhiteMosfetsPins, lightIntensity[3]);
}
    //light fan activation
void lightCoolingFanUtils(int multiplier){
  int baseResolution = 256;
  analogWrite(ledFanMosfetsPins, baseResolution*multiplier);
}
