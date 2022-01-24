import 'package:fers/database/auth_methods.dart';
import 'package:fers/database/userlocaldata.dart';
import 'package:fers/pages/driver_dashboard.dart';
import 'package:fers/pages/register_person.dart';
import 'package:fers/pages/registeration_type_screen.dart';
import 'package:fers/widgets/button_widget.dart';
import 'package:fers/widgets/custom_textformfield.dart';
import 'package:fers/widgets/custom_toast.dart';
import 'package:fers/widgets/custom_validator.dart';
import 'package:fers/widgets/password_textformfield.dart';
import 'package:fers/widgets/show_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard.dart';
import 'forgot_password_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xff151f2c) : Colors.white,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.02),
                        child: Align(
                          child: Text(
                            'Hey there,',
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xff1D1617),
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.09),
                        child: Align(
                          child: Text(
                            'Welcome Back',
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xff1D1617),
                              fontSize: size.height * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.01),
                      ),
                      Form(
                        key: _key,
                        child: Column(
                          children: <Widget>[
                            CustomTextFormField(
                              title: 'Email',
                              controller: _email,
                              hint: 'test@test.com',
                              validator: (String? value) =>
                                  CustomValidator.email(value),
                            ),
                            PasswordTextFormField(
                              controller: _password,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.015,
                          vertical: size.height * 0.025,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage()),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: size.height * 0.03),
                            child: Text(
                              "Forgot your password?",
                              style: TextStyle(
                                color: const Color(0xffADA4A5),
                                decoration: TextDecoration.underline,
                                fontSize: size.height * 0.02,
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.only(top: size.height * 0.025),
                        child: ButtonWidget(
                          text: "Login",
                          backColor: isDarkMode
                              ? [
                                  Colors.black,
                                  Colors.black,
                                ]
                              : const [Color(0xff92A3FD), Color(0xff9DCEFF)],
                          textColor: const [
                            Colors.white,
                            Colors.white,
                          ],
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              showLoadingDislog(context);
                              final User? _user =
                                  await AuthMethods().loginWithEmailAndPassword(
                                _email.text,
                                _password.text,
                              );
                              if (_user != null) {
                                if (UserLocalData.getIsDriver) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const DriverDashboard()));
                                } else {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const ContainerWidget()));
                                }
                              } else {
                                CustomToast.errorToast(
                                    message: "Invalid Password or Username");
                                Navigator.of(context).pop();
                              }
                            }
                          },
                        ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.only(
                          top: size.height * 0.15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'FERS',
                              style: GoogleFonts.poppins(
                                color: isDarkMode ? Colors.white : Colors.blue,
                                fontSize: size.height * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '+',
                              style: GoogleFonts.poppins(
                                color: Colors.redAccent,
                                fontSize: size.height * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don’t have an account yet? ",
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xff1D1617),
                                fontSize: size.height * 0.018,
                              ),
                            ),
                            WidgetSpan(
                              child: InkWell(
                                onTap: () => {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const RegisterationTypeScreen()))
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: <Color>[
                                          Color(0xffEEA4CE),
                                          Color(0xffC58BF2),
                                        ],
                                      ).createShader(
                                        const Rect.fromLTWH(
                                            0.0, 0.0, 200.0, 70.0),
                                      ),
                                    // color: const Color(0xffC58BF2),
                                    fontSize: size.height * 0.018,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
