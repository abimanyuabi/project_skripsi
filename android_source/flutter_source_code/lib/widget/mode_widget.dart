import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/utility/image_circle.dart';
import 'package:flutter_source_code/widget/default_text.dart';

Widget modeWidget({
  required AdaptiveSize adaptSize,
  required ImageProvider imageProv,
  required String modeName,
  String? modeBodyText,
  required Widget actionButton1,
  required actionButton2,
  Widget? actionButton3,
  double? prefWidth,
  double? prefHeight,
  double? prefTextBodyWidth,
  double? prefTextBodyHeight,
}) {
  return SizedBox(
    width: adaptSize.adaptWidth(desiredSize: prefWidth ?? 340),
    height: adaptSize.adaptHeight(desiredSize: prefHeight ?? 132),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        pngToCircleImage(
          imageProv: imageProv,
          diameter: adaptSize.adaptWidth(desiredSize: 132),
        ),
        Padding(
          padding: EdgeInsets.only(left: adaptSize.adaptWidth(desiredSize: 20)),
          child: SizedBox(
            width: adaptSize.adaptWidth(desiredSize: prefTextBodyWidth ?? 168),
            height:
                adaptSize.adaptHeight(desiredSize: prefTextBodyHeight ?? 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                headingText1(text: modeName, adaptiveSize: adaptSize),
                bodyText2(text: modeBodyText ?? "-", adaptiveSize: adaptSize),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    actionButton1,
                    const Divider(),
                    actionButton2,
                    actionButton3 ??
                        SizedBox(
                          width: 1,
                          height: 1,
                        ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    ),
  );
}
