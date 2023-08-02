import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_source_code/gen/assets.gen.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/utility/image_circle.dart';
import 'package:flutter_source_code/widget/mode_widget.dart';

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
                      imageProv: Assets.img.png.feedingMode.provider()
                          as ImageProvider),
                ),
              ),
              Divider(
                color: Colors.black,
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
                      imageProv:
                          Assets.img.png.waveMode.provider() as ImageProvider),
                ),
              ),
              Divider(
                color: Colors.black,
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
                      imageProv:
                          Assets.img.png.lightMode.provider() as ImageProvider),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 2,
              ),
            ],
          )),
    );
  }
}
