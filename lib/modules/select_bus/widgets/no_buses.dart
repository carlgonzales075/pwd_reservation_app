import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';

class NoBusesMessage extends StatelessWidget {
  const NoBusesMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/1791330.png',
          width: 100,
          height: 100,
          scale: 0.5,
        ),
        const Text(
          'We are very sorry!!!',
          style: TextStyle(
            fontSize: 24,
            color: CustomThemeColors.themeBlue,
            fontWeight: FontWeight.bold
          ),
        ),
        const Text(
          'We currently have no buses',
          style: TextStyle(
            fontSize: 16),
        ),
        const Text(
          'along this route :(((',
          style: TextStyle(
            fontSize: 16),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: CustomThemeColors.themeWhite,
                backgroundColor: CustomThemeColors.themeBlue
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/reservation');
              },
              child: const Text('Select Different Route')
            ),
          ],
        )
      ],
    );
  }
}