import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/default_text.dart';

Widget defGridPicker({
  required AdaptiveSize adaptiveSize,
  required int maxItem,
  required int itemBaseNumber,
  required ValueNotifier<int> pickerListenableValue,
  required int crossAxisCounts,
  int? buttonWidth,
  int? buttonHeight,
  int? itemRowCount,
}) {
  return SizedBox(
    height: adaptiveSize.adaptHeight(desiredSize: 210),
    width: adaptiveSize.adaptHeight(desiredSize: 320),
    child: GridView.builder(
      itemCount: maxItem,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.8,
          crossAxisSpacing: adaptiveSize.adaptWidth(desiredSize: 20),
          mainAxisSpacing: adaptiveSize.adaptHeight(desiredSize: 20),
          crossAxisCount: crossAxisCounts),
      itemBuilder: ((context, index) {
        int divider = itemBaseNumber * ((index + 1) * 2);
        return ValueListenableBuilder(
          valueListenable: pickerListenableValue,
          builder: (context, value, child) => InkWell(
            onTap: () => pickerListenableValue.value = divider,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value == divider ? Colors.blue : Colors.grey,
                  width: adaptiveSize.adaptWidth(desiredSize: 2),
                ),
              ),
              child: headingText2(text: '$divider', adaptiveSize: adaptiveSize),
            ),
          ),
        );
      }),
    ),
  );
}
