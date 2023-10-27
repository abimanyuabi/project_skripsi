import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/default_text.dart';

Widget customPicker(
    {required ValueNotifier<int> notifyableValue,
    required AdaptiveSize adaptiveSize,
    required num maxValue,
    double? pickerWidth,
    double? pickerHeight,
    Color? pickerColor,
    String? pickerSuffix}) {
  return SizedBox(
    width: adaptiveSize.adaptWidth(desiredSize: 66),
    height: adaptiveSize.adaptHeight(desiredSize: 38),
    child: Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              width: adaptiveSize.adaptWidth(desiredSize: 2),
              color: Colors.grey)),
      child: ValueListenableBuilder(
        valueListenable: notifyableValue,
        builder: ((context, value, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                headingText2(
                    text: pickerSuffix == null
                        ? value.toString()
                        : value.toString() + pickerSuffix,
                    adaptiveSize: adaptiveSize),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: adaptiveSize.adaptHeight(desiredSize: 8)),
                  child: SizedBox(
                    width: adaptiveSize.adaptWidth(desiredSize: 18),
                    height: adaptiveSize.adaptHeight(desiredSize: 36),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: adaptiveSize.adaptHeight(desiredSize: 12),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () => value >= maxValue
                                ? notifyableValue.value = 0
                                : notifyableValue.value =
                                    notifyableValue.value + 1,
                            icon: Icon(Icons.arrow_drop_up),
                            iconSize: adaptiveSize.adaptWidth(desiredSize: 22),
                          ),
                        ),
                        SizedBox(
                          height: adaptiveSize.adaptHeight(desiredSize: 12),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () => value == 0
                                ? notifyableValue.value = maxValue.toInt()
                                : notifyableValue.value =
                                    notifyableValue.value - 1,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: adaptiveSize.adaptWidth(desiredSize: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    ),
  );
}
