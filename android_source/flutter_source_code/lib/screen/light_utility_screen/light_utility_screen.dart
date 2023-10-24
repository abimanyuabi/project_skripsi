import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/default_slider.dart';
import 'package:flutter_source_code/widget/default_text.dart';
import 'package:flutter_source_code/widget/hour_picker.dart';

Widget lightUtilityScreen({required AdaptiveSize adaptSize}) {
  ValueNotifier<int> ledBaseStrengthRed = ValueNotifier<int>(255);
  ValueNotifier<int> ledBaseStrengthGreen = ValueNotifier<int>(255);
  ValueNotifier<int> ledBaseStrengthBlue = ValueNotifier<int>(255);
  ValueNotifier<int> ledBaseStrengthWhite = ValueNotifier<int>(255);
  ValueNotifier<int> ledMultiplierSunrise = ValueNotifier<int>(255);
  ValueNotifier<int> ledMultiplierPeak = ValueNotifier<int>(255);
  ValueNotifier<int> ledMultiplierSunset = ValueNotifier<int>(255);
  ValueNotifier<int> ledMultiplierNight = ValueNotifier<int>(255);
  ValueNotifier<int> lightTimingSunrise = ValueNotifier<int>(23);
  ValueNotifier<int> lightTimingPeak = ValueNotifier<int>(23);
  ValueNotifier<int> lightTimingSunset = ValueNotifier<int>(23);
  ValueNotifier<int> lightTimingNight = ValueNotifier<int>(23);

  return SizedBox(
    height: adaptSize.deviceSize.height,
    width: adaptSize.deviceSize.width,
    child: Column(
      children: [
        SizedBox(
          height: (adaptSize.deviceSize.height) -
              adaptSize.adaptHeight(desiredSize: 64),
          child: ListView(
            children: [
              SizedBox(
                width: adaptSize.deviceSize.width,
                height: adaptSize.deviceSize.height / 3,
                child: Center(
                  child: SizedBox(
                    width: adaptSize.adaptWidth(desiredSize: 300),
                    height: adaptSize.adaptHeight(desiredSize: 284),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 80,
                          left: 0,
                          child: SizedBox(
                            width: adaptSize.adaptWidth(desiredSize: 180),
                            height: adaptSize.adaptHeight(desiredSize: 180),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(200, 255, 0, 0),
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          child: SizedBox(
                            width: adaptSize.adaptWidth(desiredSize: 180),
                            height: adaptSize.adaptHeight(desiredSize: 180),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(200, 0, 0, 255),
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 80,
                          left: 100,
                          child: SizedBox(
                            width: adaptSize.adaptWidth(desiredSize: 180),
                            height: adaptSize.adaptHeight(desiredSize: 180),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(200, 0, 255, 0),
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 95,
                          left: 94,
                          child: SizedBox(
                            width: adaptSize.adaptWidth(desiredSize: 90),
                            height: adaptSize.adaptHeight(desiredSize: 90),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                    width: adaptSize.deviceSize.width,
                    height: adaptSize.deviceSize.height / 3,
                    child: SizedBox(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: adaptSize.adaptWidth(desiredSize: 62),
                                  bottom:
                                      adaptSize.adaptHeight(desiredSize: 20)),
                              child: headingText1(
                                  text: "Color Base Strength",
                                  adaptiveSize: adaptSize),
                            ),
                          ),
                          defaultSlider(
                              sliderValue: ledBaseStrengthRed,
                              adaptiveSize: adaptSize,
                              sliderName: "Red"),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              top: adaptSize.adaptHeight(desiredSize: 20),
                            ),
                            child: defaultSlider(
                                sliderValue: ledBaseStrengthGreen,
                                adaptiveSize: adaptSize,
                                sliderName: "Green"),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              top: adaptSize.adaptHeight(desiredSize: 20),
                            ),
                            child: defaultSlider(
                                sliderValue: ledBaseStrengthBlue,
                                adaptiveSize: adaptSize,
                                sliderName: "Blue"),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              top: adaptSize.adaptHeight(desiredSize: 20),
                            ),
                            child: defaultSlider(
                                sliderValue: ledBaseStrengthWhite,
                                adaptiveSize: adaptSize,
                                sliderName: "White"),
                          ),
                        ],
                      ),
                    )),
              ),
              SizedBox(
                width: adaptSize.deviceSize.width,
                height: adaptSize.deviceSize.height / 3,
                child: Column(
                  children: [
                    customHourPicker(
                        hourValue: lightTimingSunrise, adaptiveSize: adaptSize),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
