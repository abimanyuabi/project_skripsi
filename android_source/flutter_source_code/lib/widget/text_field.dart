import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';

Widget defaultTextField({
  required AdaptiveSize adaptiveSize,
  required TextEditingController textEditingController,
  String? fieldName,
  String? fieldSuffix,
  int? maxLength,
}) {
  return SizedBox(
    width: adaptiveSize.adaptWidth(desiredSize: 120),
    child: TextFormField(
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength ?? 5)],
      controller: textEditingController,
      maxLength: maxLength,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: fieldName, hintText: "999", suffixText: fieldSuffix),
    ),
  );
}
