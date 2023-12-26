import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_source_code/model/device_profile_model.dart';
import 'package:flutter_source_code/utility/enums.dart';

class LightUtilityViewModel with ChangeNotifier {
  DataCommStatus dataCommStatus = DataCommStatus.standby;
  String errMessege = '-';
  LedProfileModel currLedProfileModel = dummyLedProfile();
  LedProfileModel get currLedProfileModels => currLedProfileModel;
  static String parentDataPath = "aquariums_data_prod";
  final FlutterSecureStorage flutterSecureStorageObject =
      const FlutterSecureStorage();
  final firebaseRTDBObject = FirebaseDatabase.instance.ref();

  void resetCommStatus() {
    dataCommStatus = DataCommStatus.standby;
    errMessege = "-";
    notifyListeners();
  }

  Future<void> updateIsNewDataDeviceProfile() async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
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
  }

  Future<void> updateLedProfile(
      {required LedProfileModel ledProfileModel}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/led_profile")
            .update({
          "1": ledProfileModel.ledTimingSunrise,
          "2": ledProfileModel.ledTimingPeak,
          "3": ledProfileModel.ledTimingSunset,
          "4": ledProfileModel.ledTimingNight,
          "5": ledProfileModel.ledTimingStrengthMultiplierSunrise,
          "6": ledProfileModel.ledTimingStrengthMultiplierPeak,
          "7": ledProfileModel.ledTimingStrengthMultiplierSunset,
          "8": ledProfileModel.ledTimingStrengthMultiplierNight,
          "9": ledProfileModel.ledChannelRedBaseStrength,
          "10": ledProfileModel.ledChannelGreenBaseStrength,
          "11": ledProfileModel.ledChannelBlueBaseStrength,
          "12": ledProfileModel.ledChannelWhiteBaseStrength,
        });
        dataCommStatus = DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        //err
        dataCommStatus = DataCommStatus.failed;
        errMessege = e.toString();
        notifyListeners();
      }
    }
  }

  Future<void> createLedProfile(
      {required LedProfileModel ledProfileModel}) async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      try {
        await firebaseRTDBObject
            .child("$parentDataPath/$currUser/led_profile")
            .set({
          "1": ledProfileModel.ledTimingSunrise,
          "2": ledProfileModel.ledTimingPeak,
          "3": ledProfileModel.ledTimingSunset,
          "4": ledProfileModel.ledTimingNight,
          "5": ledProfileModel.ledTimingStrengthMultiplierSunrise,
          "6": ledProfileModel.ledTimingStrengthMultiplierPeak,
          "7": ledProfileModel.ledTimingStrengthMultiplierSunset,
          "8": ledProfileModel.ledTimingStrengthMultiplierNight,
          "9": ledProfileModel.ledChannelRedBaseStrength,
          "10": ledProfileModel.ledChannelGreenBaseStrength,
          "11": ledProfileModel.ledChannelBlueBaseStrength,
          "12": ledProfileModel.ledChannelWhiteBaseStrength,
        });
        dataCommStatus = DataCommStatus.success;
        notifyListeners();
      } catch (e) {
        //err
        dataCommStatus = DataCommStatus.failed;
        errMessege = e.toString();
        notifyListeners();
      }
    }
  }

  Future<void> getLedProfile() async {
    dataCommStatus = DataCommStatus.loading;
    notifyListeners();
    String? currUser =
        await flutterSecureStorageObject.read(key: "curr_user_uid");
    if (currUser != null) {
      await firebaseRTDBObject
          .child("$parentDataPath/$currUser/led_profile")
          .once()
          .then((snapshot) {
        currLedProfileModel = LedProfileModel(
            ledTimingSunrise: (snapshot.snapshot.value as List)[1],
            ledTimingPeak: (snapshot.snapshot.value as List)[2],
            ledTimingSunset: (snapshot.snapshot.value as List)[3],
            ledTimingNight: (snapshot.snapshot.value as List)[4],
            ledTimingStrengthMultiplierSunrise:
                (snapshot.snapshot.value as List)[5],
            ledTimingStrengthMultiplierPeak:
                (snapshot.snapshot.value as List)[6],
            ledTimingStrengthMultiplierSunset:
                (snapshot.snapshot.value as List)[7],
            ledTimingStrengthMultiplierNight:
                (snapshot.snapshot.value as List)[8],
            ledChannelRedBaseStrength: (snapshot.snapshot.value as List)[9],
            ledChannelGreenBaseStrength: (snapshot.snapshot.value as List)[10],
            ledChannelBlueBaseStrength: (snapshot.snapshot.value as List)[11],
            ledChannelWhiteBaseStrength: (snapshot.snapshot.value as List)[12]);
      });
    }
  }
}
