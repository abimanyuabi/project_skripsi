class DeviceProfileModel {
  late LedProfileModel ledProfile;
  late DosingProfileModel dosingProfile;
  late DeviceMode deviceMode;
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

class DosingProfileModel {
  late int doseDivider;
  late double alkalinityDosage;
  late double calciumDosage;
  late double magnesiumDosage;
  DosingProfileModel(
      {required this.doseDivider,
      required this.alkalinityDosage,
      required this.calciumDosage,
      required this.magnesiumDosage});
}

class DeviceMode {
  late int deviceMode;
  late int waveFormMode;
  DeviceMode({required this.deviceMode, required this.waveFormMode});
}
