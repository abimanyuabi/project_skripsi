int rly1 = 3;
int rly2 = 16;
#define analog A0
unsigned long duration = (((((2/1.0 * 100)/16.0 ) * 1000.0)/24.0)/10)*10 ;//100ml
unsigned long currMillis = 0;
unsigned long trigger = 60;
int minute = 0;
bool doseFlag = false;
bool doseSync = false;
unsigned long millisBuffer = 0;
unsigned long trig = 1000;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(rly1, OUTPUT);
  pinMode(rly2, OUTPUT);
  pinMode(analog, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  if(duration<160){
    duration = 160;
  }
  if(millis() - millisBuffer == trig){
    doseFlag = true;
    millisBuffer = millis();
  }
  if(doseFlag == true){
    if(doseSync == false){
      Serial.println("sync");
      currMillis = millis();
      doseSync = true;
    }
    digitalWrite(rly1, HIGH);
    if(millis() - currMillis == duration){
      digitalWrite(rly1, LOW);
      currMillis = 0;
      doseFlag = false;
      doseSync = false;
    }
    
  }

  //digitalWrite(rly1, HIGH);
  //digitalWrite(rly2, HIGH);
  //digitalWrite(analog, HIGH);
  //digitalWrite(LED_BUILTIN, HIGH);  // turn the LED on (HIGH is the voltage level)
  //delay(1000);                      // wait for a second
  //digitalWrite(LED_BUILTIN, LOW);
  //digitalWrite(rly1, LOW);
  //digitalWrite(rly2, LOW);
  //delay (1000);
  // put your main code here, to run repeatedly:

}
