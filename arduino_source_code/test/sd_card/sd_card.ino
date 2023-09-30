#include <SPI.h>
#include <SD.h>

File sensorLogging;
File deviceProfileFile;

bool sdStatus = false;
int sensorData[8]= {1,2,3,4,5,6,7,8};
int deviceData[18]= {12,1,1,1,3,1,1,1,4,1,1,1,6,1,1,1,1,7};
bool recordStatus = false;
int cycle = 0;

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  
  Serial.print("Initializing SD card...");

  if (!SD.begin(10)) {
    Serial.println("initialization failed!");
    sdStatus = false;
  }
  Serial.println("initialization done.");
}

void loop() {
  // nothing happens after setup
  cycle = cycle+1;
  if(cycle ==5){
    //readSensorLog();
    //readDeviceProfileFile();
    readArrayTest();
  }
  if(sdStatus == false){
    if (!SD.begin(10)) {
      Serial.println("initialization failed!");
      sdStatus = false;
    }else{
      sdStatus = true;
    }
  }

  if(recordStatus == true && sdStatus == true){
    //recordDeviceProfileData();
    testWrite();
    recordStatus = false;
  }
  
  if(cycle == 10){
    cycle = 0;
    recordStatus = true;
  }
  delay(1000);
}

void recordSensorDataToSD(){
  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  // if the file opened okay, write to it:
  for(int x = 0; x<8; x++){
    sensorLogging = SD.open("senlog.txt", FILE_WRITE);
    if (sensorLogging) {
      Serial.print("Writing to sensorLogging.txt...");
      sensorLogging.println(sensorData[x]);
      // close the file:
      sensorLogging.close();
      Serial.println("done.");
    } else {
      // if the file didn't open, print an error:
      Serial.println("error opening sensorLog.txt");
    }
  }
}
void checkFileExist(){
  if (SD.exists("devProf.txt")) {

    Serial.println("example.txt exists.");

  } else {

    Serial.println("example.txt doesn't exist.");

  }
}
bool recordDeviceProfileData(){
  bool writeStat = true;
  //overwrite any existing devprof file
  if(SD.remove("devProf.txt")){
    Serial.println("delete existing file");
  }
  
  for(int x = 0; x<18; x++){
    deviceProfileFile = SD.open("devProf.txt", FILE_WRITE);
    if(deviceProfileFile){
      deviceProfileFile.println(deviceData[x]);
      deviceProfileFile.close();
    }else{
      writeStat = false;
      Serial.println("fail to open file");
    }
  }
  return writeStat;
}
void readDeviceProfileFile(){
  deviceProfileFile = SD.open("devProf.txt", FILE_READ);
  char idk[18];
  int counter = 0;
  if(deviceProfileFile){
    while (deviceProfileFile.available()) {
      char retrievedChar = deviceProfileFile.read();
      idk[counter] = retrievedChar;
      counter = counter +1;
    }
    deviceProfileFile.close();
  }else{
    Serial.println("cant open the file");
  }
  Serial.println(counter);
  for(int t = 0; t<54; t++){
    Serial.print(String(idk[t]) + String(t));
  }
}

void readSensorLog(){
  sensorLogging = SD.open("senlog.txt");
  if (sensorLogging) {
    while (sensorLogging.available()) {
      char character = sensorLogging.read(); // Read one character from the file

      // Print the character to the Serial Monitor
      Serial.print(character);

      // You can perform further processing with the character here
    }

    sensorLogging.close(); // Close the file when done
  } else {
    Serial.println("Error opening file for reading");
  }
}

void readDevice(){
  // re-open the file for reading:
  deviceProfileFile = SD.open("deviceProfile.txt");
  if (deviceProfileFile) {
    Serial.println("deviceProfile.txt:");

    // read from the file until there's nothing else in it:
    while (deviceProfileFile.available()) {
      Serial.write(deviceProfileFile.read());
    }
    // close the file:
    deviceProfileFile.close();
  } else {
    // if the file didn't open, print an error:
    Serial.println("error opening test.txt");
  }
}

void testWrite(){
  SD.remove("testfile.txt");
  File dataFile ;
  int arraySize = 10;
  dataFile = SD.open("testfile.txt", FILE_WRITE);
  if (dataFile) {
    int dataArray[arraySize] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

    // Write the array elements to the file
    for (int i = 0; i < arraySize; i++) {
      dataFile.print(dataArray[i]);
      if (i < arraySize - 1) {
        dataFile.print(","); // Add a comma between values
      }
    }

    dataFile.close();
    Serial.println("Data written to file.");
  } else {
    Serial.println("Error opening file for writing");
  }
}
void readArrayTest(){
  int arraySize = 10;
  File dataFile = SD.open("testfile.txt");

  if (dataFile) {
    String data = dataFile.readStringUntil('\n');
    dataFile.close();

    // Parse the string into an array
    int dataArray[arraySize];
    int index = 0;
    char* token = strtok(const_cast<char*>(data.c_str()), ",");
    while (token != NULL) {
      dataArray[index] = atoi(token);
      index++;
      token = strtok(NULL, ",");
    }

    // Print the array values
    for (int i = 0; i < arraySize; i++) {
      Serial.print(dataArray[i]);
      Serial.print(" ");
    }
    Serial.println();
  } else {
    Serial.println("Error opening file for reading");
  }
}


