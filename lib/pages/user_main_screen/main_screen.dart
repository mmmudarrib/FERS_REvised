import 'package:fers/pages/user_main_screen/main_pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import 'main_pages/dashboard.dart';
import 'main_bottom_navigation_bar.dart';
import 'main_pages/record.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String rotueName = '/MainScrenn';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  static const List<Widget> _pages = <Widget>[
    ContainerWidget(),
    RecordScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    AppProvider _provider = Provider.of<AppProvider>(context);
    int _currentIndex = _provider.currentBottonTap;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
