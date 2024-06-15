import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/stops.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/reservation/widgets/stops.dart';
import 'package:pwd_reservation_app/modules/reservation/widgets/trip_selector.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  bool isReversed = false;

  void _changeReversed() {
    setState(() {
      isReversed = !isReversed;
    });
  }

  @override
  Widget build (BuildContext context) {
    String routeLabel = !isReversed ? 'Northbound' : 'Southbound';
    return Scaffold(
      appBar: AppBar(
        title:  Consumer<StopsProvider> (
          builder: (context, stops, child) {
            return const Text(
              'Book a Trip',
              style: TextStyle(
                color: CustomThemeColors.themeWhite
              ),
            );
          },
        ),
        backgroundColor: CustomThemeColors.themeBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const TripSelector(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<StopsProvider>(
              builder: (context, stop, child) {
                return Visibility(
                  visible: stop.destinationId == null || stop.pickUpId == null,
                  maintainAnimation: false,
                  maintainSize: false,
                  child: Text(
                    'Selecting a '
                    '${stop.destinationId == null ? 'destination': ''}'
                    '${stop.destinationId == null && stop.pickUpId == null ? ' & ': ''}'
                    '${stop.pickUpId == null ? 'pickup': ''}...',
                    style: const TextStyle(
                      color: CustomThemeColors.themeBlue,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                );
              }
            ),
          ),
          Expanded(child: StopsListView(reverse: isReversed))
        ]
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: CustomThemeColors.themeBlue,
                shape: BoxShape.circle
              ),
              child: IconButton(
                color: CustomThemeColors.themeWhite,
                style: const ButtonStyle(elevation: WidgetStatePropertyAll(10.0)),
                onPressed: _changeReversed,
                icon: Icon(
                  isReversed ? Icons.arrow_downward_sharp : Icons.arrow_upward_sharp
                ),
              ),
            ),
            GestureDetector(
              onTap: _changeReversed,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  routeLabel,
                  style: const TextStyle(
                    color: CustomThemeColors.themeBlue,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ConfirmTripButton(
                  color: Colors.green,
                  onPressed: () {
                    Navigator.pushNamed(context, '/select-bus');
                  },
                  label: 'Confirm'
                ),
              ),
            ),
          ]
        )
      ],
    );
  }
}

class ConfirmTripButton extends StatelessWidget {
  const ConfirmTripButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.label
  });

  final VoidCallback onPressed;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Consumer<StopsProvider>(
      builder: (context, stop, child) {
        final bool enableButton = stop.stopNamePickUp != null && stop.stopNameDestination != null;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: color,
            foregroundColor: CustomThemeColors.themeWhite
          ),
          onPressed: enableButton ? onPressed : null,
          child: Text(label)
        );
      }
    );
  }
}