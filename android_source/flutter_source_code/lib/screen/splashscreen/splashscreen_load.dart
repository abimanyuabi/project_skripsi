import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/viewmodel/device_mode_viewmodel/device_mode_viewmodel.dart';
import 'package:flutter_source_code/viewmodel/dosing_utility_viewmodel/dosing_utility_viewmodel.dart';
import 'package:flutter_source_code/viewmodel/light_utility_viewmodel/light_utility_viewmodel.dart';
import 'package:flutter_source_code/viewmodel/parameter_monitor_viewmodel/parameter_monitor_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashScreenLoad extends StatefulWidget {
  const SplashScreenLoad({super.key});

  @override
  State<SplashScreenLoad> createState() => _SplashScreenLoadState();
}

class _SplashScreenLoadState extends State<SplashScreenLoad> {
  @override
  void initState() {
    super.initState();
    final parameterProviders =
        Provider.of<ParameterViewModel>(context, listen: false);
    final dosingProviders =
        Provider.of<DosingProfileViewModel>(context, listen: false);
    final ledProfileProviders =
        Provider.of<LightUtilityViewModel>(context, listen: false);
    final deviceModeProviders =
        Provider.of<DeviceModeViewModel>(context, listen: false);
    if (parameterProviders.isUserExists) {
      Future.delayed(Duration.zero, (() {
        parameterProviders.getWaterChemistryRecord();
        dosingProviders.getDosingLog();
        parameterProviders.getNewSensorDataRTDB();
        ledProfileProviders.getLedProfile();
        deviceModeProviders.getDeviceMode();
      }));

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        Navigator.pushNamed(context, '/home_screen');
      });
    } else {
      Navigator.pushNamed(context, '/login_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    AdaptiveSize adaptSize =
        AdaptiveSize(deviceSize: MediaQuery.of(context).size);
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: adaptSize.adaptWidth(desiredSize: 200),
        height: adaptSize.adaptHeight(desiredSize: 200),
        child: const CircularProgressIndicator(),
      )),
    );
  }
}
