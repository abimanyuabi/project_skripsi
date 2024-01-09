import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/utility/enums.dart';
import 'package:flutter_source_code/viewmodel/auth_viewmodel/authentication_viemodel.dart';
import 'package:flutter_source_code/widget/default_button.dart';
import 'package:flutter_source_code/widget/default_text.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewmodel>(context);
    AdaptiveSize adaptSize =
        AdaptiveSize(deviceSize: MediaQuery.of(context).size);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: adaptSize.adaptWidth(desiredSize: 320),
          height: adaptSize.adaptHeight(desiredSize: 340),
          child: Form(
            key: _formKey,
            child: Card(
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SizedBox(
                    width: adaptSize.adaptWidth(desiredSize: 260),
                    child: TextFormField(
                      maxLength: 25,
                      controller: _registerEmailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) => email == null ||
                              !EmailValidator.validate(
                                  _registerEmailController.text)
                          ? "enter valid email"
                          : null,
                      decoration: InputDecoration(
                        hintText: "examplehehe@email.com",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: adaptSize.adaptHeight(desiredSize: 10),
                        ),
                        label:
                            bodyText1(text: "email", adaptiveSize: adaptSize),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: adaptSize.adaptWidth(desiredSize: 260),
                    child: ValueListenableBuilder(
                      valueListenable: _isPasswordVisible,
                      builder: ((context, value, child) {
                        return TextFormField(
                          maxLength: 12,
                          obscureText: !value,
                          controller: _registerPasswordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (password) => password == null ||
                                  _registerPasswordController.text.length < 8
                              ? "password needs to be 8-12 character"
                              : null,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                _isPasswordVisible.value = !value;
                              },
                              icon: value
                                  ? Icon(
                                      Icons.visibility_off,
                                      size: adaptSize.adaptHeight(
                                          desiredSize: 18),
                                      color: Colors.grey,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      size: adaptSize.adaptHeight(
                                          desiredSize: 18),
                                    ),
                            ),
                            hintText: "********",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: adaptSize.adaptHeight(desiredSize: 10),
                            ),
                            label: bodyText1(
                                text: "password", adaptiveSize: adaptSize),
                          ),
                        );
                      }),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                        right: adaptSize.adaptWidth(desiredSize: 18)),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "already have account?",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize:
                                    adaptSize.adaptHeight(desiredSize: 11),
                                fontWeight: FontWeight.w400),
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: adaptSize.adaptHeight(desiredSize: 20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: adaptSize.adaptWidth(desiredSize: 40),
                          ),
                          child: SizedBox(
                            width: adaptSize.adaptWidth(desiredSize: 100),
                            height: adaptSize.adaptHeight(desiredSize: 28),
                            child: defaultButton(
                                textColor: Colors.white,
                                buttonColor: Colors.blueAccent,
                                buttonText: "Register",
                                actionFunc: () async {
                                  final isValid =
                                      _formKey.currentState!.validate();
                                  if (isValid) {
                                    await authProvider.authRegister(
                                        email: _registerEmailController.text,
                                        password:
                                            _registerPasswordController.text);
                                    if (authProvider.authStatus ==
                                        AuthStatus.success) {
                                      Navigator.pop(context);
                                    } else if (authProvider.authStatus ==
                                        AuthStatus.failed) {
                                      showDialog(
                                        context: context,
                                        builder: ((context) {
                                          return AlertDialog(
                                            title: const Center(
                                                child: Text('login error')),
                                            content: Text(
                                              authProvider.failReason,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'OK'),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        }),
                                      );
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return AlertDialog(
                                          title: const Center(
                                              child: Text('login error')),
                                          content: const Text(
                                            "invalid form",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: (() {
                                                authProvider
                                                    .resetConnectionMessege();
                                                Navigator.pop(context, 'OK');
                                              }),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  }
                                },
                                prefButtonWidth:
                                    adaptSize.adaptWidth(desiredSize: 120),
                                prefButtonHeight:
                                    adaptSize.adaptHeight(desiredSize: 28),
                                adaptiveSize: adaptSize),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(
                            right: adaptSize.adaptWidth(desiredSize: 40),
                          ),
                          child: SizedBox(
                            width: adaptSize.adaptWidth(desiredSize: 100),
                            height: adaptSize.adaptHeight(desiredSize: 28),
                            child: defaultButton(
                                textColor: Colors.grey,
                                buttonColor: Colors.white,
                                buttonBorderSideColor: Colors.grey,
                                buttonText: "exit",
                                actionFunc: () {
                                  exit(0);
                                },
                                prefButtonWidth:
                                    adaptSize.adaptWidth(desiredSize: 120),
                                prefButtonHeight:
                                    adaptSize.adaptHeight(desiredSize: 28),
                                adaptiveSize: adaptSize),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
