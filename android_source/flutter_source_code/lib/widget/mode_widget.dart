import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/utility/image_circle.dart';

Widget modeWidget(
    {required AdaptiveSize adaptSize,
    required ImageProvider imageProv,
    double? prefWidth,
    double? prefHeight}) {
  return SizedBox(
    width: adaptSize.adaptWidth(desiredSize: prefWidth ?? 300),
    height: adaptSize.adaptHeight(desiredSide: prefHeight ?? 132),
    child: Row(
      children: [
        pngToCircleImage(
          imageProv: imageProv,
          diameter: adaptSize.adaptWidth(desiredSize: 132),
        )
      ],
    ),
  );
}
