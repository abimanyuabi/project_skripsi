import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_source_code/model/device_profile_model.dart';
import 'package:flutter_source_code/utility/enums.dart';

class DosingProfileViewModel with ChangeNotifier {
  DataCommStatus dataCommStatus = DataCommStatus.standby;
  String errMessege = '-';
  late DosingProfileModel dosingProfileModel;
  DosingProfileModel get _dosingProfileModels => dosingProfileModel;
  static final flutterSecureStorageObject = FlutterSecureStorage();
  final firebaseRTDBObject = FirebaseDatabase.instance.ref();
  String parentDataPath = "aquariums_data_prod";

  Future<void> updateIsNewDataDeviceProfile() async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    dataCommStatus = DataCommStatus.success;
    notifyListeners();
    try {
      await firebaseRTDBObject
          .child("$parentDataPath/$currUser/is_new_data")
          .set({"device_profile": true});
      dataCommStatus = DataCommStatus.success;
      notifyListeners();
    } catch (e) {
      errMessege = e.toString();
      dataCommStatus = DataCommStatus.failed;
      notifyListeners();
    }
  }

  Future<void> writeDosingProfile(
      {required DosingProfileModel dosingProfileModel}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/dosing_profile")
            .set({
          "13": dosingProfileModel.alkalinityDosage,
          "14": dosingProfileModel.calciumDosage,
          "15": dosingProfileModel.magnesiumDosage,
          "16": dosingProfileModel.doseDivider
        });
        dataCommStatus = DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        //
        dataCommStatus = DataCommStatus.failed;
        errMessege = e.toString();
        notifyListeners();
      }
    }
  }

  Future<void> updateDosingProfile(
      {required DosingProfileModel dosingProfileModel}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/dosing_profile")
            .update({
          "13": dosingProfileModel.alkalinityDosage,
          "14": dosingProfileModel.calciumDosage,
          "15": dosingProfileModel.magnesiumDosage,
          "16": dosingProfileModel.doseDivider
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
}
