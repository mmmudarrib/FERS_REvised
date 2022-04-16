import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  int _bottonTap = 0;
  int get currentBottonTap => _bottonTap;

  void updateBottomTap(int update) {
    _bottonTap = update;
    notifyListeners();
  }
}
