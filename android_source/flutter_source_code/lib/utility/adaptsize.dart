import 'package:flutter/material.dart';

class AdaptiveSize {
  double pixPreferredWidth = 428;
  double pixPreferredHeight = 926;
  Size? deviceSize;
  AdaptiveSize({required Size this.deviceSize});
  double adaptWidth({required double desiredSize}) {
    return (deviceSize!.width / pixPreferredWidth) * desiredSize;
  }

  double adaptHeight({required double desiredSide}) {
    return (deviceSize!.height / pixPreferredHeight) * desiredSide;
  }
}
