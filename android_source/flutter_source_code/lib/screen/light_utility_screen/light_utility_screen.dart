import 'package:flutter/material.dart';
import 'package:flutter_source_code/model/device_profile_model.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/viewmodel/light_utility_viewmodel/light_utility_viewmodel.dart';
import 'package:flutter_source_code/widget/default_button.dart';
import 'package:flutter_source_code/widget/default_slider.dart';
import 'package:flutter_source_code/widget/default_text.dart';
import 'package:flutter_source_code/widget/custom_picker.dart';

Widget lightUtilityScreen({
  required AdaptiveSize adaptSize,
  required ValueNotifier<int> ledBaseStrengthRed,
  required ValueNotifier<int> ledBaseStrengthGreen,
  required ValueNotifier<int> ledBaseStrengthBlue,
  required ValueNotifier<int> ledBaseStrengthWhite,
  required ValueNotifier<int> ledMultiplierSunrise,
  required ValueNotifier<int> ledMultiplierPeak,
  required ValueNotifier<int> ledMultiplierSunset,
  required ValueNotifier<int> ledMultiplierNight,
  required ValueNotifier<int> ledTimingSunrise,
  required ValueNotifier<int> ledTimingPeak,
  required ValueNotifier<int> ledTimingSunset,
  required ValueNotifier<int> ledTimingNight,
  required LightUtilityViewModel lightUtilityProviders,
}) {
  ledTimingSunrise.value =
      lightUtilityProviders.currLedProfileModels.ledTimingSunrise;
  ledTimingPeak.value =
      lightUtilityProviders.currLedProfileModels.ledTimingPeak;
  ledTimingSunset.value =
      lightUtilityProviders.currLedProfileModels.ledTimingSunset;
  ledTimingNight.value =
      lightUtilityProviders.currLedProfileModels.ledTimingNight;
  ledMultiplierSunrise.value = lightUtilityProviders
      .currLedProfileModels.ledTimingStrengthMultiplierSunrise;
  ledMultiplierPeak.value = lightUtilityProviders
      .currLedProfileModels.ledTimingStrengthMultiplierPeak;
  ledMultiplierSunset.value = lightUtilityProviders
      .currLedProfileModels.ledTimingStrengthMultiplierSunset;
  ledMultiplierNight.value = lightUtilityProviders
      .currLedProfileModels.ledTimingStrengthMultiplierNight;
  ledBaseStrengthRed.value =
      lightUtilityProviders.currLedProfileModels.ledChannelRedBaseStrength;
  ledBaseStrengthGreen.value =
      lightUtilityProviders.currLedProfileModels.ledChannelGreenBaseStrength;
  ledBaseStrengthBlue.value =
      lightUtilityProviders.currLedProfileModels.ledChannelBlueBaseStrength;
  ledBaseStrengthWhite.value =
      lightUtilityProviders.currLedProfileModels.ledChannelWhiteBaseStrength;

  return SizedBox(
    width: adaptSize.deviceSize.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: adaptSize.deviceSize.width,
          height: adaptSize.deviceSize.height / 3,
          child: Center(
            child: SizedBox(
              width: adaptSize.adaptWidth(desiredSize: 380),
              height: adaptSize.adaptHeight(desiredSize: 300),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: adaptSize.adaptWidth(desiredSize: 46),
                      top: adaptSize.adaptHeight(desiredSize: 12)),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 80,
                        left: 0,
                        child: SizedBox(
                            width: adaptSize.adaptWidth(desiredSize: 180),
                            height: adaptSize.adaptHeight(desiredSize: 180),
                            child: ValueListenableBuilder(
                              valueListenable: ledBaseStrengthRed,
                              builder: (context, redStrengthValue, child) =>
                                  Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                        redStrengthValue, 255, 0, 0),
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                            )),
                      ),
                      Positioned(
                        left: 50,
                        child: SizedBox(
                          width: adaptSize.adaptWidth(desiredSize: 180),
                          height: adaptSize.adaptHeight(desiredSize: 180),
                          child: ValueListenableBuilder(
                            valueListenable: ledBaseStrengthBlue,
                            builder: (context, blueStrengthValue, child) =>
                                Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(blueStrengthValue, 0, 0,
                                      blueStrengthValue),
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 100,
                        child: SizedBox(
                          width: adaptSize.adaptWidth(desiredSize: 180),
                          height: adaptSize.adaptHeight(desiredSize: 180),
                          child: ValueListenableBuilder(
                            valueListenable: ledBaseStrengthGreen,
                            builder: (context, greenStrengthValue, child) =>
                                Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(greenStrengthValue, 0,
                                      greenStrengthValue, 0),
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 95,
                        left: 94,
                        child: SizedBox(
                          width: adaptSize.adaptWidth(desiredSize: 90),
                          height: adaptSize.adaptHeight(desiredSize: 90),
                          child: ValueListenableBuilder(
                            valueListenable: ledBaseStrengthWhite,
                            builder: (context, whiteStrengthValue, child) =>
                                Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, whiteStrengthValue,
                                      whiteStrengthValue, whiteStrengthValue),
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.only(top: adaptSize.adaptHeight(desiredSize: 20)),
            child: SizedBox(
                width: adaptSize.deviceSize.width,
                height: adaptSize.adaptHeight(desiredSize: 200),
                child: SizedBox(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: adaptSize.adaptWidth(desiredSize: 52),
                              bottom: adaptSize.adaptHeight(desiredSize: 20)),
                          child: headingText1(
                              text: "Color Base Strength",
                              adaptiveSize: adaptSize),
                        ),
                      ),
                      defaultSlider(
                          maxValue: 255,
                          sliderValue: ledBaseStrengthRed,
                          adaptiveSize: adaptSize,
                          sliderName: "Red"),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          top: adaptSize.adaptHeight(desiredSize: 20),
                        ),
                        child: defaultSlider(
                            maxValue: 255,
                            sliderValue: ledBaseStrengthGreen,
                            adaptiveSize: adaptSize,
                            sliderName: "Green"),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          top: adaptSize.adaptHeight(desiredSize: 20),
                        ),
                        child: defaultSlider(
                            maxValue: 255,
                            sliderValue: ledBaseStrengthBlue,
                            adaptiveSize: adaptSize,
                            sliderName: "Blue"),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          top: adaptSize.adaptHeight(desiredSize: 20),
                        ),
                        child: defaultSlider(
                            maxValue: 255,
                            sliderValue: ledBaseStrengthWhite,
                            adaptiveSize: adaptSize,
                            sliderName: "White"),
                      ),
                    ],
                  ),
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: adaptSize.adaptWidth(desiredSize: 52),
              top: adaptSize.adaptHeight(desiredSize: 20),
              bottom: adaptSize.adaptHeight(desiredSize: 20)),
          child: headingText1(text: "Light Schedule", adaptiveSize: adaptSize),
        ),
        SizedBox(
          width: adaptSize.deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: adaptSize.adaptHeight(desiredSize: 20),
                ),
                child: SizedBox(
                  width: adaptSize.adaptWidth(desiredSize: 320),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      headingText2(text: "Sunrise", adaptiveSize: adaptSize),
                      customPicker(
                          notifyableValue: ledTimingSunrise,
                          adaptiveSize: adaptSize,
                          maxValue: 23),
                      customPicker(
                          notifyableValue: ledMultiplierSunrise,
                          adaptiveSize: adaptSize,
                          maxValue: 100,
                          pickerSuffix: "%"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: adaptSize.adaptHeight(desiredSize: 20),
                ),
                child: SizedBox(
                  width: adaptSize.adaptWidth(desiredSize: 320),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      headingText2(text: "Peak", adaptiveSize: adaptSize),
                      customPicker(
                          notifyableValue: ledTimingPeak,
                          adaptiveSize: adaptSize,
                          maxValue: 23),
                      customPicker(
                          notifyableValue: ledMultiplierPeak,
                          adaptiveSize: adaptSize,
                          maxValue: 100,
                          pickerSuffix: "%"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: adaptSize.adaptHeight(desiredSize: 20),
                ),
                child: SizedBox(
                  width: adaptSize.adaptWidth(desiredSize: 320),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      headingText2(text: "Sunset", adaptiveSize: adaptSize),
                      customPicker(
                          notifyableValue: ledTimingSunset,
                          adaptiveSize: adaptSize,
                          maxValue: 23),
                      customPicker(
                          notifyableValue: ledMultiplierSunset,
                          adaptiveSize: adaptSize,
                          maxValue: 100,
                          pickerSuffix: "%"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: adaptSize.adaptHeight(desiredSize: 20),
                ),
                child: SizedBox(
                  width: adaptSize.adaptWidth(desiredSize: 320),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      headingText2(text: "Night", adaptiveSize: adaptSize),
                      customPicker(
                          notifyableValue: ledTimingNight,
                          adaptiveSize: adaptSize,
                          maxValue: 23),
                      customPicker(
                          notifyableValue: ledMultiplierNight,
                          adaptiveSize: adaptSize,
                          maxValue: 100,
                          pickerSuffix: "%"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: adaptSize.adaptHeight(desiredSize: 20)),
                child: actionButton(
                    buttonWidth: 128,
                    buttonHeight: 36,
                    buttonText: "Save Settings",
                    actionFunc: () async {
                      await lightUtilityProviders.createLedProfile(
                          ledProfileModel: LedProfileModel(
                              ledTimingSunrise: ledTimingSunrise.value,
                              ledTimingPeak: ledTimingPeak.value,
                              ledTimingSunset: ledTimingSunset.value,
                              ledTimingNight: ledTimingNight.value,
                              ledTimingStrengthMultiplierSunrise:
                                  ledMultiplierSunrise.value,
                              ledTimingStrengthMultiplierPeak:
                                  ledMultiplierPeak.value,
                              ledTimingStrengthMultiplierSunset:
                                  ledMultiplierSunset.value,
                              ledTimingStrengthMultiplierNight:
                                  ledMultiplierNight.value,
                              ledChannelRedBaseStrength:
                                  ledBaseStrengthRed.value,
                              ledChannelGreenBaseStrength:
                                  ledBaseStrengthGreen.value,
                              ledChannelBlueBaseStrength:
                                  ledBaseStrengthBlue.value,
                              ledChannelWhiteBaseStrength:
                                  ledBaseStrengthWhite.value));
                      await lightUtilityProviders.getLedProfile();
                    },
                    adaptiveSize: adaptSize,
                    textColor: Colors.white),
              )
            ],
          ),
        )
      ],
    ),
  );
}
