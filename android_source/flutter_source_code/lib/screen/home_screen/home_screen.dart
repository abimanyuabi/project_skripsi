import 'package:flutter/material.dart';
import 'package:flutter_source_code/gen/assets.gen.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
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
  @override
  Widget build(BuildContext context) {
    AdaptiveSize adaptSize =
        AdaptiveSize(deviceSize: MediaQuery.of(context).size);
    return Scaffold(
      body: SizedBox(
          height: adaptSize.deviceSize!.height,
          width: adaptSize.deviceSize!.width,
          child: ListView(
            children: [
              SizedBox(
                width: adaptSize.deviceSize!.width,
                height: adaptSize.deviceSize!.height / 3,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: adaptSize.adaptWidth(desiredSize: 40)),
                  child: modeWidget(
                      adaptSize: adaptSize,
                      modeName: "Feeding Mode",
                      modeBodyText: "-",
                      actionButton1: defaultButton(
                          adaptiveSize: adaptSize,
                          buttonText: "On",
                          textColor: Colors.white,
                          buttonColor: Colors.green,
                          prefButtonHeight:
                              adaptSize.adaptHeight(desiredSize: 24),
                          prefButtonWidth:
                              adaptSize.adaptWidth(desiredSize: 52),
                          actionFunc: () {}),
                      actionButton2: defaultButton(
                        adaptiveSize: adaptSize,
                        buttonText: "Off",
                        textColor: Colors.white,
                        actionFunc: () {},
                        buttonColor: Colors.red,
                        prefButtonHeight:
                            adaptSize.adaptHeight(desiredSize: 24),
                        prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                      ),
                      imageProv: Assets.img.png.feedingMode.provider()
                          as ImageProvider),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              SizedBox(
                width: adaptSize.deviceSize!.width,
                height: adaptSize.deviceSize!.height / 3,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: adaptSize.adaptWidth(desiredSize: 40)),
                  child: modeWidget(
                      modeName: "Wave Mode",
                      modeBodyText: "-",
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
                      imageProv:
                          Assets.img.png.waveMode.provider() as ImageProvider),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              SizedBox(
                width: adaptSize.deviceSize!.width,
                height: adaptSize.deviceSize!.height / 3,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: adaptSize.adaptWidth(desiredSize: 40)),
                  child: modeWidget(
                      adaptSize: adaptSize,
                      modeName: "Viewing Mode",
                      actionButton1: defaultButton(
                          adaptiveSize: adaptSize,
                          buttonText: "On",
                          textColor: Colors.white,
                          buttonColor: Colors.green,
                          prefButtonHeight:
                              adaptSize.adaptHeight(desiredSize: 24),
                          prefButtonWidth:
                              adaptSize.adaptWidth(desiredSize: 52),
                          actionFunc: () {}),
                      actionButton2: defaultButton(
                        adaptiveSize: adaptSize,
                        buttonText: "Off",
                        textColor: Colors.white,
                        actionFunc: () {},
                        buttonColor: Colors.red,
                        prefButtonHeight:
                            adaptSize.adaptHeight(desiredSize: 24),
                        prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                      ),
                      imageProv:
                          Assets.img.png.lightMode.provider() as ImageProvider),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              SizedBox(
                width: adaptSize.deviceSize!.width,
                height: adaptSize.deviceSize!.height / 3,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: adaptSize.adaptWidth(desiredSize: 40)),
                    child: SizedBox(
                      width: adaptSize.adaptWidth(desiredSize: 360),
                      height: adaptSize.adaptHeight(desiredSize: 187),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headingText1(
                              text: "Frag Tank Overview",
                              adaptiveSize: adaptSize),
                          const Divider(),
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  statText1(
                                      parameterText: "Temp",
                                      parameterValue: "999",
                                      parameterScale: "C",
                                      adaptiveSize: adaptSize),
                                  const Divider(),
                                  statText1(
                                      parameterText: "Ph",
                                      parameterValue: "999",
                                      parameterScale: "ph",
                                      adaptiveSize: adaptSize),
                                  const Divider(),
                                  statText1(
                                      parameterText: "Alkalinity",
                                      parameterValue: "999",
                                      parameterScale: "Dkh",
                                      adaptiveSize: adaptSize),
                                  const Divider(),
                                  statText1(
                                      parameterText: "Calcium",
                                      parameterValue: "999",
                                      parameterScale: "ppm",
                                      adaptiveSize: adaptSize),
                                  const Divider(),
                                  statText1(
                                      parameterText: "Magnesium",
                                      parameterValue: "999",
                                      parameterScale: "ppm",
                                      adaptiveSize: adaptSize),
                                  const Divider(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 2,
              ),
            ],
          )),
    );
  }
}
