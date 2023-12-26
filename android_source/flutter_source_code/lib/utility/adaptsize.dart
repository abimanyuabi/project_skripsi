import 'package:flutter/material.dart';

class AdaptiveSize {
  double pixPreferredWidth = 428;
  double pixPreferredHeight = 926;
  late Size deviceSize;
  AdaptiveSize({required this.deviceSize});
  double adaptWidth({required double desiredSize}) {
    return (deviceSize.width / pixPreferredWidth) * desiredSize;
  }

  double adaptHeight({required double desiredSize}) {
    return (deviceSize.height / pixPreferredHeight) * desiredSize;
  }

  double currHeight() {
    return deviceSize.height;
  }

  double currWidth() {
    return deviceSize.width;
  }
}
