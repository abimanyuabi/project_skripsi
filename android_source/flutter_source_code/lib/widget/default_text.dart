import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';

Widget headingText1(
    {required String text,
    required AdaptiveSize adaptiveSize,
    Color? textColor}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: adaptiveSize.adaptWidth(desiredSize: 18),
        color: textColor ?? Colors.black,
        fontWeight: FontWeight.w500),
  );
}

Widget headingText2(
    {required String text,
    required AdaptiveSize adaptiveSize,
    Color? textColor}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: adaptiveSize.adaptWidth(desiredSize: 16),
        color: textColor ?? Colors.black,
        fontWeight: FontWeight.w400),
  );
}

Widget bodyText1(
    {required String text,
    required AdaptiveSize adaptiveSize,
    Color? textColor,
    FontWeight? fontWeight}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: adaptiveSize.adaptWidth(desiredSize: 14),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.w200),
  );
}

Widget bodyText2(
    {required String text,
    required AdaptiveSize adaptiveSize,
    Color? textColor}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: adaptiveSize.adaptWidth(desiredSize: 12),
        color: textColor ?? Colors.black,
        fontWeight: FontWeight.w200),
  );
}

Widget defButtonText(
    {required String text,
    required AdaptiveSize adaptiveSize,
    Color? textColor}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: adaptiveSize.adaptWidth(desiredSize: 12),
        color: textColor ?? Colors.black,
        fontWeight: FontWeight.w400),
  );
}
