import 'package:flutter/material.dart';
import 'package:flutter_source_code/gen/assets.gen.dart';
import 'package:flutter_source_code/model/sensor_model.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/utility/enums.dart';
import 'package:flutter_source_code/viewmodel/device_mode_viewmodel/device_mode_viewmodel.dart';
import 'package:flutter_source_code/viewmodel/parameter_monitor_viewmodel/parameter_monitor_viewmodel.dart';
import 'package:flutter_source_code/widget/chart_widget.dart';
import 'package:flutter_source_code/widget/default_button.dart';
import 'package:flutter_source_code/widget/default_text.dart';
import 'package:flutter_source_code/widget/mode_widget.dart';
import 'package:flutter_source_code/widget/stat_text.dart';

Widget mainScreen(
    {required AdaptiveSize adaptSize,
    required TextEditingController alkalinityTextEditingController,
    required TextEditingController calciumTextEditingController,
    required TextEditingController magnesiumTextEditingController,
    required TextEditingController salinityTextEditingController,
    required ValueNotifier<bool> feedingMode,
    required ValueNotifier<bool> viewingMode,
    required ValueNotifier<int> waveMode,
    required ParameterViewModel parameterProviders,
    required DeviceModeViewModel deviceModeProviders,
    required BuildContext context,
    required ValueNotifier<DateTime?> pickedParameterTestDate,
    required GlobalKey<FormState> formKey}) {
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
                  actionButton1: ValueListenableBuilder(
                    valueListenable: feedingMode,
                    builder: (context, feedingModeFlag, child) => defaultButton(
                        adaptiveSize: adaptSize,
                        buttonText: "On",
                        textColor: feedingModeFlag == true
                            ? Colors.white
                            : Colors.black,
                        buttonColor: feedingModeFlag == true
                            ? Colors.green
                            : const Color.fromARGB(255, 200, 200, 200),
                        prefButtonHeight:
                            adaptSize.adaptHeight(desiredSize: 24),
                        prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                        actionFunc: () async {
                          feedingMode.value = true;
                          if (viewingMode.value != true) {
                            await deviceModeProviders.updateDeviceMode(
                                deviceMode: 1);
                          }
                        }),
                  ),
                  actionButton2: ValueListenableBuilder(
                      valueListenable: feedingMode,
                      builder: ((context, feedingModeFlag, child) {
                        return ValueListenableBuilder(
                          valueListenable: viewingMode,
                          builder: (context, viewingModeFlag, child) =>
                              defaultButton(
                            adaptiveSize: adaptSize,
                            buttonText: "Off",
                            textColor: feedingModeFlag == false
                                ? Colors.white
                                : Colors.black,
                            actionFunc: () async {
                              feedingMode.value = false;
                              if (viewingModeFlag == false) {
                                await deviceModeProviders.updateDeviceMode(
                                    deviceMode: 0);
                              }
                            },
                            buttonColor: feedingModeFlag == false
                                ? Colors.red
                                : const Color.fromARGB(255, 200, 200, 200),
                            prefButtonHeight:
                                adaptSize.adaptHeight(desiredSize: 24),
                            prefButtonWidth:
                                adaptSize.adaptWidth(desiredSize: 52),
                          ),
                        );
                      })),
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
                    actionButton1: ValueListenableBuilder(
                      valueListenable: waveMode,
                      builder: (context, waveModeFlag, child) => defaultButton(
                        adaptiveSize: adaptSize,
                        buttonText: "Linear",
                        textColor:
                            waveModeFlag == 1 ? Colors.white : Colors.black,
                        buttonColor: waveModeFlag == 1
                            ? Colors.lightBlue
                            : const Color.fromARGB(255, 200, 200, 200),
                        prefButtonHeight:
                            adaptSize.adaptHeight(desiredSize: 24),
                        prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                        actionFunc: () async {
                          waveMode.value = 1;
                          await deviceModeProviders.updateWaveMode(
                              waveMode: waveMode.value);
                        },
                      ),
                    ),
                    actionButton2: ValueListenableBuilder(
                      valueListenable: waveMode,
                      builder: (context, waveModeFlag, child) => defaultButton(
                        adaptiveSize: adaptSize,
                        buttonText: "Symm",
                        textColor:
                            waveModeFlag == 2 ? Colors.white : Colors.black,
                        buttonColor: waveModeFlag == 2
                            ? Colors.lightBlue
                            : const Color.fromARGB(255, 200, 200, 200),
                        prefButtonHeight:
                            adaptSize.adaptHeight(desiredSize: 24),
                        prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                        actionFunc: () async {
                          waveMode.value = 2;
                          await deviceModeProviders.updateWaveMode(
                              waveMode: waveMode.value);
                        },
                      ),
                    ),
                    actionButton3: ValueListenableBuilder(
                      valueListenable: waveMode,
                      builder: (context, waveModeFlag, child) => defaultButton(
                        adaptiveSize: adaptSize,
                        buttonText: "Asym",
                        textColor:
                            waveModeFlag == 3 ? Colors.white : Colors.black,
                        buttonColor: waveModeFlag == 3
                            ? Colors.lightBlue
                            : const Color.fromARGB(255, 200, 200, 200),
                        prefButtonHeight:
                            adaptSize.adaptHeight(desiredSize: 24),
                        prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                        actionFunc: () async {
                          waveMode.value = 3;
                          await deviceModeProviders.updateWaveMode(
                              waveMode: waveMode.value);
                        },
                      ),
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
                  actionButton1: ValueListenableBuilder(
                    valueListenable: viewingMode,
                    builder: (context, viewingModeFlag, child) => defaultButton(
                        adaptiveSize: adaptSize,
                        buttonText: "On",
                        textColor: viewingModeFlag == true
                            ? Colors.white
                            : Colors.black,
                        buttonColor: viewingModeFlag == true
                            ? Colors.green
                            : const Color.fromARGB(255, 200, 200, 200),
                        prefButtonHeight:
                            adaptSize.adaptHeight(desiredSize: 24),
                        prefButtonWidth: adaptSize.adaptWidth(desiredSize: 52),
                        actionFunc: () async {
                          viewingMode.value = true;
                          if (feedingMode.value != true) {
                            await deviceModeProviders.updateDeviceMode(
                                deviceMode: 2);
                          }
                        }),
                  ),
                  actionButton2: ValueListenableBuilder(
                      valueListenable: viewingMode,
                      builder: ((context, viewingModeFlag, child) {
                        return ValueListenableBuilder(
                          valueListenable: feedingMode,
                          builder: (context, feedingModeFlag, child) =>
                              defaultButton(
                            adaptiveSize: adaptSize,
                            buttonText: "Off",
                            textColor: viewingModeFlag == false
                                ? Colors.white
                                : Colors.black,
                            actionFunc: () async {
                              viewingMode.value = false;
                              if (feedingModeFlag == false) {
                                await deviceModeProviders.updateDeviceMode(
                                    deviceMode: 0);
                              }
                            },
                            buttonColor: viewingModeFlag == false
                                ? Colors.red
                                : const Color.fromARGB(255, 200, 200, 200),
                            prefButtonHeight:
                                adaptSize.adaptHeight(desiredSize: 24),
                            prefButtonWidth:
                                adaptSize.adaptWidth(desiredSize: 52),
                          ),
                        );
                      })),
                  imageProv: Assets.img.png.lightMode.provider(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: adaptSize.deviceSize.width,
          height: (adaptSize.deviceSize.height / 3) * 5 + 60,
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
                      adaptiveSize: adaptSize,
                      arrayOfSensor: parameterProviders.listOfensorModels,
                      chartHeight: 620,
                      chartName: "Sensor Reading"),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: adaptSize.adaptHeight(desiredSize: 20),
                  ),
                  child: waterChemistryChartView(
                    adaptiveSize: adaptSize,
                    arrayOfParameter: parameterProviders.waterChemistryModels,
                    chartHeight: 820,
                  ),
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
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingText1(
                        text: "Water Test Input", adaptiveSize: adaptSize),
                    const Spacer(),
                    statTextBox1(
                        textEditingController: alkalinityTextEditingController,
                        parameterText: "Alkalinity",
                        parameterValue: "999",
                        parameterScale: "Dkh",
                        maxValue: 100,
                        adaptiveSize: adaptSize,
                        context: context,
                        datePickerAttachment: true,
                        pickedDate: pickedParameterTestDate),
                    const Spacer(),
                    statTextBox1(
                        textEditingController: calciumTextEditingController,
                        parameterText: "Calcium",
                        parameterValue: "999",
                        parameterScale: "ppm",
                        maxValue: 1000,
                        adaptiveSize: adaptSize,
                        pickedDate: pickedParameterTestDate,
                        datePickerAttachment: false,
                        context: context),
                    const Spacer(),
                    statTextBox1(
                        textEditingController: magnesiumTextEditingController,
                        parameterText: "Magnesium",
                        parameterValue: "999",
                        parameterScale: "ppm",
                        maxValue: 1000,
                        adaptiveSize: adaptSize,
                        pickedDate: pickedParameterTestDate,
                        datePickerAttachment: false,
                        context: context),
                    const Spacer(),
                    statTextBox1(
                        textEditingController: salinityTextEditingController,
                        parameterText: "Salinity",
                        parameterValue: "1025",
                        parameterScale: "ppt",
                        maxValue: 2000,
                        adaptiveSize: adaptSize,
                        pickedDate: pickedParameterTestDate,
                        datePickerAttachment: false,
                        context: context),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                          right: adaptSize.adaptWidth(desiredSize: 20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          headingText2(
                              text: "Test Date", adaptiveSize: adaptSize),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            iconSize: adaptSize.adaptWidth(desiredSize: 24),
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2050));
                              pickedParameterTestDate.value = selectedDate;
                            },
                            icon: Icon(
                              Icons.date_range,
                              size: adaptSize.adaptHeight(desiredSize: 28),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: actionButton(
                        buttonText: "Upload",
                        textColor: Colors.white,
                        actionFunc: () async {
                          final isFormValid = formKey.currentState!.validate();
                          if (isFormValid) {
                            await parameterProviders.recordWaterChemistryLog(
                              inpWaterChemistryModel: WaterChemistryModel(
                                alkalinity: double.parse(
                                    alkalinityTextEditingController.text),
                                calcium: double.parse(
                                    calciumTextEditingController.text),
                                magnesium: double.parse(
                                    magnesiumTextEditingController.text),
                                salinity: double.parse(
                                    salinityTextEditingController.text),
                                dateTime: pickedParameterTestDate.value ??
                                    DateTime.now(),
                              ),
                            );
                            if (parameterProviders.dataCommStatus ==
                                DataCommStatus.success) {
                              // do something when success
                              alkalinityTextEditingController.clear();
                              calciumTextEditingController.clear();
                              magnesiumTextEditingController.clear();
                              salinityTextEditingController.clear();
                              parameterProviders.resetCommStatus();
                              parameterProviders.getWaterChemistryRecord();
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                    title: const Text("data not valid!"),
                                  );
                                });
                          }
                        },
                        adaptiveSize: adaptSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
