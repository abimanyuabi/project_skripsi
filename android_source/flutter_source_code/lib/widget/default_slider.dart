import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/default_text.dart';

Widget defaultSlider(
    {required ValueNotifier<int> sliderValue,
    required AdaptiveSize adaptiveSize,
    Widget? customText,
    String? sliderName,
    double? maxValue,
    String? suffixText}) {
  TextEditingController textEditingController = TextEditingController();
  return SizedBox(
    width: adaptiveSize.adaptWidth(desiredSize: 320),
    height: adaptiveSize.adaptHeight(desiredSize: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: customText ??
              headingText2(text: sliderName ?? "", adaptiveSize: adaptiveSize),
        ),
        SizedBox(
            width: adaptiveSize.adaptHeight(desiredSize: 170),
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
          width: adaptiveSize.adaptHeight(desiredSize: 60),
          height: adaptiveSize.adaptHeight(desiredSize: 26),
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
                  builder: ((context, value, child) {
                    textEditingController.text = value.toString();
                    int valueLength = maxValue == null
                        ? 3
                        : (maxValue.toInt()).toString().length;
                    return TextFormField(
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          counterText: "",
                          suffixText: suffixText,
                          suffixStyle: TextStyle(
                              fontSize: adaptiveSize.adaptWidth(desiredSize: 8),
                              fontWeight: FontWeight.w300)),
                      maxLength: valueLength,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: adaptiveSize.adaptWidth(desiredSize: 14),
                          fontWeight: FontWeight.w500),
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      onChanged: ((textValue) {
                        int val = int.parse(textValue);
                        val <= (maxValue ?? 255) && val > 0
                            ? sliderValue.value = val
                            : sliderValue.value = (maxValue ?? 255).toInt();
                      }),
                    );
                  })),
            ),
          ),
        )
      ],
    ),
  );
}
