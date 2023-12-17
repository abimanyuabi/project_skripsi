import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_source_code/screen/debug_screen/debug_screen.dart';
import 'package:flutter_source_code/screen/dosing_utility_screen/dosing_utility_screen.dart';
import 'package:flutter_source_code/screen/light_utility_screen/light_utility_screen.dart';
import 'package:flutter_source_code/screen/main_screen/main_screen.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/viewmodel/auth_viewmodel/authentication_viemodel.dart';
import 'package:flutter_source_code/viewmodel/parameter_monitor_viewmodel/parameter_monitor_viewmodel.dart';
import 'package:flutter_source_code/widget/default_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //main screen
  TextEditingController alkalinityTextEditingController =
      TextEditingController();
  TextEditingController calciumTextEditingController = TextEditingController();
  TextEditingController magnesiumTextEditingController =
      TextEditingController();

  //divider
  ValueNotifier<int> pageIndex = ValueNotifier<int>(0);

  //dose
  ValueNotifier<int> alkDose = ValueNotifier<int>(0);
  ValueNotifier<int> calDose = ValueNotifier<int>(0);
  ValueNotifier<int> magDose = ValueNotifier<int>(0);
  ValueNotifier<int> doseDivider = ValueNotifier<int>(4);

  //light
  ValueNotifier<int> ledBaseStrengthRed = ValueNotifier<int>(255);
  ValueNotifier<int> ledBaseStrengthGreen = ValueNotifier<int>(255);
  ValueNotifier<int> ledBaseStrengthBlue = ValueNotifier<int>(255);
  ValueNotifier<int> ledBaseStrengthWhite = ValueNotifier<int>(255);
  ValueNotifier<int> ledMultiplierSunrise = ValueNotifier<int>(100);
  ValueNotifier<int> ledMultiplierPeak = ValueNotifier<int>(100);
  ValueNotifier<int> ledMultiplierSunset = ValueNotifier<int>(100);
  ValueNotifier<int> ledMultiplierNight = ValueNotifier<int>(100);
  ValueNotifier<int> ledTimingSunrise = ValueNotifier<int>(23);
  ValueNotifier<int> ledTimingPeak = ValueNotifier<int>(23);
  ValueNotifier<int> ledTimingSunset = ValueNotifier<int>(23);
  ValueNotifier<int> ledTimingNight = ValueNotifier<int>(23);

  //debug
  ValueNotifier<int> debugLedRedStrength = ValueNotifier<int>(0);
  ValueNotifier<int> debugLedGreenStrength = ValueNotifier<int>(0);
  ValueNotifier<int> debugLedBlueStrength = ValueNotifier<int>(0);
  ValueNotifier<int> debugLedWhiteStrength = ValueNotifier<int>(0);
  ValueNotifier<int> debugLedFanStrength = ValueNotifier<int>(0);
  ValueNotifier<int> alkDosages = ValueNotifier<int>(0);
  ValueNotifier<int> calDosages = ValueNotifier<int>(0);
  ValueNotifier<int> magDosages = ValueNotifier<int>(0);
  ValueNotifier<bool> debugModeFlag = ValueNotifier<bool>(false);
  ValueNotifier<bool> debugWavePumpLeftFlag = ValueNotifier<bool>(false);
  ValueNotifier<bool> debugWavePumpRightFlag = ValueNotifier<bool>(false);
  ValueNotifier<bool> debugReturnPumpFlag = ValueNotifier<bool>(false);
  ValueNotifier<bool> debugTopUpPumpFlag = ValueNotifier<bool>(false);
  ValueNotifier<bool> debugSumpFanFlag = ValueNotifier<bool>(false);
  ValueNotifier<bool> feedingModeFlag = ValueNotifier<bool>(false);
  ValueNotifier<int> waveModeFlag = ValueNotifier<int>(2);
  ValueNotifier<bool> viewingModeFlag = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final authProviders = Provider.of<AuthViewmodel>(context, listen: false);
    final parameterProviders =
        Provider.of<ParameterViewModel>(context, listen: false);
    AdaptiveSize adaptSize =
        AdaptiveSize(deviceSize: MediaQuery.of(context).size);
    List<Widget> listOfBody = [
      mainScreen(
          adaptSize: adaptSize,
          alkalinityTextEditingController: alkalinityTextEditingController,
          calciumTextEditingController: calciumTextEditingController,
          magnesiumTextEditingController: magnesiumTextEditingController,
          feedingMode: feedingModeFlag,
          viewingMode: viewingModeFlag,
          waveMode: waveModeFlag,
          parameterProviders: parameterProviders),
      lightUtilityScreen(
          adaptSize: adaptSize,
          ledBaseStrengthRed: ledBaseStrengthRed,
          ledBaseStrengthGreen: ledBaseStrengthGreen,
          ledBaseStrengthBlue: ledBaseStrengthBlue,
          ledBaseStrengthWhite: ledBaseStrengthWhite,
          ledMultiplierSunrise: ledMultiplierSunrise,
          ledMultiplierPeak: ledMultiplierPeak,
          ledMultiplierSunset: ledMultiplierSunset,
          ledMultiplierNight: ledMultiplierNight,
          ledTimingSunrise: ledTimingSunrise,
          ledTimingPeak: ledTimingPeak,
          ledTimingSunset: ledTimingSunset,
          ledTimingNight: ledTimingNight),
      dosingUtilityScreen(
          adaptiveSize: adaptSize,
          alkDose: alkDose,
          calDose: calDose,
          magDose: magDose,
          doseDivider: doseDivider),
      debugScreen(
          adaptiveSize: adaptSize,
          debugModeFlag: debugModeFlag,
          ledRedStrength: debugLedRedStrength,
          ledGreenStrength: debugLedGreenStrength,
          ledBlueStrength: debugLedBlueStrength,
          ledWhiteStrength: debugLedWhiteStrength,
          ledFanStrength: debugLedFanStrength,
          alkDosage: alkDosages,
          calDosage: calDosages,
          magDosage: magDosages,
          debugWavePumpLeftFlag: debugWavePumpLeftFlag,
          debugWavePumpRightFlag: debugWavePumpRightFlag,
          debugReturnPumpFlag: debugReturnPumpFlag,
          debugTopUpPumpFlag: debugTopUpPumpFlag,
          debugSumpFanFlag: debugSumpFanFlag,
          authProvider: authProviders,
          contexts: context),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.only(top: adaptSize.adaptHeight(desiredSize: 40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: adaptSize.adaptHeight(desiredSize: 20),
                  right: adaptSize.adaptWidth(desiredSize: 34)),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: adaptSize.adaptWidth(desiredSize: 30),
                  height: adaptSize.adaptHeight(desiredSize: 30),
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                title: Align(
                                    alignment: Alignment.center,
                                    child: const Text("Exit Apps")),
                                content: SizedBox(
                                  height:
                                      adaptSize.adaptHeight(desiredSize: 160),
                                  width: adaptSize.adaptWidth(desiredSize: 160),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text("are you sure to close apps?"),
                                      defaultButton(
                                          textColor: Colors.grey,
                                          buttonColor: Colors.white,
                                          buttonBorderSideColor: Colors.grey,
                                          buttonText: "exit",
                                          actionFunc: () {
                                            exit(0);
                                          },
                                          prefButtonWidth: adaptSize.adaptWidth(
                                              desiredSize: 100),
                                          prefButtonHeight: adaptSize
                                              .adaptHeight(desiredSize: 28),
                                          adaptiveSize: adaptSize)
                                    ],
                                  ),
                                ),
                              );
                            }));
                      },
                      icon: const Icon(Icons.exit_to_app_outlined)),
                ),
              ),
            ),
            SizedBox(
              height: adaptSize.pixPreferredHeight - 200,
              child: ValueListenableBuilder(
                valueListenable: pageIndex,
                builder: ((context, pageIndexValue, child) =>
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: listOfBody[pageIndexValue],
                    )),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: (adaptSize.adaptHeight(desiredSize: 58)),
        child: ValueListenableBuilder(
          valueListenable: pageIndex,
          builder: (context, value, child) => BottomNavigationBar(
            currentIndex: value,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.lightbulb), label: "light"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.heat_pump), label: "dosing"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "debug")
            ],
            selectedItemColor: Colors.blue,
            unselectedItemColor: Color.fromARGB(255, 112, 112, 112),
            onTap: ((int newIndex) {
              pageIndex.value = newIndex;
            }),
          ),
        ),
      ),
    );
  }
}
