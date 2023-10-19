import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/default_text.dart';

Widget statText1(
    {required String parameterText,
    required String parameterValue,
    required String parameterScale,
    required AdaptiveSize adaptiveSize}) {
  return SizedBox(
    width: adaptiveSize.adaptWidth(desiredSize: 160),
    height: adaptiveSize.adaptHeight(desiredSize: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        headingText2(text: parameterText, adaptiveSize: adaptiveSize),
        SizedBox(
          width: adaptiveSize.adaptWidth(desiredSize: 68),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey,
                    width: adaptiveSize.adaptWidth(desiredSize: 2)),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: adaptiveSize.adaptWidth(desiredSize: 2),
                  ),
                  child: bodyText1(
                      text: parameterValue,
                      adaptiveSize: adaptiveSize,
                      fontWeight: FontWeight.w300,
                      textColor: Colors.blue),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: adaptiveSize.adaptWidth(desiredSize: 2),
                  ),
                  child: bodyText1(
                      text: parameterScale,
                      adaptiveSize: adaptiveSize,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
