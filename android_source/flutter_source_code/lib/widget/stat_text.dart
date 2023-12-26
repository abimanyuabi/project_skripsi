import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/default_text.dart';
import 'package:flutter_source_code/widget/text_field.dart';

Widget statTextBox1(
    {required String parameterText,
    required String parameterValue,
    required String parameterScale,
    required AdaptiveSize adaptiveSize,
    required TextEditingController textEditingController,
    required ValueNotifier<DateTime?> pickedDate,
    required BuildContext context,
    required bool datePickerAttachment,
    int? maxValue}) {
  return SizedBox(
    width: adaptiveSize.adaptWidth(desiredSize: 320),
    height: adaptiveSize.adaptHeight(desiredSize: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        headingText2(text: parameterText, adaptiveSize: adaptiveSize),
        const Spacer(),
        SizedBox(
          width: adaptiveSize.adaptWidth(desiredSize: 120),
          height: adaptiveSize.adaptHeight(desiredSize: 24),
          child: defaultTextField(
              maxValue: maxValue,
              adaptiveSize: adaptiveSize,
              textEditingController: textEditingController,
              fieldSuffix: parameterScale),
        ),
      ],
    ),
  );
}
