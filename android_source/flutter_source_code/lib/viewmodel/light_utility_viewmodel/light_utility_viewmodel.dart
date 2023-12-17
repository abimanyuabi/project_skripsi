import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_source_code/model/device_profile_model.dart';
import 'package:flutter_source_code/utility/enums.dart';

class LightUtilityViewModel with ChangeNotifier {
  DataCommStatus dataCommStatus = DataCommStatus.standby;
  String errCode = '-';
  late LedProfileModel currLedProfileModel;
  LedProfileModel get currLedProfileModels => currLedProfileModel;
  static String parentDataPath = "aquariums_data_prod";
  final FlutterSecureStorage flutterSecureStorageObject =
      FlutterSecureStorage();
  final firebaseRTDBObject = FirebaseDatabase.instance.ref();

  Future<void> updateLedProfile(
      {required LedProfileModel ledProfileModel}) async {
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
      } catch (e) {
        //err
      }
    }
  }

  Future<void> createLedProfile(
      {required LedProfileModel ledProfileModel}) async {
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
      } catch (e) {
        //err
      }
    }
  }
}
