import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_source_code/model/sensor_model.dart';
import 'package:flutter_source_code/utility/enums.dart';

class ParameterViewModel with ChangeNotifier {
  DataCommStatus _dataCommStatus = DataCommStatus.standby;
  String errMessege = '-';
  final flutterSecureStorageObject = FlutterSecureStorage();
  late List<SensorModel> sensorModel;
  List<SensorModel> get sensorModels => sensorModel;
  late List<WaterChemistryModel> waterChemistryModel;
  List<WaterChemistryModel> get waterChemistryModels => waterChemistryModel;
  final firebaseRTDBObject = FirebaseDatabase.instance.ref();
  String parentDataPath = "aquariums_data_prod";

  void resetCommStatus() {
    _dataCommStatus = DataCommStatus.standby;
    errMessege = '-';
  }

  Future<void> fetchSensorData() async {
    _dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    //ensure there is user exist currently
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      await firebaseRTDBObject
          .child("$parentDataPath/$currUser/water_parameters/waterChemistry");
    } else {
      _dataCommStatus = DataCommStatus.failed;
      errMessege = "no user exist";
    }
  }

  Future<void> writeWaterChemistryData(
      {required DateTime dateTime,
      required double alkalinityReading,
      required int calciumReading,
      required int magnesiumReading}) async {
    _dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");

    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/water_parameters/waterChemistry")
            .set({
          "date":
              "${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}-${dateTime.minute}",
          "alkalinity_reading": alkalinityReading,
          "calcium_reading": calciumReading,
          "magnesium_reading": magnesiumReading
        });
        _dataCommStatus = DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        _dataCommStatus = DataCommStatus.failed;
        errMessege = e.toString();
        notifyListeners();
      }
    }
  }
}
