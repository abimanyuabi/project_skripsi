import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceProfileModel {
  late LedProfileModel ledProfile;
  late DosingProfileModel dosingProfile;
  late DeviceModeModel deviceMode;
  DeviceProfileModel(
      {required this.ledProfile,
      required this.dosingProfile,
      required this.deviceMode});
}

class DosingTrackerModel {
  late DosingProfileModel dosingProfile;
  DateTime? dosingDate;
  DosingTrackerModel({required this.dosingProfile, required this.dosingDate});
}

class LedProfileModel {
  late int ledTimingSunrise;
  late int ledTimingPeak;
  late int ledTimingSunset;
  late int ledTimingNight;
  late int ledTimingStrengthMultiplierSunrise;
  late int ledTimingStrengthMultiplierPeak;
  late int ledTimingStrengthMultiplierSunset;
  late int ledTimingStrengthMultiplierNight;
  late int ledChannelRedBaseStrength;
  late int ledChannelGreenBaseStrength;
  late int ledChannelBlueBaseStrength;
  late int ledChannelWhiteBaseStrength;
  LedProfileModel(
      {required this.ledTimingSunrise,
      required this.ledTimingPeak,
      required this.ledTimingSunset,
      required this.ledTimingNight,
      required this.ledTimingStrengthMultiplierSunrise,
      required this.ledTimingStrengthMultiplierPeak,
      required this.ledTimingStrengthMultiplierSunset,
      required this.ledTimingStrengthMultiplierNight,
      required this.ledChannelRedBaseStrength,
      required this.ledChannelGreenBaseStrength,
      required this.ledChannelBlueBaseStrength,
      required this.ledChannelWhiteBaseStrength});
}

LedProfileModel dummyLedProfile() {
  return LedProfileModel(
      ledTimingSunrise: 1,
      ledTimingPeak: 2,
      ledTimingSunset: 3,
      ledTimingNight: 4,
      ledTimingStrengthMultiplierSunrise: 5,
      ledTimingStrengthMultiplierPeak: 6,
      ledTimingStrengthMultiplierSunset: 7,
      ledTimingStrengthMultiplierNight: 8,
      ledChannelRedBaseStrength: 9,
      ledChannelGreenBaseStrength: 1,
      ledChannelBlueBaseStrength: 2,
      ledChannelWhiteBaseStrength: 3);
}

class DosingProfileModel {
  late int doseDivider;
  late int alkalinityDosage;
  late int calciumDosage;
  late int magnesiumDosage;
  DateTime? dateTime;
  DosingProfileModel(
      {required this.doseDivider,
      required this.alkalinityDosage,
      required this.calciumDosage,
      required this.magnesiumDosage,
      this.dateTime});
}

DosingProfileModel dummyDosingProfile() {
  return DosingProfileModel(
      doseDivider: 24,
      alkalinityDosage: 1,
      calciumDosage: 10,
      magnesiumDosage: 25);
}

DosingProfileModel dosingProfileFromMap(
    {required QueryDocumentSnapshot<Map<String, dynamic>> maps}) {
  return DosingProfileModel(
      doseDivider: maps["divider"],
      alkalinityDosage: maps["alkalinity"],
      calciumDosage: maps["calcium"],
      magnesiumDosage: maps["magnesium"],
      dateTime: (maps["timestamp"] as Timestamp).toDate());
}

class DeviceModeModel {
  late int deviceMode;
  late int waveFormMode;
  DeviceModeModel({required this.deviceMode, required this.waveFormMode});
}

DeviceModeModel dummyDeviceProfile() {
  return DeviceModeModel(deviceMode: 2, waveFormMode: 1);
}
