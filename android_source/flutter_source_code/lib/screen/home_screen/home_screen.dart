import 'package:flutter/material.dart';
import 'package:flutter_source_code/screen/light_utility_screen/light_utility_screen.dart';
import 'package:flutter_source_code/screen/main_screen/main_screen.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<int> pageIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    AdaptiveSize adaptSize =
        AdaptiveSize(deviceSize: MediaQuery.of(context).size);
    List<Widget> listOfBody = [
      mainScreen(adaptSize: adaptSize),
      lightUtilityScreen(adaptSize: adaptSize)
    ];
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: ((context, pageIndexValue, child) =>
            listOfBody[pageIndexValue]),
      ),
      bottomNavigationBar: SizedBox(
        height: (adaptSize.adaptHeight(desiredSize: 64)),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb), label: "light"),
            BottomNavigationBarItem(
                icon: Icon(Icons.heat_pump), label: "dosing")
          ],
          onTap: ((int newIndex) {
            pageIndex.value = newIndex;
          }),
        ),
      ),
    );
  }
}
