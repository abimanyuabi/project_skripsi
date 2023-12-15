import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/widget/default_button.dart';
import 'package:flutter_source_code/widget/default_text.dart';
import 'package:flutter_source_code/widget/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AdaptiveSize adaptSize =
        AdaptiveSize(deviceSize: MediaQuery.of(context).size);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: adaptSize.adaptWidth(desiredSize: 320),
          height: adaptSize.adaptHeight(desiredSize: 320),
          child: Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(
                  width: adaptSize.adaptWidth(desiredSize: 260),
                  child: defaultTextField(
                      adaptiveSize: adaptSize,
                      textEditingController: registerEmailController,
                      label: bodyText2(text: "email", adaptiveSize: adaptSize)),
                ),
                Spacer(),
                SizedBox(
                  width: adaptSize.adaptWidth(desiredSize: 260),
                  child: defaultTextField(
                      adaptiveSize: adaptSize,
                      textEditingController: registerPasswordController,
                      label:
                          bodyText2(text: "password", adaptiveSize: adaptSize)),
                ),
                Spacer(),
                SizedBox(
                  width: adaptSize.adaptWidth(desiredSize: 100),
                  height: adaptSize.adaptHeight(desiredSize: 28),
                  child: defaultButton(
                      textColor: Colors.white,
                      buttonColor: Colors.blueAccent,
                      buttonText: "Register",
                      actionFunc: () {
                        Navigator.pop(context);
                      },
                      prefButtonWidth: adaptSize.adaptWidth(desiredSize: 120),
                      prefButtonHeight: adaptSize.adaptHeight(desiredSize: 28),
                      adaptiveSize: adaptSize),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
