import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_source_code/model/device_profile_model.dart';
import 'package:flutter_source_code/utility/enums.dart';

class DeviceModeViewModel with ChangeNotifier {
  DataCommStatus dataCommStatus = DataCommStatus.standby;
  String errMessege = '-';
  final flutterSecureStorageObject = const FlutterSecureStorage();
  DeviceModeModel deviceModeModel = dummyDeviceProfile();
  DeviceModeModel get deviceModeModels => deviceModeModel;
  final firebaseRTDBObject = FirebaseDatabase.instance.ref();
  String parentDataPath = "aquariums_data_prod";

  Future<void> writeDeviceMode(
      {required DeviceModeModel deviceModeModel}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/device_mode")
            .set({
          "16": deviceModeModel.deviceMode,
          "17": deviceModeModel.waveFormMode
        });
        dataCommStatus = DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        dataCommStatus = DataCommStatus.failed;
        notifyListeners();
      }
    }
  }

  Future<void> getDeviceMode() async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/device_mode")
            .once()
            .then((event) {
          deviceModeModel = DeviceModeModel(
              deviceMode: (event.snapshot.value as Map)["17"],
              waveFormMode: (event.snapshot.value as Map)["18"]);
        });
        dataCommStatus = DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        dataCommStatus = DataCommStatus.failed;
        notifyListeners();
      }
    }
  }

  Future<void> updateDeviceMode({required int deviceMode}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/device_mode")
            .update({
          "17": deviceMode,
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

  Future<void> updateWaveMode({required int waveMode}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/device_mode")
            .update({"18": waveMode});
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
