import 'package:fers/widgets/button_widget.dart';
import 'package:fers/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../database/auth_methods.dart';
import '../../widgets/custom_toast.dart';
import '../../widgets/custom_validator.dart';
import 'login.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _email = TextEditingController();
  final _key = GlobalKey<FormState>();

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
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.025),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () =>
                                  Navigator.pop(context), //go back to authPage
                              child: Icon(
                                Icons.arrow_back,
                                color: isDarkMode ? Colors.white : Colors.black,
                                size: size.height * 0.03,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.015,
                              ),
                              child: Text(
                                'Back',
                                style: GoogleFonts.poppins(
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xff1D1617),
                                  fontSize: size.height * 0.018,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.05,
                          left: size.width * 0.055,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Reset password',
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xff1D1617),
                              fontSize: size.height * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.055),
                        child: Align(
                          child: Text(
                            "Forgot your password? That's okay, it happens to everyone!\nPlease provide your email to reset your password.",
                            style: GoogleFonts.poppins(
                              color:
                                  isDarkMode ? Colors.white54 : Colors.black54,
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _key,
                        child: CustomTextFormField(
                          title: 'Email',
                          controller: _email,
                          hint: 'test@test.com',
                          validator: (String? value) =>
                              CustomValidator.email(value),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.025),
                        child: ButtonWidget(
                            text: 'Send Instruction',
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
                                final bool sended = await AuthMethods()
                                    .forgetPassword(_email.text);

                                if (sended) {
                                  CustomToast.showSnackBar(
                                      context: context,
                                      text:
                                          'Email send at ${_email.text.trim()}');
                                  if (!mounted) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                }
                              }
                            }),
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
