import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_source_code/model/debug_mode_model.dart';
import 'package:flutter_source_code/utility/enums.dart';

class DebugViewModel with ChangeNotifier {
  DataCommStatus dataCommStatus = DataCommStatus.standby;
  String errMessege = '-';
  late DebugModeModel debugModeModel;
  DebugModeModel get debugModeModels => debugModeModel;
  final flutterSecureStorageObject = const FlutterSecureStorage();
  final firebaseRTDBObject = FirebaseDatabase.instance.ref();
  String parentDataPath = "aquariums_data_prod";

  Future<void> updateDebugLed(
      int redLed, int greenLed, int blueLed, int whiteLed, int fanLed) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/debug")
            .update({
          "1": redLed,
          "2": greenLed,
          "3": blueLed,
          "4": whiteLed,
          "5": fanLed,
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

  Future<void> updateDebugDosing(int alkalinityDosingPumpAmount,
      int calciumDosingPumpAmount, int magnesiumDosingPumpAmount) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/debug")
            .update({
          "6": alkalinityDosingPumpAmount,
          "7": calciumDosingPumpAmount,
          "8": magnesiumDosingPumpAmount
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

  Future<void> updateDebugPump(bool wavePumpLeftFlag, bool wavePumpRightFlag,
      bool returnPumpFlag, bool topUpPumpFlag, bool sumpFan) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/debug")
            .update({
          "9": wavePumpLeftFlag,
          "10": wavePumpRightFlag,
          "11": returnPumpFlag,
          "12": topUpPumpFlag,
          "13": sumpFan
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

  Future<void> updateDebugFlag(bool debugStatus) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/is_new_data")
            .update({"debug": debugStatus});
        dataCommStatus = DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        errMessege = e.toString();
        dataCommStatus = DataCommStatus.failed;
        notifyListeners();
      }
    }
  }
}
