import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_selected.dart';

class RfidInfoCard extends StatelessWidget {
  const RfidInfoCard({super.key});

  @override
  Widget build (BuildContext context) {
    return Consumer<PassengerProvider>(
      builder: (context, passenger, child) {
        if (passenger.isWaiting == true) {
          return const Card(
            color: CustomThemeColors.themeBlue,
            child: SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  'Don\'t forget to tap your RFID to open your seat!',
                  style: TextStyle(
                    color: CustomThemeColors.themeWhite
                  ),
                ),
              ),
            ),
          );
        } else if (passenger.isOnRoute == true) {
          return const Card(
            color: CustomThemeColors.themeBlue,
            child: SizedBox(
              height: 80,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'Your seat is now open! Tap the RFID again to close it before alighting the bus.',
                    style: TextStyle(
                      color: CustomThemeColors.themeWhite
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Card(
            color: CustomThemeColors.themeBlue,
            child: SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  'You are currently not reserved to any seats.',
                  style: TextStyle(
                    color: CustomThemeColors.themeWhite
                  ),
                ),
              ),
            ),
          );
        }
      }
    );
  }
}