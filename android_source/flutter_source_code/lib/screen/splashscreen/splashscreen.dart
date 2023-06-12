import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_source_code/screen/home_screen/home_screen.dart';

import 'package:flutter_source_code/utility/adaptsize.dart';

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
            height: adaptSize.adaptHeight(desiredSide: 260),
            child: const Icon(Icons.abc),
          ),
        ),
        nextScreen: const HomeScreen(),
      ),
    );
  }
}
