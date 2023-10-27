class DebugModeModel {
  late bool ledChannelRedStrength;
  late bool ledChannelGreenStrength;
  late bool ledChannelBlueStrength;
  late bool ledChannelWhiteStrength;
  late bool ledFanStrength;
  late int alkalinityDosingPumpAmount;
  late int calciumDosingPumpAmount;
  late int magnesiumDosingPumpAmount;
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
      required this.alkalinityDosingPumpAmount,
      required this.calciumDosingPumpAmount,
      required this.magnesiumDosingPumpAmount,
      required this.topUpPumpFlag,
      required this.returnPumpFlag,
      required this.wavePumpLeftFlag,
      required this.wavePumpRightFlag,
      required this.debugModeFlag});
  void debugModeSetter(bool debugFlag) {
    debugModeFlag = debugFlag;
  }

  bool debugModeGetter() {
    return debugModeFlag;
  }
}

DebugModeModel debugModelDummy() {
  return DebugModeModel(
      ledChannelRedStrength: true,
      ledChannelGreenStrength: true,
      ledChannelBlueStrength: true,
      ledChannelWhiteStrength: true,
      ledFanStrength: true,
      alkalinityDosingPumpAmount: 2,
      calciumDosingPumpAmount: 2,
      magnesiumDosingPumpAmount: 1,
      topUpPumpFlag: true,
      returnPumpFlag: true,
      wavePumpLeftFlag: true,
      wavePumpRightFlag: true,
      debugModeFlag: false);
}
