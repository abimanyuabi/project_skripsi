import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_source_code/utility/adaptsize.dart';
import 'package:flutter_source_code/utility/enums.dart';
import 'package:flutter_source_code/viewmodel/auth_viewmodel/authentication_viemodel.dart';
import 'package:flutter_source_code/widget/default_button.dart';
import 'package:flutter_source_code/widget/default_text.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewmodel>(context);
    AdaptiveSize adaptSize =
        AdaptiveSize(deviceSize: MediaQuery.of(context).size);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            width: adaptSize.adaptWidth(desiredSize: 320),
            height: adaptSize.adaptHeight(desiredSize: 320),
            child: Card(
              elevation: 4,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: adaptSize.adaptWidth(desiredSize: 260),
                      child: TextFormField(
                        maxLength: 25,
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) => email == null ||
                                !EmailValidator.validate(_emailController.text)
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
                    Spacer(),
                    SizedBox(
                        width: adaptSize.adaptWidth(desiredSize: 260),
                        child: ValueListenableBuilder(
                            valueListenable: _isPasswordVisible,
                            builder: ((context, value, child) {
                              return TextFormField(
                                maxLength: 12,
                                obscureText: !value,
                                controller: _passwordController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (password) => password == null ||
                                        _passwordController.text.length < 8
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
                                    fontSize:
                                        adaptSize.adaptHeight(desiredSize: 10),
                                  ),
                                  label: bodyText1(
                                      text: "password",
                                      adaptiveSize: adaptSize),
                                ),
                              );
                            }))),
                    Padding(
                      padding: EdgeInsets.only(
                          right: adaptSize.adaptWidth(desiredSize: 18)),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register_screen');
                            },
                            child: Text(
                              "don't have an account yet?",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize:
                                      adaptSize.adaptHeight(desiredSize: 11),
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: adaptSize.adaptWidth(desiredSize: 100),
                      height: adaptSize.adaptHeight(desiredSize: 28),
                      child: defaultButton(
                          textColor: Colors.white,
                          buttonColor: Colors.blueAccent,
                          buttonText: "login",
                          actionFunc: () async {
                            final isValid = _formKey.currentState!.validate();
                            if (isValid) {
                              await authProvider.authLogin(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                              if (authProvider.authStatus ==
                                  AuthStatus.failed) {
                                showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return AlertDialog(
                                        title: const Text('login error'),
                                        content: const Text(
                                            'invalid email or passwords'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    }));
                              }
                            } else {
                              print("not valid");
                              Text("form not valid");
                            }
                          },
                          prefButtonWidth:
                              adaptSize.adaptWidth(desiredSize: 120),
                          prefButtonHeight:
                              adaptSize.adaptHeight(desiredSize: 28),
                          adaptiveSize: adaptSize),
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
