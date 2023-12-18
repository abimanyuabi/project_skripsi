import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_source_code/model/sensor_model.dart';
import 'package:flutter_source_code/utility/enums.dart';

class ParameterViewModel with ChangeNotifier {
  DataCommStatus dataCommStatus = DataCommStatus.standby;
  String errMessege = '-';
  final flutterSecureStorageObject = FlutterSecureStorage();
  late List<SensorModel> sensorModel;
  List<SensorModel> get sensorModels => sensorModel;
  late List<WaterChemistryModel> waterChemistryModel;
  List<WaterChemistryModel> get waterChemistryModels => waterChemistryModel;
  final firebaseRTDBObject = FirebaseDatabase.instance.ref();
  String parentDataPath = "aquariums_data_prod";

  void resetCommStatus() {
    dataCommStatus = DataCommStatus.standby;
    errMessege = '-';
  }

  Future<void> updateIsNewDataDeviceProfile() async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    try {
      await firebaseRTDBObject
          .child("$parentDataPath/$currUser/is_new_data")
          .set({"device_profile": true});
      dataCommStatus = DataCommStatus.success;
    } catch (e) {
      errMessege = e.toString();
      dataCommStatus = DataCommStatus.failed;
    }
  }

  Future<void> writeSensorData({required SensorModel sensorReadings}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        firebaseRTDBObject
            .child("$parentDataPath/$currUser/water_parameters/sensor_readings")
            .set({
          "1":
              "${sensorReadings.createdAt.year}-${sensorReadings.createdAt.month}-${sensorReadings.createdAt.day} ${sensorReadings.createdAt.hour}-${sensorReadings.createdAt.minute}",
          "2": sensorReadings.phReadings,
          "3": sensorReadings.tempReadings,
          "4": sensorReadings.waterUsage
        });
        dataCommStatus = DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        errMessege = e.toString();
        dataCommStatus = DataCommStatus.failed;
        notifyListeners();
      }
    }
  }

  Future<void> fetchSensorData() async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    //ensure there is user exist currently
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      await firebaseRTDBObject
          .child("$parentDataPath/$currUser/water_parameters/water_chemistry");
    } else {
      dataCommStatus = DataCommStatus.failed;
      errMessege = "no user exist";
    }
  }

  Future<void> writeWaterChemistryData(
      {required WaterChemistryModel waterChemistry}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");

    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/water_parameters/water_chemistry")
            .set({
          "date":
              "${waterChemistry.dateTime.year}-${waterChemistry.dateTime.month}-${waterChemistry.dateTime.day} ${waterChemistry.dateTime.hour}-${waterChemistry.dateTime.minute}",
          "alkalinity_reading": waterChemistry.alkalinity,
          "calcium_reading": waterChemistry.calcium,
          "magnesium_reading": waterChemistry.magnesium
        });
        dataCommStatus = DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        dataCommStatus = DataCommStatus.failed;
        errMessege = e.toString();
        notifyListeners();
      }
    }
  }

  Future<void> updateWaterChemistryData(
      {required WaterChemistryModel waterChemistry}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");

    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/water_parameters/water_chemistry")
            .update({
          "date":
              "${waterChemistry.dateTime.year}-${waterChemistry.dateTime.month}-${waterChemistry.dateTime.day} ${waterChemistry.dateTime.hour}-${waterChemistry.dateTime.minute}",
          "alkalinity_reading": waterChemistry.alkalinity,
          "calcium_reading": waterChemistry.calcium,
          "magnesium_reading": waterChemistry.magnesium
        });
        dataCommStatus = DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        dataCommStatus = DataCommStatus.failed;
        errMessege = e.toString();
        notifyListeners();
      }
    }
  }
}
