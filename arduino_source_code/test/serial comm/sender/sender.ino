const int arraySize = 5; // Size of the array
int myArray[arraySize] = {10, 20, 30, 40, 50}; // Sample array data
const int baudRate = 9600; // Set the baud rate

void setup() {
  Serial.begin(baudRate); // Initialize Serial communication
}

void loop() {
  // Send the array data
  for (int i = 0; i < arraySize; i++) {
    Serial.print(myArray[i]);
    Serial.print(",");
  }
  Serial.println(); // Add a newline character at the end
  delay(1000); // Delay before sending the next array
}