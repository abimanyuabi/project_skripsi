import 'package:flutter/material.dart';
import 'package:flutter_source_code/gen/assets.gen.dart';
import 'package:flutter_source_code/model/sensor_model.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/chart_widget.dart';
import 'package:flutter_source_code/widget/default_button.dart';
import 'package:flutter_source_code/widget/default_text.dart';
import 'package:flutter_source_code/widget/mode_widget.dart';
import 'package:flutter_source_code/widget/stat_text.dart';

Widget mainScreen(
    {required AdaptiveSize adaptSize,
    required TextEditingController alkalinityTextEditingController,
    required TextEditingController calciumTextEditingController,
    required TextEditingController magnesiumTextEditingController}) {
  return SizedBox(
    width: adaptSize.deviceSize.width,
    child: Column(
      children: [
        SizedBox(
          width: adaptSize.deviceSize.width,
          height: adaptSize.deviceSize.height / 3,
          child: Padding(
            padding: EdgeInsets.only(
                left: adaptSize.adaptWidth(desiredSize: 20),
                right: adaptSize.adaptWidth(desiredSize: 20),
                bottom: adaptSize.adaptHeight(desiredSize: 20)),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.only(
                    left: adaptSize.adaptWidth(desiredSize: 32)),
                child: modeWidget(
                  adaptSize: adaptSize,
                  modeName: "Feeding Mode",
                  modeBodyText:
                      "Turn off main return pump and wave maker pump.",
                  actionButton1: defaultButton(
                      adaptiveSize: adaptSize,
                      buttonText: "On",
                      textColor: Colors.white,
                      buttonColor: Colors.green,
                      prefButtonHeight: adaptSize.adaptHeight(desiredSize: 24),
                      prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                      actionFunc: () {}),
                  actionButton2: defaultButton(
                    adaptiveSize: adaptSize,
                    buttonText: "Off",
                    textColor: Colors.white,
                    actionFunc: () {},
                    buttonColor: Colors.red,
                    prefButtonHeight: adaptSize.adaptHeight(desiredSize: 24),
                    prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                  ),
                  imageProv: Assets.img.png.feedingMode.provider(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: adaptSize.deviceSize.width,
          height: adaptSize.deviceSize.height / 3,
          child: Padding(
            padding: EdgeInsets.only(
                left: adaptSize.adaptWidth(desiredSize: 20),
                right: adaptSize.adaptWidth(desiredSize: 20),
                bottom: adaptSize.adaptHeight(desiredSize: 20)),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.only(
                    left: adaptSize.adaptWidth(desiredSize: 32)),
                child: modeWidget(
                    modeName: "Wave Mode",
                    modeBodyText: "Adjust wave pattern on wavemaker pump",
                    adaptSize: adaptSize,
                    actionButton1: defaultButton(
                      adaptiveSize: adaptSize,
                      buttonText: "Linear",
                      textColor: Colors.white,
                      buttonColor: Colors.lightBlue,
                      prefButtonHeight: adaptSize.adaptHeight(desiredSize: 24),
                      prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                      actionFunc: () {},
                    ),
                    actionButton2: defaultButton(
                      adaptiveSize: adaptSize,
                      buttonText: "Symm",
                      textColor: Colors.white,
                      buttonColor: Colors.lightBlue,
                      actionFunc: () {},
                      prefButtonHeight: adaptSize.adaptHeight(desiredSize: 24),
                      prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                    ),
                    actionButton3: defaultButton(
                      adaptiveSize: adaptSize,
                      buttonText: "Asymm",
                      textColor: Colors.white,
                      buttonColor: Colors.lightBlue,
                      actionFunc: () {},
                      prefButtonHeight: adaptSize.adaptHeight(desiredSize: 24),
                      prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                    ),
                    imageProv: Assets.img.png.waveMode.provider()),
              ),
            ),
          ),
        ),
        SizedBox(
          width: adaptSize.deviceSize.width,
          height: adaptSize.deviceSize.height / 3,
          child: Padding(
            padding: EdgeInsets.only(
                left: adaptSize.adaptWidth(desiredSize: 20),
                right: adaptSize.adaptWidth(desiredSize: 20),
                bottom: adaptSize.adaptHeight(desiredSize: 20)),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.only(
                    left: adaptSize.adaptWidth(desiredSize: 32)),
                child: modeWidget(
                  adaptSize: adaptSize,
                  modeName: "Viewing Mode",
                  modeBodyText:
                      "Adjust Light to make it more actinic or more white",
                  actionButton1: defaultButton(
                      adaptiveSize: adaptSize,
                      buttonText: "On",
                      textColor: Colors.white,
                      buttonColor: Colors.green,
                      prefButtonHeight: adaptSize.adaptHeight(desiredSize: 24),
                      prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                      actionFunc: () {}),
                  actionButton2: defaultButton(
                    adaptiveSize: adaptSize,
                    buttonText: "Off",
                    textColor: Colors.white,
                    actionFunc: () {},
                    buttonColor: Colors.red,
                    prefButtonHeight: adaptSize.adaptHeight(desiredSize: 24),
                    prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                  ),
                  imageProv: Assets.img.png.lightMode.provider(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: adaptSize.deviceSize.width,
          height: (adaptSize.deviceSize.height / 3) * 2,
          child: Padding(
            padding: EdgeInsets.only(
                left: adaptSize.adaptWidth(desiredSize: 20),
                right: adaptSize.adaptWidth(desiredSize: 20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headingText1(text: "Parameter", adaptiveSize: adaptSize),
                Padding(
                  padding: EdgeInsets.only(
                    top: adaptSize.adaptHeight(desiredSize: 20),
                  ),
                  child: sensorReadingChartView(
                      arrayOfParameter: dummySensor(),
                      chartHeight: 240,
                      chartName: "Sensor Reading"),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: adaptSize.adaptHeight(desiredSize: 20),
                  ),
                  child: waterChemistryChartView(
                      arrayOfParameter: dummyWaterChemistry(),
                      chartHeight: 240,
                      chartName: "Water Chemistry"),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: adaptSize.deviceSize.width,
          height: adaptSize.deviceSize.height / 3,
          child: Center(
            child: SizedBox(
              width: adaptSize.adaptWidth(desiredSize: 360),
              height: adaptSize.adaptHeight(desiredSize: 260),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText1(
                      text: "Water Test Input", adaptiveSize: adaptSize),
                  statTextBox1(
                    textEditingController: alkalinityTextEditingController,
                    parameterText: "Alkalinity",
                    parameterValue: "999",
                    parameterScale: "Dkh",
                    maxValue: 100,
                    adaptiveSize: adaptSize,
                  ),
                  statTextBox1(
                    textEditingController: calciumTextEditingController,
                    parameterText: "Calcium",
                    parameterValue: "999",
                    parameterScale: "ppm",
                    maxValue: 1000,
                    adaptiveSize: adaptSize,
                  ),
                  statTextBox1(
                    textEditingController: magnesiumTextEditingController,
                    parameterText: "Magnesium",
                    parameterValue: "999",
                    parameterScale: "ppm",
                    maxValue: 1000,
                    adaptiveSize: adaptSize,
                  ),
                  Center(
                    child: actionButton(
                      buttonText: "Upload",
                      textColor: Colors.white,
                      actionFunc: () {},
                      adaptiveSize: adaptSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
