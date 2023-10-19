import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/default_text.dart';

Widget defaultButton(
    {required String buttonText,
    required void Function() actionFunc,
    required double prefButtonWidth,
    required double prefButtonHeight,
    required AdaptiveSize adaptiveSize,
    Color? textColor,
    Color? buttonColor,
    Color? buttonBorderSideColor,
    double? buttonEdgeRadius}) {
  return SizedBox(
    width: prefButtonWidth,
    height: prefButtonHeight,
    child: ElevatedButton(
      onPressed: actionFunc,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.zero,
        ),
        backgroundColor:
            MaterialStateProperty.all<Color>(buttonColor ?? Colors.blueAccent),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonEdgeRadius ?? 4),
            side: BorderSide(
                color:
                    buttonBorderSideColor ?? buttonColor ?? Colors.blueAccent),
          ),
        ),
      ),
      child: defButtonText(
          text: buttonText, adaptiveSize: adaptiveSize, textColor: textColor),
    ),
  );
}
