import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/stops.dart';

class TripSelector extends StatefulWidget {
  const TripSelector({super.key});

  @override
  State<TripSelector> createState() => _TripSelector();
}

class _TripSelector extends State<TripSelector> {
  @override
  Widget build (BuildContext context) {
    TextEditingController pickupController = TextEditingController();
    TextEditingController destinationController = TextEditingController();

    return Container(
      decoration: const BoxDecoration(
        color: CustomThemeColors.themeBlue
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Where do we go now?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomThemeColors.themeWhite
              ),
            ),
            Consumer<StopsProvider>(
              builder: (context, stops, child) {
                pickupController.text = stops.stopNamePickUp ?? '';
                destinationController.text = stops.stopNameDestination ?? '';
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Visibility(
                      visible: stops.stopNameDestination != null || stops.stopNamePickUp != null,
                      child: TripSelectionText(
                        controller: pickupController,
                        labelText: 'Where should we pick you up?'
                      ),
                    ),
                    TripSelectionText(
                      controller: destinationController,
                      labelText: 'Where is your destination?'
                    ),
                  ]
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class TripSelectionText extends StatelessWidget {
  const TripSelectionText({
    super.key,
    required this.labelText,
    required this.controller
  });

  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        readOnly: true,
        controller: controller,
        style: const TextStyle(
          fontWeight: FontWeight.bold
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: CustomThemeColors.themeWhite,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 17
            ),
            borderRadius: BorderRadius.circular(9.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 17
            ),
            borderRadius: BorderRadius.circular(9.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 17
            ),
            borderRadius: BorderRadius.circular(9.0),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: CustomThemeColors.themeBlue,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}