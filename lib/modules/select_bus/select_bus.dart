import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/select_bus/widgets/bus_selector.dart';
import 'package:pwd_reservation_app/modules/select_bus/widgets/maps.dart';
import 'package:pwd_reservation_app/modules/select_bus/widgets/trip_viewer.dart';

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
      body: const Stack(
        children: [
          MapScreen(),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Column(
              children: [
                TripViewer(),
              ],
            ),
          )
        ],
      ),
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: CustomThemeColors.themeWhite,
            backgroundColor: CustomThemeColors.themeBlue,
            minimumSize: const Size.fromHeight(50)
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return const BusSelector();
              }
            );
          },
          child: const Text('Show Buses')
        )
      ],
    );
  }
}