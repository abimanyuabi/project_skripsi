import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_source_code/screen/home_screen/home_screen.dart';

import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    AdaptiveSize adaptSize =
        AdaptiveSize(deviceSize: MediaQuery.of(context).size);
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Center(
          child: SizedBox(
            width: adaptSize.adaptWidth(desiredSize: 260),
            height: adaptSize.adaptHeight(desiredSize: 260),
            child: SvgPicture.asset("assets/img/svg/logo.svg"),
          ),
        ),
        nextScreen: const HomeScreen(),
      ),
    );
  }
}
