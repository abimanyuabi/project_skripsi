import 'package:flutter/material.dart';
import 'package:flutter_source_code/gen/assets.gen.dart';
import 'package:flutter_source_code/model/sensor_model.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/chart_widget.dart';
import 'package:flutter_source_code/widget/default_button.dart';
import 'package:flutter_source_code/widget/default_text.dart';
import 'package:flutter_source_code/widget/mode_widget.dart';
import 'package:flutter_source_code/widget/stat_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController alkalinityTextEditingController =
      TextEditingController();
  TextEditingController calciumTextEditingController = TextEditingController();
  TextEditingController magnesiumTextEditingController =
      TextEditingController();
  late DateTime alkalinityTestDate;
  late DateTime calciumTestDate;
  late DateTime magnesiumTestDate;

  List<ParameterModel> dummyParameter = [
    ParameterModel(
      sensorModel: SensorModel(
          phReadings: 3,
          tempReadings: 4,
          waterUsage: 5,
          createdAt: DateTime.now()),
      waterChemistryModel: WaterChemistryModel(
        alkalinity: 3,
        calcium: 3,
        magnesium: 3,
        dateTime: DateTime.now(),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    AdaptiveSize adaptSize =
        AdaptiveSize(deviceSize: MediaQuery.of(context).size);
    return Scaffold(
      body: SizedBox(
          height: adaptSize.deviceSize.height,
          width: adaptSize.deviceSize.width,
          child: ListView(
            children: [
              SizedBox(
                width: adaptSize.deviceSize.width,
                height: adaptSize.deviceSize.height / 3,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: adaptSize.adaptWidth(desiredSize: 40)),
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
                        prefButtonHeight:
                            adaptSize.adaptHeight(desiredSize: 24),
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
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              SizedBox(
                width: adaptSize.deviceSize.width,
                height: adaptSize.deviceSize.height / 3,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: adaptSize.adaptWidth(desiredSize: 40)),
                  child: modeWidget(
                      modeName: "Wave Mode",
                      modeBodyText: "Adjust wave pattern on wavemaker pump",
                      adaptSize: adaptSize,
                      actionButton1: defaultButton(
                        adaptiveSize: adaptSize,
                        buttonText: "Linear",
                        textColor: Colors.white,
                        buttonColor: Colors.lightBlue,
                        prefButtonHeight:
                            adaptSize.adaptHeight(desiredSize: 24),
                        prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                        actionFunc: () {},
                      ),
                      actionButton2: defaultButton(
                        adaptiveSize: adaptSize,
                        buttonText: "Symm",
                        textColor: Colors.white,
                        buttonColor: Colors.lightBlue,
                        actionFunc: () {},
                        prefButtonHeight:
                            adaptSize.adaptHeight(desiredSize: 24),
                        prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                      ),
                      actionButton3: defaultButton(
                        adaptiveSize: adaptSize,
                        buttonText: "Asymm",
                        textColor: Colors.white,
                        buttonColor: Colors.lightBlue,
                        actionFunc: () {},
                        prefButtonHeight:
                            adaptSize.adaptHeight(desiredSize: 24),
                        prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                      ),
                      imageProv: Assets.img.png.waveMode.provider()),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              SizedBox(
                width: adaptSize.deviceSize.width,
                height: adaptSize.deviceSize.height / 3,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: adaptSize.adaptWidth(desiredSize: 40)),
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
                        prefButtonHeight:
                            adaptSize.adaptHeight(desiredSize: 24),
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
              const Divider(
                color: Colors.grey,
                thickness: 1,
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
                          textEditingController:
                              alkalinityTextEditingController,
                          parameterText: "Alkalinity",
                          parameterValue: "999",
                          parameterScale: "Dkh",
                          adaptiveSize: adaptSize,
                        ),
                        statTextBox1(
                          textEditingController:
                              alkalinityTextEditingController,
                          parameterText: "Calcium",
                          parameterValue: "999",
                          parameterScale: "ppm",
                          adaptiveSize: adaptSize,
                        ),
                        statTextBox1(
                          textEditingController:
                              alkalinityTextEditingController,
                          parameterText: "Magnesium",
                          parameterValue: "999",
                          parameterScale: "ppm",
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
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              SizedBox(
                width: adaptSize.deviceSize.width,
                height: adaptSize.deviceSize.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingText1(text: "Parameter", adaptiveSize: adaptSize),
                    chartView(arrayOfParameter: dummyParameter)
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
