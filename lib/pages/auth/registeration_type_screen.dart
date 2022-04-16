import 'package:fers/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'register_driver.dart';
import 'register_person.dart';

class RegisterationTypeScreen extends StatelessWidget {
  const RegisterationTypeScreen({Key? key}) : super(key: key);
  static const String routeName = '/RegisterTypeScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Account Type',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Select the type of the account',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextButton(
              text: 'PERSONAL'.toUpperCase(),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const RegisterPerson()));
              },
            ),
            const SizedBox(height: 10),
            CustomTextButton(
              text: 'DRIVER'.toUpperCase(),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const RegisterDriver()));
              },
              hollowButton: false,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen()));
              },
              child: const Text(
                'Back to Login',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
