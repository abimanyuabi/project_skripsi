import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_source_code/screen/auth_screen/login_screen.dart';
import 'package:flutter_source_code/screen/auth_screen/register_screen.dart';
import 'package:flutter_source_code/screen/home_screen/home_screen.dart';
import 'package:flutter_source_code/screen/splashscreen/splashscreen.dart';
import 'package:flutter_source_code/viewmodel/auth_viewmodel/authentication_viemodel.dart';
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
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        routes: {
          '/': (context) => SplashScreen(),
          '/login_screen': (context) => LoginScreen(),
          '/register_screen': (context) => RegisterScreen(),
          '/home_screen': (context) => HomeScreen(),
        },
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
