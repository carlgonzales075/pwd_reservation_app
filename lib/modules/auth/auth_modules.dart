import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/login/login.dart';

class MainAuthScreen extends StatelessWidget {
  const MainAuthScreen({super.key}); 

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: Container(
        color: CustomThemeColors.themeBlue,
        child: const LoginPage(),
      )
    );
  }
}