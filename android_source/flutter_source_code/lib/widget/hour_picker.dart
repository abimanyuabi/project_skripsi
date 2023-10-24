import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/default_text.dart';

Widget customHourPicker(
    {required ValueNotifier<int> hourValue,
    required AdaptiveSize adaptiveSize,
    double? pickerWidth,
    double? pickerHeight,
    Color? pickerColor}) {
  return SizedBox(
    width: adaptiveSize.adaptWidth(desiredSize: 62),
    height: adaptiveSize.adaptHeight(desiredSize: 56),
    child: Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              width: adaptiveSize.adaptWidth(desiredSize: 2),
              color: Colors.grey)),
      child: ValueListenableBuilder(
        valueListenable: hourValue,
        builder: ((context, value, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                headingText2(
                    text: value.toString(), adaptiveSize: adaptiveSize),
                SizedBox(
                  width: adaptiveSize.adaptWidth(desiredSize: 24),
                  height: adaptiveSize.adaptHeight(desiredSize: 54),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: adaptiveSize.adaptHeight(desiredSize: 24),
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () => hourValue.value >= 23
                              ? hourValue.value = 0
                              : hourValue.value = hourValue.value + 1,
                          icon: Icon(Icons.arrow_drop_up),
                          iconSize: adaptiveSize.adaptWidth(desiredSize: 24),
                        ),
                      ),
                      SizedBox(
                        height: adaptiveSize.adaptHeight(desiredSize: 24),
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () => hourValue.value == 0
                              ? hourValue.value = 23
                              : hourValue.value = hourValue.value - 1,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: adaptiveSize.adaptWidth(desiredSize: 24),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    ),
  );
}
