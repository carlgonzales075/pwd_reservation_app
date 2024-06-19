import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/stops.dart';

class TripViewer extends StatefulWidget {
  const TripViewer({super.key});

  @override
  State<TripViewer> createState() => _TripViewer();
}

class _TripViewer extends State<TripViewer> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  
  @override
  void dispose() {
    super.dispose();
    pickupController.dispose();
    destinationController.dispose();
  }

  @override
  Widget build (BuildContext context) {

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
            Consumer<StopsProvider>(
              builder: (context, stops, child) {
                pickupController.text = stops.stopNamePickUp ?? '';
                destinationController.text = stops.stopNameDestination ?? '';
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TripViewerText(
                      controller: pickupController,
                      labelText: 'Pickup'
                    ),
                    TripViewerText(
                      controller: destinationController,
                      labelText: 'Destination'
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

class TripViewerText extends StatelessWidget {
  const TripViewerText({
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