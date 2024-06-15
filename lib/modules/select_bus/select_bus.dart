import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/select_bus/widgets/maps.dart';

class SelectBusScreen extends StatelessWidget {
  const SelectBusScreen({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Bus',
          style: TextStyle(
            color: CustomThemeColors.themeWhite
          )
        ),
        backgroundColor: CustomThemeColors.themeBlue,
      ),
      body: const MapScreen(),
      bottomSheet: BottomSheet(
        builder: (BuildContext context) {
          return const Text('Sample');
        },
        showDragHandle: true,
        onClosing: () {

        }
      )
    );
  }
}