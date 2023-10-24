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

class ParameterModel {
  late SensorModel sensorModel;
  late WaterChemistryModel waterChemistryModel;
  ParameterModel(
      {required this.sensorModel, required this.waterChemistryModel});
}
