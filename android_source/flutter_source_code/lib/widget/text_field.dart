import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';

Widget defaultTextField(
    {required AdaptiveSize adaptiveSize,
    required TextEditingController textEditingController,
    String? fieldName,
    String? fieldSuffix,
    int? maxValue,
    Widget? label}) {
  int maxLength = (maxValue.toString()).length;
  return SizedBox(
    width: adaptiveSize.adaptWidth(desiredSize: 120),
    child: TextFormField(
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      controller: textEditingController,
      onChanged: (value) =>
          int.parse(textEditingController.text) > (maxValue ?? 3)
              ? textEditingController.text = maxValue.toString()
              : textEditingController,
      maxLength: maxLength,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: fieldName,
          label: label,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          counterText: "",
          suffixText: fieldSuffix,
          suffixStyle: TextStyle(
              fontSize: adaptiveSize.adaptWidth(desiredSize: 10),
              fontWeight: FontWeight.w300)),
    ),
  );
}
