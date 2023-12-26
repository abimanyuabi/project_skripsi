import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_source_code/model/sensor_model.dart';
import 'package:flutter_source_code/service/api_service.dart';
import 'package:flutter_source_code/utility/enums.dart';

class ParameterViewModel with ChangeNotifier {
  DataCommStatus dataCommStatus = DataCommStatus.standby;
  String errMessege = '-';
  final flutterSecureStorageObject = const FlutterSecureStorage();
  List<SensorModel> listOfensorModel = [];
  List<SensorModel> get listOfensorModels => listOfensorModel;
  List<WaterChemistryModel> waterChemistryModel = [];
  List<WaterChemistryModel> get waterChemistryModels => waterChemistryModel;
  final firebaseRTDBObject = FirebaseDatabase.instance.ref();
  final firebaseFirestoreObject = FirebaseFirestore.instance;
  final String _parentDataPathRTDB = "aquariums_data_prod";
  final String _sensorCollectionPath = "sensor_record";
  final String _waterChemistryPath = "waterChemistry_record";
  bool isUserExists = false;
  String currUserId = "-";

  void resetCommStatus() {
    dataCommStatus = DataCommStatus.standby;
    errMessege = '-';
    notifyListeners();
  }

  Future<void> validateUserExist() async {
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      currUserId = currUser;
      isUserExists = true;
      notifyListeners();
    } else {
      currUserId = "-";
      isUserExists = false;
      notifyListeners();
    }
  }

  Future<void> getNewSensorDataRTDB() async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        DataSnapshot dataSnapshot = await fetchSensorData(
            firebaseRTDB: firebaseRTDBObject,
            path:
                "$_parentDataPathRTDB/$currUser/water_parameters/sensor_readings");
        dataCommStatus == DataCommStatus.success;
        dataSnapshot;
        notifyListeners();
      } catch (e) {
        errMessege = e.toString();
        dataCommStatus = DataCommStatus.failed;
      }
    }
  }

  Future<void> recordSensorLogFirestore(
      {required int ph,
      required int temp,
      required int waterConsumption}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseFirestoreObject
            .collection(_sensorCollectionPath)
            .doc()
            .set({
          "ph": ph,
          "temperature": temp,
          "water_consumption": waterConsumption,
          "userid": currUser,
          "timestamp": Timestamp.now()
        });
        dataCommStatus = DataCommStatus.success;
      } catch (e) {
        errMessege = e.toString();
        dataCommStatus = DataCommStatus.failed;
        notifyListeners();
      }
    }
  }

  Future<void> getSensorLogFirestore() async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        final response = await firebaseFirestoreObject
            .collection(_sensorCollectionPath)
            .where("userid", isEqualTo: currUser)
            .orderBy("timestamp", descending: true)
            .limit(5)
            .get();
        List<SensorModel> placeholder = [];

        try {
          for (var element in response.docs) {
            placeholder.add(sensorModelFromMap(maps: element));
          }
        } catch (e) {
          errMessege = e.toString();
        }
        listOfensorModel = placeholder;
        dataCommStatus = DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        errMessege = e.toString();
        dataCommStatus = DataCommStatus.failed;
        notifyListeners();
      }
    }
  }

  Future<void> getWaterChemistryRecord() async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        final queryResponse = await firebaseFirestoreObject
            .collection(_waterChemistryPath)
            .where("userid", isEqualTo: currUser)
            .orderBy("timestamp", descending: true)
            .limit(10)
            .get();
        List<WaterChemistryModel> placeholder = [];
        for (var element in queryResponse.docs) {
          placeholder.add(waterChemistryModelFromMap(retrievedMap: element));
        }
        waterChemistryModel = placeholder;
        notifyListeners();
        dataCommStatus == DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        errMessege = e.toString();
        dataCommStatus = DataCommStatus.failed;
        notifyListeners();
      }
    }
  }

  Future<void> recordWaterChemistryLog(
      {required WaterChemistryModel inpWaterChemistryModel}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseFirestoreObject
            .collection(_waterChemistryPath)
            .doc()
            .set({
          "alkalinity": inpWaterChemistryModel.alkalinity,
          "calcium": inpWaterChemistryModel.calcium,
          "magnesium": inpWaterChemistryModel.magnesium,
          "salinity": inpWaterChemistryModel.salinity,
          "userid": currUser,
          "timestamp": Timestamp.fromDate(inpWaterChemistryModel.dateTime),
        });
        dataCommStatus = DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        //
        errMessege = e.toString();
        dataCommStatus = DataCommStatus.failed;
        notifyListeners();
      }
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
            .child(
                "$_parentDataPathRTDB/$currUser/water_parameters/sensor_readings")
            .set({
          "1": sensorReadings.phReadings,
          "2": sensorReadings.tempReadings,
          "3": sensorReadings.waterUsage
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

  Future<void> writeWaterChemistryData(
      {required WaterChemistryModel waterChemistry}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");

    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child(
                "$_parentDataPathRTDB/$currUser/water_parameters/water_chemistry")
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
            .child(
                "$_parentDataPathRTDB/$currUser/water_parameters/water_chemistry")
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
