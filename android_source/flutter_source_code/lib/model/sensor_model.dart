import 'package:cloud_firestore/cloud_firestore.dart';

class SensorModel {
  late double phReadings;
  late double tempReadings;
  late double waterUsage;
  late DateTime createdAt;
  SensorModel(
      {required this.phReadings,
      required this.tempReadings,
      required this.waterUsage,
      required this.createdAt});
}

SensorModel dummySensorModel() {
  return SensorModel(
      phReadings: 8.0,
      tempReadings: 29.0,
      waterUsage: 200,
      createdAt: DateTime.now());
}

SensorModel sensorModelFromMap(
    {required QueryDocumentSnapshot<Map<String, dynamic>> maps}) {
  return SensorModel(
      phReadings: (maps["ph"] / 100),
      tempReadings: (maps["temperature"] / 100),
      waterUsage: (maps["water_consumption"] * 1.0),
      createdAt: (maps["timestamp"] as Timestamp).toDate());
}

class WaterChemistryModel {
  late double alkalinity;
  late double calcium;
  late double magnesium;
  late double salinity;
  late DateTime dateTime;
  WaterChemistryModel(
      {required this.alkalinity,
      required this.calcium,
      required this.magnesium,
      required this.salinity,
      required this.dateTime});
}

WaterChemistryModel waterChemistryModelFromMap(
    {required QueryDocumentSnapshot<Map<String, dynamic>> retrievedMap}) {
  return WaterChemistryModel(
      alkalinity: retrievedMap["alkalinity"],
      calcium: retrievedMap["calcium"],
      magnesium: retrievedMap["magnesium"],
      salinity: retrievedMap["salinity"],
      dateTime: (retrievedMap["timestamp"] as Timestamp).toDate());
}

WaterChemistryModel dummyWaterChemistry() {
  return WaterChemistryModel(
      alkalinity: 8.0,
      calcium: 420,
      magnesium: 550,
      salinity: 1025,
      dateTime: DateTime.now());
}

List<SensorModel> dummySensor() {
  return [
    SensorModel(
        phReadings: 8.4,
        tempReadings: 32,
        waterUsage: 20,
        createdAt: DateTime.now()),
    SensorModel(
        phReadings: 8.2,
        tempReadings: 30,
        waterUsage: 18,
        createdAt: DateTime.parse("2023-10-25")),
  ];
}

List<WaterChemistryModel> dummyListWaterChemistry() {
  return [
    WaterChemistryModel(
      alkalinity: 8.7,
      calcium: 450,
      magnesium: 550,
      salinity: 1025,
      dateTime: DateTime.now(),
    ),
    WaterChemistryModel(
      alkalinity: 8.5,
      calcium: 420,
      magnesium: 510,
      salinity: 1025,
      dateTime: DateTime.parse("2023-10-25"),
    ),
    WaterChemistryModel(
      alkalinity: 8.5,
      calcium: 420,
      magnesium: 510,
      salinity: 1025,
      dateTime: DateTime.parse("2023-10-26"),
    ),
  ];
}
