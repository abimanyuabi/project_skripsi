import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_source_code/model/device_profile_model.dart';
import 'package:flutter_source_code/utility/enums.dart';

class DosingProfileViewModel with ChangeNotifier {
  DataCommStatus dataCommStatus = DataCommStatus.standby;
  String errMessege = '-';
  DosingProfileModel dosingProfileModel = DosingProfileModel(
      doseDivider: 4,
      alkalinityDosage: 1,
      calciumDosage: 1,
      magnesiumDosage: 1);
  DosingProfileModel get dosingProfileModels => dosingProfileModel;

  List<DosingProfileModel> listOfDosingHistory = [];
  List<DosingProfileModel> get listOfDosingHistorys => listOfDosingHistory;

  final flutterSecureStorageObject = const FlutterSecureStorage();
  final firebaseRTDBObject = FirebaseDatabase.instance.ref();
  final firebaseFirestoreObject = FirebaseFirestore.instance;
  String parentDataPath = "aquariums_data_prod";
  String dosingLogDataPath = "dosing_log";

  void resetDataCommStatus() {
    dataCommStatus = DataCommStatus.standby;
    errMessege = "-";
    notifyListeners();
  }

  Future<void> getDosingLog() async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    try {
      final response = await firebaseFirestoreObject
          .collection(dosingLogDataPath)
          .where("userid", isEqualTo: currUser)
          .orderBy("timestamp", descending: true)
          .limit(10)
          .get();
      List<DosingProfileModel> placeholder = [];

      for (var element in response.docs) {
        placeholder.add(dosingProfileFromMap(maps: element));
      }
      listOfDosingHistory = placeholder;
      dataCommStatus = DataCommStatus.success;
      notifyListeners();
    } catch (e) {
      errMessege = e.toString();
      dataCommStatus = DataCommStatus.failed;
      notifyListeners();
    }
  }

  Future<void> updateIsNewDataDeviceProfile() async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    try {
      await firebaseRTDBObject
          .child("$parentDataPath/$currUser/is_new_data/")
          .update({"device_profile": true});
      dataCommStatus = DataCommStatus.success;
      notifyListeners();
    } catch (e) {
      errMessege = e.toString();
      dataCommStatus = DataCommStatus.failed;
      notifyListeners();
    }
  }

  Future<void> writeDosingProfile(
      {required DosingProfileModel inpDosingProfileModel}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/dosing_profile")
            .set({
          "13": inpDosingProfileModel.alkalinityDosage,
          "14": inpDosingProfileModel.calciumDosage,
          "15": inpDosingProfileModel.magnesiumDosage,
          "16": inpDosingProfileModel.doseDivider
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
      {required DosingProfileModel inpDosingProfileModel}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/dosing_profile")
            .update({
          "13": inpDosingProfileModel.alkalinityDosage,
          "14": inpDosingProfileModel.calciumDosage,
          "15": inpDosingProfileModel.magnesiumDosage,
          "16": inpDosingProfileModel.doseDivider
        });
        try {
          await firebaseFirestoreObject
              .collection(dosingLogDataPath)
              .doc()
              .set({
            "userid": currUser,
            "alkalinity": inpDosingProfileModel.alkalinityDosage,
            "calcium": inpDosingProfileModel.calciumDosage,
            "magnesium": inpDosingProfileModel.magnesiumDosage,
            "divider": inpDosingProfileModel.doseDivider,
            "timestamp": Timestamp.now()
          });
          getDosingLog();
        } catch (e) {
          errMessege = e.toString();
        }
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
