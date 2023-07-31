//library declaration
#include <OneWire.h>
#include <DallasTemperature.h>

//declaration output pins
int dsPumpRlyPins [3]={26, 25, 24}; //relay
int wvPumpRlyPins [2] = {5, 7}; //relay
int tpPumpRlyPins = 12; //relay
int ledGreenRlyPins = 10; //relay
int ledRedRlyPins = 11; //relay
int ledWhiteMosfetsPins = 9; //mosfets
int ledBlueMosfetsPins = 8; //mosfets
int ledFanMosfetsPins = 6; //mosfets

//declaration input pins
int phProbeInputPins = 23 ; 
int wtrLvlInputPin = 19 ;
OneWire tempProbePins(20);
DallasTemperature tempSensors(&tempProbePins);

//declaration slave unit pins
int sdCardReaderModule [4] = {13, 16, 14, 15};//CS,SCK, MOSI, MISO
int i2cSdaPins = 23 ;
int i2cSclPins = 24;
int txPins = 1;
int rxPins = 2;
uRTCLib rtc(0x68);

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
  int dsPumpMlPerSecond = 1;
  int dsPumpMinuteTracker = 0;
  int dsPumpEventCounter = 0;
  int dsPumpMlPerMinute = 1;
  int alkalinitySolutionConcentrationPerMl = 1;
  int calciumSolutionConcentrationPerMl = 1;
  int magnesiumSolutionConcentrationPerMl = 1;

//instrument flag
  //dosing pump
  bool dsPumpEventFlag = false;
  int dsPumpChannelFlag = 0; //max 3, default 0
  int dsDoneAtSecond = 0;
  int dsSecondTracker = 0;

  //top up pump
  bool tpReservoirPumpFlag = false;

  //wavemaker pump
  bool wvPumpChannel1Flag = false;
  bool wvPumpChannel2Flag = false;
  

void setup (){
  Serial.begin(9600);
  tempSensors.begin();
  URTCLIB_WIRE.begin();
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

//dsPumpUtils used as dosing pump activation method, it called once every a complete program cycle (once every second)
void dsPumpUtils(int alkalinityVal, int calciumVal, int magnesiumVal,  int pumpPointerIndex, uRTCLib curentTime){
  int alkSolutionNeededInMl =alkalinityVal / alkalinitySolutionConcentrationPerMl;
  int calSolutionNeededInMl = calciumVal / calciumSolutionConcentrationPerMl;
  int magSolutionNeededInMl = magnesiumVal / magnesiumVal; 
  int alkDuration = alkSolutionNeededInMl/dsPumpMlPerMinute;
  int calDuration = calSolutionNeededInMl/dsPumpMlPerMinute;
  int magDuration = magSolutionNeededInMl/dsPumpMlPerMinute;
  dsDoneAtSecond = alkDuration+calDuration+magDuration;
  if(dsPumpEventFlag==true){
    //dose start from alk, cal, mag
    if (currentTime.seconds ==0){
      dsPumpChannelFlag = 1;
      dsSecondTracker++;
    }

  }else{
    dsPumpChannelFlag = 0;
    dsPumpEventFlag = false;
  }
}

void dsPumpScheduling(int divider){
    if (dsPumpEventCounter ==0  && minuteInDay == minuteInDay/divider*dsPumpEventCounter) {
      dsPumpEventCounter++;
      dsPumpEventFlag == true;
      // dose pump active
    }
    else if (dsPumpEventCounter >0 && dsPumpEventCounter<divider && minuteInDay == minuteInDay/divider*dsPumpEventCounter) {
      dsPumpEventCounter ++;
      dsPumpEventFlag == true;
      // dose pump active
    }
    else if(dsPumpEventCounter==divider){
      dsPumpEventCounter =0
      //dose schedule daily reset
    }
}
float tpPumpUtils(){
  //in celcius
  tempSensors.requestTemperatures(); 
  return tempSensors.getTempCByIndex(0);
}
