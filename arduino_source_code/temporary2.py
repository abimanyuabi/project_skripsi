from datetime import datetime

now = datetime.now()

current_time = now.strftime("%H:%M:%S")
day = now.strftime("%d")
hour = now.strftime("%H")
minute = now.strftime("%M")
second = now.strftime("%S")

dataCommFlag = 1

#sensor
phReadWholeNumber = 12
phReadDecimalPoint = 2
wtrTempWholeNumber = 30
wtrTempDecimalPoint = 5
salinity = 1025
wtrUsage = 123

#device profile
arrayOfLedTimings = [1,5,3,4] #(Sunrise, Peak, Sunset, Night)
arrayOfLedTimingsMultiplier = [5,2,3,4] #(Sunrise, Peak, Sunset, Night)
arrayOfLedBaseStrength = [1, 2, 3, 5,] #(RGBW)
arrayOfDosage = [1,2,3] #(in ml)
doseDivider = 2
deviceMode = 2
waveformMode = 3

arrayOfSensorData =[0,0,0,0,0,0,0,0,0,0,0]
arrayOfDeviceProfile = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]


def commsArrayCompose(dataCommFlags):
    if dataCommFlags==1 or dataCommFlags ==2:
        for i in range(len(arrayOfSensorData)):
        #arrayOfSensorData assignment
            if i ==0:
                #assignment of array role flag
                arrayOfSensorData[i] = dataCommFlags
            elif i == 1:
                arrayOfSensorData[i] = int(day)
            elif i == 2:
                arrayOfSensorData[i] = int(hour)
            elif i == 3:
                arrayOfSensorData[i] = int(minute)
            elif i == 4:
                arrayOfSensorData[i] = int(second)
            elif i == 5:
                arrayOfSensorData[i] = int(phReadWholeNumber)
            elif i == 6:
                arrayOfSensorData[i] = int(phReadDecimalPoint)
            elif i == 7:
                arrayOfSensorData[i] = int(wtrTempWholeNumber)
            elif i == 8:
                arrayOfSensorData[i] = int(wtrTempDecimalPoint)
            elif i == 9:
                arrayOfSensorData[i] = int(salinity)
            elif i == 10:
                arrayOfSensorData[i] = int(wtrUsage)
    elif dataCommFlags==3 or dataCommFlags ==4:
        #arrayOfDeviceProfile assignment
        for x in range(len(arrayOfDeviceProfile)):
            if x == 0:
                #assignment of array role flag
                arrayOfDeviceProfile[x] = dataCommFlags
            elif x == 1 :
                arrayOfDeviceProfile[x]  = int(day)
            elif x == 2 :
                arrayOfDeviceProfile[x]  = int(hour)
            elif x == 3 :
                arrayOfDeviceProfile[x]  = int(minute)
            elif x == 4 :
                arrayOfDeviceProfile[x]  = int(second)
            elif x ==5 :
                for r in range(len(arrayOfLedTimings)):
                    print(arrayOfLedTimings[r])
                    arrayOfDeviceProfile[x+r] = arrayOfLedTimings[r]
            elif x == 9  :
                for s in range(len(arrayOfLedTimingsMultiplier)):
                    arrayOfDeviceProfile[x+s]=arrayOfLedTimingsMultiplier[s]
            elif x == 13 :
                for t in range(len(arrayOfLedBaseStrength)):
                    arrayOfDeviceProfile[x+t] = arrayOfLedBaseStrength[t]
            elif x >= 17 or x <= 19:
                for u in range(len(arrayOfDosage)):
                    arrayOfDeviceProfile[x] = arrayOfDosage[u]
            elif x == 20:
                arrayOfDeviceProfile[x] = doseDivider
            elif x == 21:
                arrayOfDeviceProfile[x] = deviceMode
            elif x == 22:
                arrayOfDeviceProfile[x] = waveformMode

print(arrayOfSensorData)
print(arrayOfDeviceProfile)

commsArrayCompose(dataCommFlag)
commsArrayCompose(3)

print(arrayOfSensorData)
print(arrayOfDeviceProfile)
#for a in range(len(arrayOfSensorData)):
#    print(str(a) +" : " + str(arrayOfSensorData[a]))
#print("--------")
#for b in range(len(arrayOfDeviceProfile)):
#    print(str(b)+" : " +str(arrayOfDeviceProfile[b]))
            