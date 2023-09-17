
const int arraySize = 5; // Size of the array
int receivedArray[arraySize]; // To store received array data
const int baudRate = 9600; // Set the baud rate

void setup() {
  Serial.begin(baudRate); // Initialize Serial communication
}

void loop() {
  if (Serial.available()) {
    // Read the incoming data and populate the array
    for (int i = 0; i < arraySize; i++) {
      receivedArray[i] = Serial.parseInt();
      Serial.read(); // Read the comma separator
    }

    // Process the received array data
    for (int i = 0; i < arraySize; i++) {
      Serial.print("Received value at index ");
      Serial.print(i);
      Serial.print(": ");
      Serial.println(receivedArray[i]);
    }
  }
  delay(1000);
}