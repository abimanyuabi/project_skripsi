import 'package:flutter/material.dart';
import 'package:flutter_source_code/screen/debug_screen/debug_screen.dart';
import 'package:flutter_source_code/screen/dosing_utility_screen/dosing_utility_screen.dart';
import 'package:flutter_source_code/screen/light_utility_screen/light_utility_screen.dart';
import 'package:flutter_source_code/screen/main_screen/main_screen.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';

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

  @override
  Widget build(BuildContext context) {
    AdaptiveSize adaptSize =
        AdaptiveSize(deviceSize: MediaQuery.of(context).size);
    List<Widget> listOfBody = [
      mainScreen(
          adaptSize: adaptSize,
          alkalinityTextEditingController: alkalinityTextEditingController,
          calciumTextEditingController: calciumTextEditingController,
          magnesiumTextEditingController: magnesiumTextEditingController),
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
          debugSumpFanFlag: debugSumpFanFlag),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.only(top: adaptSize.adaptHeight(desiredSize: 20)),
        child: ValueListenableBuilder(
          valueListenable: pageIndex,
          builder: ((context, pageIndexValue, child) => SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: listOfBody[pageIndexValue],
              )),
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
