int rly1 = 4;
int rly2 = 16;

void setup() {
  // put your setup code here, to run once:
  //pinMode(rly1, OUTPUT);
  pinMode(rly2, OUTPUT);
   pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  //digitalWrite(rly1, HIGH);
  digitalWrite(rly2, HIGH);
  digitalWrite(LED_BUILTIN, HIGH);  // turn the LED on (HIGH is the voltage level)
  delay(1000);                      // wait for a second
  digitalWrite(LED_BUILTIN, LOW);
  //digitalWrite(rly1, LOW);
  digitalWrite(rly2, LOW);
  delay (1000);
  // put your main code here, to run repeatedly:

}
