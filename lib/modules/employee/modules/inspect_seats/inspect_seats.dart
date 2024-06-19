import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/widgets/notif_modal.dart';
import 'package:pwd_reservation_app/modules/employee/modules/inspect_seats/drivers/last_update.dart';
import 'package:pwd_reservation_app/modules/employee/modules/inspect_seats/widgets/seats.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class InspectSeatsScreen extends StatelessWidget {
  const InspectSeatsScreen({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pushNamedAndRemoveUntil(context, '/employee-home', (route) => false);
            LastUpdate hasUpdates = await checkUpdates(
              context,
              context.read<VehicleRouteInfoProvider>().vehicleId as String,
              DateTime.now(),
              context.read<UserProvider>().userId as String
            );
            if (context.mounted) {
              context.read<LastUpdateProvider>().initNow(
                hasUpdates.updates,
                hasUpdates.updates,
                hasUpdates.showNotif
              );
            }
          },
        ),
        title: const Text('Bus Seats'),
        backgroundColor: CustomThemeColors.themeBlue,
        foregroundColor: CustomThemeColors.themeWhite,
      ),
      body: Stack(
        children: [
          const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LegendLabels(color: Colors.green, label: 'Vacant'),
                  LegendLabels(color: Colors.amber, label: 'Reserved'),
                  LegendLabels(color: Colors.grey, label: 'Occupied')
                ],
              ),
              Expanded(child: SeatsGrid()),
            ],
          ),
          if (context.read<LastUpdateProvider>().showNotif as bool)
            const Align(
              alignment: Alignment.topCenter,
              child: NotifModal(
                id: 'notif1'
              ),
            )
        ],
      ),
    );
  }
}

class LegendLabels extends StatelessWidget {
  const LegendLabels({
    super.key,
    required this.color,
    required this.label
  });

  final Color color;
  final String label;

  @override
  Widget build (BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.circle,
          color: color,
          size: 10,
        ),
        Text(label)
      ],
    );
  }
}