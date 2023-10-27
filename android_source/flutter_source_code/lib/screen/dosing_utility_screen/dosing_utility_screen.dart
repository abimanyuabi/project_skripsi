import 'package:flutter/material.dart';
import 'package:flutter_source_code/model/sensor_model.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/chart_widget.dart';
import 'package:flutter_source_code/widget/default_button.dart';
import 'package:flutter_source_code/widget/default_grid_picker.dart';
import 'package:flutter_source_code/widget/default_slider.dart';
import 'package:flutter_source_code/widget/default_text.dart';

Widget dosingUtilityScreen({
  required AdaptiveSize adaptiveSize,
  required ValueNotifier<int> alkDose,
  required ValueNotifier<int> calDose,
  required ValueNotifier<int> magDose,
  required ValueNotifier<int> doseDivider,
}) {
  return SizedBox(
    width: adaptiveSize.deviceSize.width,
    child: Column(
      children: [
        Center(
          child: SizedBox(
            width: adaptiveSize.adaptWidth(desiredSize: 360),
            height: adaptiveSize.currHeight() / 3,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.only(
                    top: adaptiveSize.adaptHeight(desiredSize: 20),
                    bottom: adaptiveSize.adaptHeight(desiredSize: 20),
                    left: adaptiveSize.adaptWidth(desiredSize: 20),
                    right: adaptiveSize.adaptWidth(desiredSize: 20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingText1(
                        text: "Dosing History", adaptiveSize: adaptiveSize),
                    Padding(
                      padding: EdgeInsets.only(
                        top: adaptiveSize.adaptHeight(desiredSize: 20),
                      ),
                      child: waterChemistryChartView(
                          arrayOfParameter: dummyWaterChemistry(),
                          chartHeight: 204),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(top: adaptiveSize.adaptHeight(desiredSize: 40)),
          child: Center(
            child: SizedBox(
              width: adaptiveSize.adaptWidth(desiredSize: 320),
              height: adaptiveSize.adaptHeight(desiredSize: 160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText1(
                      text: "Dose per Day", adaptiveSize: adaptiveSize),
                  Padding(
                    padding: EdgeInsets.only(
                      top: adaptiveSize.adaptHeight(desiredSize: 20),
                    ),
                    child: defaultSlider(
                        sliderName: "Alkalinity",
                        maxValue: 1000,
                        sliderValue: alkDose,
                        adaptiveSize: adaptiveSize,
                        suffixText: "Dkh"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: adaptiveSize.adaptHeight(desiredSize: 20),
                    ),
                    child: defaultSlider(
                        sliderName: "Calcium",
                        maxValue: 1000,
                        sliderValue: calDose,
                        adaptiveSize: adaptiveSize,
                        suffixText: "ppm"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: adaptiveSize.adaptHeight(desiredSize: 20),
                    ),
                    child: defaultSlider(
                        sliderName: "Magnesium",
                        maxValue: 1000,
                        sliderValue: magDose,
                        adaptiveSize: adaptiveSize,
                        suffixText: "ppm"),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: adaptiveSize.adaptHeight(desiredSize: 40),
              bottom: adaptiveSize.adaptHeight(desiredSize: 20)),
          child: Center(
            child: SizedBox(
              width: adaptiveSize.adaptWidth(desiredSize: 320),
              height: adaptiveSize.currHeight() / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText1(
                      text: "Dosing Divider", adaptiveSize: adaptiveSize),
                  Padding(
                    padding: EdgeInsets.only(
                      top: adaptiveSize.adaptHeight(desiredSize: 20),
                    ),
                    child: defGridPicker(
                        adaptiveSize: adaptiveSize,
                        maxItem: 16,
                        itemBaseNumber: 2,
                        pickerListenableValue: doseDivider,
                        crossAxisCounts: 4),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: adaptiveSize.adaptHeight(desiredSize: 10)),
                    child: ValueListenableBuilder(
                      valueListenable: doseDivider,
                      builder: (context, value, child) => bodyText1(
                          text:
                              'the dose will be divided by : $value times through the day(24hour)',
                          adaptiveSize: adaptiveSize),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: adaptiveSize.adaptHeight(desiredSize: 20)),
            child: actionButton(
                buttonWidth: 128,
                buttonHeight: 36,
                buttonText: "Save Settings",
                actionFunc: () {},
                adaptiveSize: adaptiveSize,
                textColor: Colors.white),
          ),
        )
      ],
    ),
  );
}
