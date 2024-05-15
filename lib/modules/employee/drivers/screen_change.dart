import 'package:flutter/material.dart';

class EmployeeScreenSwitcher extends ChangeNotifier {
  bool screenSwitchPassenger = true;

  void switchScreens() {
    screenSwitchPassenger = !screenSwitchPassenger;
    notifyListeners();
  }

  void resetSwitcher() {
    screenSwitchPassenger = true;
  }
}