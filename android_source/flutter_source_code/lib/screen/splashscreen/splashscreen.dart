import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_source_code/screen/auth_screen/login_screen.dart';
import 'package:flutter_source_code/screen/home_screen/home_screen.dart';

import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/viewmodel/auth_viewmodel/authentication_viemodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewmodel>(context);
    AdaptiveSize adaptSize =
        AdaptiveSize(deviceSize: MediaQuery.of(context).size);
    return StreamBuilder(
        stream: authProvider.authStateChange,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: AnimatedSplashScreen(
                splash: Center(
                  child: SizedBox(
                    width: adaptSize.adaptWidth(desiredSize: 280),
                    height: adaptSize.adaptHeight(desiredSize: 280),
                    child: SvgPicture.asset("assets/img/svg/logo.svg"),
                  ),
                ),
                nextScreen: HomeScreen(),
              ),
            );
          } else {
            return LoginScreen();
          }
        }));
  }
}
