import 'dart:async';
import 'package:fers/database/userlocaldata.dart';
import 'package:fers/pages/driver_main_pages/driver_dashboard.dart';
import 'package:fers/pages/user_main_screen/main_screen.dart';
import 'package:flutter/material.dart';

import '../database/auth_methods.dart';
import 'auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () => nextpage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/splash.png'),
      ),
    );
  }

  nextpage() {
    if (AuthMethods.getCurrentUser != null) {
      if (UserLocalData.getIsDriver) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const DriverDashboard()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen()));
      }
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen()));
    }
  }
}
