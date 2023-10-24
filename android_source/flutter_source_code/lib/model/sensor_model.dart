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

class WaterChemistryModel {
  late double alkalinity;
  late double calcium;
  late double magnesium;
  late DateTime dateTime;
  WaterChemistryModel(
      {required this.alkalinity,
      required this.calcium,
      required this.magnesium,
      required this.dateTime});
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

List<WaterChemistryModel> dummyWaterChemistry() {
  return [
    WaterChemistryModel(
      alkalinity: 8.7,
      calcium: 450,
      magnesium: 550,
      dateTime: DateTime.now(),
    ),
    WaterChemistryModel(
      alkalinity: 8.5,
      calcium: 420,
      magnesium: 510,
      dateTime: DateTime.parse("2023-10-25"),
    ),
    WaterChemistryModel(
      alkalinity: 8.5,
      calcium: 420,
      magnesium: 510,
      dateTime: DateTime.parse("2023-10-26"),
    ),
  ];
}
