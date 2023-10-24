import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/default_text.dart';

Widget defaultSlider(
    {required ValueNotifier<int> sliderValue,
    required AdaptiveSize adaptiveSize,
    String? sliderName,
    double? maxValue}) {
  return SizedBox(
    width: adaptiveSize.adaptWidth(desiredSize: 300),
    height: adaptiveSize.adaptHeight(desiredSize: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        headingText2(text: sliderName ?? "", adaptiveSize: adaptiveSize),
        SizedBox(
            width: adaptiveSize.adaptHeight(desiredSize: 200),
            height: adaptiveSize.adaptHeight(desiredSize: 12),
            child: ValueListenableBuilder(
              valueListenable: sliderValue,
              builder: (context, listenableVal, child) => SliderTheme(
                data: SliderThemeData(
                    trackHeight: adaptiveSize.adaptHeight(desiredSize: 1),
                    activeTrackColor: Color.fromARGB(200, 112, 112, 112),
                    inactiveTrackColor: Color.fromARGB(125, 112, 112, 112),
                    thumbColor: Colors.grey,
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius:
                            adaptiveSize.adaptWidth(desiredSize: 8))),
                child: Slider(
                  value: listenableVal.toDouble(),
                  max: maxValue ?? 255,
                  onChanged: ((sliderVal) =>
                      sliderValue.value = sliderVal.toInt()),
                ),
              ),
            )),
        SizedBox(
          width: adaptiveSize.adaptHeight(desiredSize: 36),
          height: adaptiveSize.adaptHeight(desiredSize: 20),
          child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    width: adaptiveSize.adaptWidth(desiredSize: 2),
                    color: Colors.grey)),
            child: Padding(
              padding: EdgeInsets.only(
                  left: adaptiveSize.adaptWidth(desiredSize: 2)),
              child: ValueListenableBuilder(
                valueListenable: sliderValue,
                builder: ((context, value, child) => bodyText1(
                      text: value.toString(),
                      adaptiveSize: adaptiveSize,
                      fontWeight: FontWeight.w500,
                      textColor: Color.fromARGB(255, 112, 112, 112),
                    )),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
