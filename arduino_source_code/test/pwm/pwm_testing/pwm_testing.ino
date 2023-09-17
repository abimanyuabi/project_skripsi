int pwmPins = 9;
void setup() {
  Serial.begin(9600);
  // put your setup code here, to run once:
  pinMode(pwmPins, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  analogWrite(pwmPins, 255);
  Serial.write("255");
  delay(2000);
  analogWrite(pwmPins, 127);
  Serial.write("127");
  delay(2000);
  analogWrite(pwmPins, 0);
  Serial.write("0");
  delay(2000);
}
