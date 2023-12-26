import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_source_code/screen/auth_screen/login_screen.dart';
import 'package:flutter_source_code/screen/auth_screen/register_screen.dart';
import 'package:flutter_source_code/screen/home_screen/home_screen.dart';
import 'package:flutter_source_code/screen/splashscreen/splashscreen.dart';
import 'package:flutter_source_code/viewmodel/auth_viewmodel/authentication_viemodel.dart';
import 'package:flutter_source_code/viewmodel/debug_viewmodel/debug_viewmodel.dart';
import 'package:flutter_source_code/viewmodel/device_mode_viewmodel/device_mode_viewmodel.dart';
import 'package:flutter_source_code/viewmodel/dosing_utility_viewmodel/dosing_utility_viewmodel.dart';
import 'package:flutter_source_code/viewmodel/light_utility_viewmodel/light_utility_viewmodel.dart';
import 'package:flutter_source_code/viewmodel/parameter_monitor_viewmodel/parameter_monitor_viewmodel.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainClass());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MainClass extends StatelessWidget {
  const MainClass({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
        ChangeNotifierProvider(create: (_) => ParameterViewModel()),
        ChangeNotifierProvider(create: (_) => LightUtilityViewModel()),
        ChangeNotifierProvider(create: (_) => DosingProfileViewModel()),
        ChangeNotifierProvider(create: (_) => DeviceModeViewModel()),
        ChangeNotifierProvider(create: (_) => DebugViewModel())
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        routes: {
          '/': (context) => const SplashScreen(),
          '/login_screen': (context) => const LoginScreen(),
          '/register_screen': (context) => const RegisterScreen(),
          '/home_screen': (context) => const HomeScreen(),
        },
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
