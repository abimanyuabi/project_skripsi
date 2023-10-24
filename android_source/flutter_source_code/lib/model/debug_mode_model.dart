class DebugModeModel {
  late int ledChannelRedStrength;
  late int ledChannelGreenStrength;
  late int ledChannelBlueStrength;
  late int ledChannelWhiteStrength;
  late int ledFanStrength;
  late int alkalinityDosingPumpFlag;
  late int calciumDosingPumpFlag;
  late int magnesiumDosingPumpFlag;
  late bool topUpPumpFlag;
  late bool returnPumpFlag;
  late bool wavePumpLeftFlag;
  late bool wavePumpRightFlag;
  late bool debugModeFlag;
  DebugModeModel(
      {required this.ledChannelRedStrength,
      required this.ledChannelGreenStrength,
      required this.ledChannelBlueStrength,
      required this.ledChannelWhiteStrength,
      required this.ledFanStrength,
      required this.alkalinityDosingPumpFlag,
      required this.calciumDosingPumpFlag,
      required this.magnesiumDosingPumpFlag,
      required this.topUpPumpFlag,
      required this.returnPumpFlag,
      required this.wavePumpLeftFlag,
      required this.wavePumpRightFlag,
      required this.debugModeFlag});
}
