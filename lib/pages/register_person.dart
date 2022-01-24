import 'package:fers/database/auth_methods.dart';
import 'package:fers/database/user_api.dart';
import 'package:fers/models/appuser.dart';
import 'package:fers/widgets/button_widget.dart';
import 'package:fers/widgets/custom_textformfield.dart';
import 'package:fers/widgets/custom_toast.dart';
import 'package:fers/widgets/custom_validator.dart';
import 'package:fers/widgets/password_textformfield.dart';
import 'package:fers/widgets/show_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterPerson extends StatefulWidget {
  const RegisterPerson({Key? key}) : super(key: key);

  @override
  _RegisterPersonState createState() => _RegisterPersonState();
}

class _RegisterPersonState extends State<RegisterPerson> {
  late Position _currentPosition;
  bool checkedValue = false;
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confPassword = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool permission = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

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
                        padding: EdgeInsets.only(top: size.height * 0.01),
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
                            'Create an Account Users',
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
                              title: 'First Name',
                              hint: 'First Name',
                              controller: _firstName,
                              validator: (String? value) =>
                                  CustomValidator.lessThen3(value),
                            ),
                            CustomTextFormField(
                              title: 'Last Name',
                              hint: 'Last Name',
                              controller: _lastName,
                              validator: (String? value) =>
                                  CustomValidator.lessThen3(value),
                            ),
                            CustomTextFormField(
                              title: 'email',
                              hint: 'test@test.com',
                              controller: _email,
                              validator: (String? value) =>
                                  CustomValidator.email(value),
                            ),
                            PasswordTextFormField(controller: _password),
                            PasswordTextFormField(
                              controller: _confPassword,
                              title: 'Repeat Password',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.015,
                          vertical: size.height * 0.025,
                        ),
                        child: CheckboxListTile(
                          title: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "By creating an account, you agree to our ",
                                  style: TextStyle(
                                    color: const Color(0xffADA4A5),
                                    fontSize: size.height * 0.015,
                                  ),
                                ),
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () {
                                      // ignore: avoid_print
                                      print('Conditions of Use');
                                    },
                                    child: Text(
                                      "Conditions of Use",
                                      style: TextStyle(
                                        color: const Color(0xffADA4A5),
                                        decoration: TextDecoration.underline,
                                        fontSize: size.height * 0.015,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: " and ",
                                  style: TextStyle(
                                    color: const Color(0xffADA4A5),
                                    fontSize: size.height * 0.015,
                                  ),
                                ),
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () {
                                      // ignore: avoid_print
                                      print('Privacy Notice');
                                    },
                                    child: Text(
                                      "Privacy Notice",
                                      style: TextStyle(
                                        color: const Color(0xffADA4A5),
                                        decoration: TextDecoration.underline,
                                        fontSize: size.height * 0.015,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          activeColor: const Color(0xff7B6F72),
                          value: checkedValue,
                          onChanged: (newValue) {
                            setState(() {
                              checkedValue = newValue!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.only(top: size.height * 0.025),
                        child: ButtonWidget(
                          text: "Register",
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
                            LocationUser loc = LocationUser(
                                lat: _currentPosition.latitude,
                                long: _currentPosition.longitude);
                            if (_key.currentState!.validate()) {
                              if (_password.text == _confPassword.text) {
                                showLoadingDislog(context);
                                final User? _user = await AuthMethods()
                                    .signupWithEmailAndPassword(
                                  email: _email.text,
                                  password: _password.text,
                                );
                                if (_user != null) {
                                  final AppUser _appUser = AppUser(
                                    uid: _user.uid,
                                    firstName: _firstName.text,
                                    lastName: _lastName.text,
                                    email: _email.text,
                                    isDriver: false,
                                    location: loc,
                                  );
                                  final bool _okay =
                                      await UserAPI().addUser(_appUser);
                                  if (_okay) {
                                    CustomToast.successToast(
                                      message: 'Register Successfully',
                                    );
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const LoginScreen()));
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                }
                              } else {
                                CustomToast.errorToast(
                                  message:
                                      'Password and Repeat password are not same!!',
                                );
                              }
                            }
                          },
                        ),
                      ),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.only(top: size.height * 0.025),
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
                              text: "Already have an account? ",
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xff1D1617),
                                fontSize: size.height * 0.018,
                              ),
                            ),
                            WidgetSpan(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const LoginScreen()));
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: <Color>[
                                          Color(0xffEEA4CE),
                                          Color(0xffC58BF2),
                                        ],
                                      ).createShader(
                                        const Rect.fromLTWH(
                                          0.0,
                                          0.0,
                                          200.0,
                                          70.0,
                                        ),
                                      ),
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

  _getCurrentLocation() async {
    requestLocationPermission();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {
      setState(() {
        permission = true;
      });
    } else if (status == PermissionStatus.denied) {
      setState(() {
        permission = false;
      });
    } else if (status == PermissionStatus.permanentlyDenied) {
      setState(() {
        permission = false;
      });
      await openAppSettings();
    }
  }
}
