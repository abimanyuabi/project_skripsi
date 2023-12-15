import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/utility/enums.dart';
import 'package:flutter_source_code/viewmodel/auth_viewmodel/authentication_viemodel.dart';
import 'package:flutter_source_code/widget/default_button.dart';
import 'package:flutter_source_code/widget/default_slider.dart';
import 'package:flutter_source_code/widget/default_text.dart';

Widget debugScreen(
    {required AdaptiveSize adaptiveSize,
    required ValueNotifier<bool> debugModeFlag,
    required ValueNotifier<int> ledRedStrength,
    required ValueNotifier<int> ledGreenStrength,
    required ValueNotifier<int> ledBlueStrength,
    required ValueNotifier<int> ledWhiteStrength,
    required ValueNotifier<int> ledFanStrength,
    required ValueNotifier<int> alkDosage,
    required ValueNotifier<int> calDosage,
    required ValueNotifier<int> magDosage,
    required ValueNotifier<bool> debugWavePumpLeftFlag,
    required ValueNotifier<bool> debugWavePumpRightFlag,
    required ValueNotifier<bool> debugReturnPumpFlag,
    required ValueNotifier<bool> debugTopUpPumpFlag,
    required ValueNotifier<bool> debugSumpFanFlag,
    required AuthViewmodel authProvider,
    required BuildContext contexts}) {
  return SizedBox(
    width: adaptiveSize.deviceSize.width,
    child: Column(
      children: [
        Center(
          child: SizedBox(
              width: adaptiveSize.adaptWidth(desiredSize: 360),
              height: adaptiveSize.adaptHeight(desiredSize: 42),
              child: ValueListenableBuilder<bool>(
                valueListenable: debugModeFlag,
                builder: (context, debugFlagValue, child) => Card(
                  color: debugFlagValue == true ? Colors.amber : Colors.white,
                  elevation: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      headingText1(
                          text: "Debug Mode",
                          adaptiveSize: adaptiveSize,
                          textColor: debugFlagValue == true
                              ? Colors.white
                              : Colors.black),
                      Switch(
                          activeColor: Colors.white,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor:
                              const Color.fromARGB(60, 112, 112, 112),
                          value: debugFlagValue,
                          onChanged: (value) =>
                              debugModeFlag.value = !debugFlagValue),
                      headingText1(
                          text: debugFlagValue == true ? ": On" : ": Off",
                          adaptiveSize: adaptiveSize,
                          textColor: debugFlagValue == true
                              ? Colors.white
                              : Colors.black),
                    ],
                  ),
                ),
              )),
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.only(top: adaptiveSize.adaptHeight(desiredSize: 20)),
            child: SizedBox(
              width: adaptiveSize.adaptWidth(desiredSize: 360),
              height: adaptiveSize.adaptHeight(desiredSize: 340),
              child: Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: SizedBox(
                        width: adaptiveSize.adaptWidth(desiredSize: 324),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            headingText2(
                                text: "Light Fixture Calibration",
                                adaptiveSize: adaptiveSize),
                            ValueListenableBuilder(
                                valueListenable: debugModeFlag,
                                builder: (context, debugValue, child) =>
                                    Container(
                                      width: adaptiveSize.adaptWidth(
                                          desiredSize: 12),
                                      height: adaptiveSize.adaptHeight(
                                          desiredSize: 12),
                                      decoration: BoxDecoration(
                                          color: debugValue == true
                                              ? Colors.amber
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: defaultSlider(
                          maxValue: 255,
                          customText: bodyText1(
                              text: "Red", adaptiveSize: adaptiveSize),
                          sliderValue: ledRedStrength,
                          adaptiveSize: adaptiveSize),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: defaultSlider(
                          maxValue: 255,
                          sliderValue: ledGreenStrength,
                          adaptiveSize: adaptiveSize,
                          customText: bodyText1(
                              text: "Green", adaptiveSize: adaptiveSize)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: defaultSlider(
                          maxValue: 255,
                          sliderValue: ledBlueStrength,
                          adaptiveSize: adaptiveSize,
                          customText: bodyText1(
                              text: "Blue", adaptiveSize: adaptiveSize)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: defaultSlider(
                          maxValue: 255,
                          sliderValue: ledWhiteStrength,
                          adaptiveSize: adaptiveSize,
                          customText: bodyText1(
                              text: "White", adaptiveSize: adaptiveSize)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: defaultSlider(
                          maxValue: 255,
                          sliderValue: ledFanStrength,
                          adaptiveSize: adaptiveSize,
                          customText: bodyText1(
                              text: "Fan", adaptiveSize: adaptiveSize)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: adaptiveSize.adaptHeight(desiredSize: 12),
                          bottom: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: Center(
                          child: actionButton(
                              buttonColor: Colors.white,
                              buttonBorderSideColor: Colors.grey,
                              buttonBorderWidth: 2,
                              buttonText: "Calibrate",
                              actionFunc: () {},
                              adaptiveSize: adaptiveSize)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.only(top: adaptiveSize.adaptHeight(desiredSize: 20)),
            child: SizedBox(
              width: adaptiveSize.adaptWidth(desiredSize: 360),
              height: adaptiveSize.adaptHeight(desiredSize: 300),
              child: Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: SizedBox(
                        width: adaptiveSize.adaptWidth(desiredSize: 324),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            headingText2(
                                text: "Dosing Pump Calibration",
                                adaptiveSize: adaptiveSize),
                            ValueListenableBuilder(
                                valueListenable: debugModeFlag,
                                builder: (context, debugValue, child) =>
                                    Container(
                                      width: adaptiveSize.adaptWidth(
                                          desiredSize: 12),
                                      height: adaptiveSize.adaptHeight(
                                          desiredSize: 12),
                                      decoration: BoxDecoration(
                                          color: debugValue == true
                                              ? Colors.amber
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: defaultSlider(
                          maxValue: 50,
                          customText: bodyText1(
                              text: "Alk", adaptiveSize: adaptiveSize),
                          sliderValue: alkDosage,
                          adaptiveSize: adaptiveSize),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: defaultSlider(
                          maxValue: 50,
                          sliderValue: calDosage,
                          adaptiveSize: adaptiveSize,
                          customText: bodyText1(
                              text: "Cal", adaptiveSize: adaptiveSize)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: defaultSlider(
                          maxValue: 50,
                          sliderValue: magDosage,
                          adaptiveSize: adaptiveSize,
                          customText: bodyText1(
                              text: "Mag", adaptiveSize: adaptiveSize)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: adaptiveSize.adaptHeight(desiredSize: 12),
                          bottom: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: Center(
                          child: actionButton(
                              buttonColor: Colors.white,
                              buttonBorderSideColor: Colors.grey,
                              buttonBorderWidth: 2,
                              buttonText: "Calibrate",
                              actionFunc: () {},
                              adaptiveSize: adaptiveSize)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding:
                EdgeInsets.only(top: adaptiveSize.adaptHeight(desiredSize: 20)),
            child: SizedBox(
              width: adaptiveSize.adaptWidth(desiredSize: 360),
              height: adaptiveSize.adaptHeight(desiredSize: 640),
              child: Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: SizedBox(
                        width: adaptiveSize.adaptWidth(desiredSize: 324),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            headingText2(
                                text: "AC Pump Check",
                                adaptiveSize: adaptiveSize),
                            ValueListenableBuilder(
                                valueListenable: debugModeFlag,
                                builder: (context, debugValue, child) =>
                                    Container(
                                      width: adaptiveSize.adaptWidth(
                                          desiredSize: 12),
                                      height: adaptiveSize.adaptHeight(
                                          desiredSize: 12),
                                      decoration: BoxDecoration(
                                          color: debugValue == true
                                              ? Colors.amber
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: debugWavePumpLeftFlag,
                        builder: (context, debugWavePumpLeftValue, child) =>
                            SizedBox(
                          width: adaptiveSize.adaptWidth(desiredSize: 220),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              bodyText1(
                                  text: "Wave Pump Left",
                                  adaptiveSize: adaptiveSize,
                                  textColor: debugWavePumpLeftValue == true
                                      ? Colors.blue
                                      : Colors.black),
                              Switch(
                                  activeColor: Colors.blue,
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor:
                                      const Color.fromARGB(60, 112, 112, 112),
                                  value: debugWavePumpLeftValue,
                                  onChanged: (value) => debugWavePumpLeftFlag
                                      .value = !debugWavePumpLeftValue),
                              bodyText1(
                                  text: debugWavePumpLeftValue == true
                                      ? ": On"
                                      : ": Off",
                                  adaptiveSize: adaptiveSize,
                                  textColor: debugWavePumpLeftValue == true
                                      ? Colors.blue
                                      : Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: debugWavePumpRightFlag,
                        builder: (context, debugWavePumpRightValue, child) =>
                            SizedBox(
                          width: adaptiveSize.adaptWidth(desiredSize: 220),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              bodyText1(
                                  text: "Wave Pump Right",
                                  adaptiveSize: adaptiveSize,
                                  textColor: debugWavePumpRightValue == true
                                      ? Colors.blue
                                      : Colors.black),
                              Switch(
                                  activeColor: Colors.blue,
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor:
                                      const Color.fromARGB(60, 112, 112, 112),
                                  value: debugWavePumpRightValue,
                                  onChanged: (value) => debugWavePumpRightFlag
                                      .value = !debugWavePumpRightValue),
                              bodyText1(
                                  text: debugWavePumpRightValue == true
                                      ? ": On"
                                      : ": Off",
                                  adaptiveSize: adaptiveSize,
                                  textColor: debugWavePumpRightValue == true
                                      ? Colors.blue
                                      : Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: debugReturnPumpFlag,
                        builder: (context, debugReturnPumpValue, child) =>
                            SizedBox(
                          width: adaptiveSize.adaptWidth(desiredSize: 220),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              bodyText1(
                                  text: "Return Pump",
                                  adaptiveSize: adaptiveSize,
                                  textColor: debugReturnPumpValue == true
                                      ? Colors.blue
                                      : Colors.black),
                              Switch(
                                  activeColor: Colors.blue,
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor:
                                      const Color.fromARGB(60, 112, 112, 112),
                                  value: debugReturnPumpValue,
                                  onChanged: (value) => debugReturnPumpFlag
                                      .value = !debugReturnPumpValue),
                              bodyText1(
                                  text: debugReturnPumpValue == true
                                      ? ": On"
                                      : ": Off",
                                  adaptiveSize: adaptiveSize,
                                  textColor: debugReturnPumpValue == true
                                      ? Colors.blue
                                      : Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: SizedBox(
                        width: adaptiveSize.adaptWidth(desiredSize: 324),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            headingText2(
                                text: "Top Up Pump Check",
                                adaptiveSize: adaptiveSize),
                            ValueListenableBuilder(
                                valueListenable: debugModeFlag,
                                builder: (context, debugValue, child) =>
                                    Container(
                                      width: adaptiveSize.adaptWidth(
                                          desiredSize: 12),
                                      height: adaptiveSize.adaptHeight(
                                          desiredSize: 12),
                                      decoration: BoxDecoration(
                                          color: debugValue == true
                                              ? Colors.amber
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: debugTopUpPumpFlag,
                        builder: (context, debugTopUpPumpValue, child) =>
                            SizedBox(
                          width: adaptiveSize.adaptWidth(desiredSize: 220),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              bodyText1(
                                  text: "Top Up Pump",
                                  adaptiveSize: adaptiveSize,
                                  textColor: debugTopUpPumpValue == true
                                      ? Colors.blue
                                      : Colors.black),
                              Switch(
                                  activeColor: Colors.blue,
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor:
                                      const Color.fromARGB(60, 112, 112, 112),
                                  value: debugTopUpPumpValue,
                                  onChanged: (value) => debugTopUpPumpFlag
                                      .value = !debugTopUpPumpValue),
                              bodyText1(
                                  text: debugTopUpPumpValue == true
                                      ? ": On"
                                      : ": Off",
                                  adaptiveSize: adaptiveSize,
                                  textColor: debugTopUpPumpValue == true
                                      ? Colors.blue
                                      : Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: SizedBox(
                        width: adaptiveSize.adaptWidth(desiredSize: 324),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            headingText2(
                                text: "Sump Fan Check",
                                adaptiveSize: adaptiveSize),
                            ValueListenableBuilder(
                                valueListenable: debugModeFlag,
                                builder: (context, debugValue, child) =>
                                    Container(
                                      width: adaptiveSize.adaptWidth(
                                          desiredSize: 12),
                                      height: adaptiveSize.adaptHeight(
                                          desiredSize: 12),
                                      decoration: BoxDecoration(
                                          color: debugValue == true
                                              ? Colors.amber
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                    )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: adaptiveSize.adaptWidth(desiredSize: 12),
                          top: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: debugSumpFanFlag,
                        builder: (context, debugSumpFanValue, child) =>
                            SizedBox(
                          width: adaptiveSize.adaptWidth(desiredSize: 220),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              bodyText1(
                                  text: "Sump Fan",
                                  adaptiveSize: adaptiveSize,
                                  textColor: debugSumpFanValue == true
                                      ? Colors.blue
                                      : Colors.black),
                              Switch(
                                  activeColor: Colors.blue,
                                  inactiveThumbColor: Colors.grey,
                                  inactiveTrackColor:
                                      const Color.fromARGB(60, 112, 112, 112),
                                  value: debugSumpFanValue,
                                  onChanged: (value) => debugSumpFanFlag.value =
                                      !debugSumpFanValue),
                              bodyText1(
                                  text: debugSumpFanValue == true
                                      ? ": On"
                                      : ": Off",
                                  adaptiveSize: adaptiveSize,
                                  textColor: debugSumpFanValue == true
                                      ? Colors.blue
                                      : Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: adaptiveSize.adaptHeight(desiredSize: 12),
                          bottom: adaptiveSize.adaptHeight(desiredSize: 12)),
                      child: Center(
                          child: actionButton(
                              buttonColor: Colors.white,
                              buttonBorderSideColor: Colors.grey,
                              buttonBorderWidth: 2,
                              buttonText: "Calibrate",
                              actionFunc: () {},
                              adaptiveSize: adaptiveSize)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: adaptiveSize.adaptHeight(desiredSize: 20),
                bottom: adaptiveSize.adaptHeight(desiredSize: 20)),
            child: SizedBox(
                height: adaptiveSize.adaptHeight(desiredSize: 28),
                width: adaptiveSize.adaptWidth(desiredSize: 100),
                child: actionButton(
                    buttonColor: Colors.white,
                    buttonBorderSideColor: Colors.grey,
                    buttonBorderWidth: 2,
                    buttonText: "logout",
                    actionFunc: () async {
                      await authProvider.authLogout();
                      if (authProvider.authStatus == AuthStatus.logout) {
                        Navigator.pushNamed(contexts, '/');
                      }
                    },
                    adaptiveSize: adaptiveSize)),
          ),
        ),
      ],
    ),
  );
}
