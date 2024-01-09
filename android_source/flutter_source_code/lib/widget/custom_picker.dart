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
    width: adaptiveSize.adaptWidth(desiredSize: 84),
    height: adaptiveSize.adaptHeight(desiredSize: 60),
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
                Padding(
                  padding: EdgeInsets.only(
                      left: adaptiveSize.adaptWidth(desiredSize: 4)),
                  child: headingText2(
                      text: pickerSuffix == null
                          ? value.toString()
                          : value.toString() + pickerSuffix,
                      adaptiveSize: adaptiveSize),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: adaptiveSize.adaptHeight(desiredSize: 4)),
                  child: SizedBox(
                    width: adaptiveSize.adaptWidth(desiredSize: 36),
                    height: adaptiveSize.adaptHeight(desiredSize: 62),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: adaptiveSize.adaptHeight(desiredSize: 22),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () => value >= maxValue
                                ? notifyableValue.value = 0
                                : notifyableValue.value =
                                    notifyableValue.value + 1,
                            icon: const Icon(Icons.arrow_drop_up),
                            iconSize: adaptiveSize.adaptWidth(desiredSize: 30),
                          ),
                        ),
                        SizedBox(
                          height: adaptiveSize.adaptHeight(desiredSize: 22),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () => value == 0
                                ? notifyableValue.value = maxValue.toInt()
                                : notifyableValue.value =
                                    notifyableValue.value - 1,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: adaptiveSize.adaptHeight(desiredSize: 30),
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
