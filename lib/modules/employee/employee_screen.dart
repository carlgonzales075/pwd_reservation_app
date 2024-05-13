import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_selected.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/routes.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(''),
        backgroundColor: CustomThemeColors.themeBlue,
        foregroundColor: CustomThemeColors.themeWhite,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              logOut(
                context.read<CredentialsProvider>().refreshToken,
                context.read<DomainProvider>().url as String
              );
              context.read<CredentialsProvider>().resetValues();
              context.read<StopsProvider>().resetValues();
              context.read<PassengerProvider>().resetPassenger();
              context.read<ReservationProvider>().resetReservation();
              Navigator.pushNamed(context, '/');
            },
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Vehicle Info'),
          Card(child: Column(
            children: <Widget>[
              Text('Should contain the vehicle name and plate number'),
              Text('Should show the number of available seats also'),
              Text('If no vehicle assigned, show not assigned to any vehicles'),
            ],
          )),
          Text('Driver Info'),
          Card(child: Column(
            children: <Widget>[
              Text('Show the driver name if available'),
              Text('If no vehicle assigned, do not show this feature')
            ],
          )),
          Text('Conductor Info'),
          Card(child: Column(
            children: <Widget>[
              Text('Show the conductor name if available'),
              Text('If no vehicle assigned, do not show this feature')
            ],
          )),
          Text('Next Stop'),
          Card(child: Column(
            children: <Widget>[
              Text('Show the next stop if available'),
              Text('If there are no more stops next, show in the last stop'),
              Text('If no vehicle assigned, do not show this feature')
            ],
          )),
          Text('Arrive/Depart'),
          Card(child: Column(
            children: <Widget>[
              Text('Show buttons for updating the arrival and departure status'),
              Text('If no vehicle assigned, do not show this feature')
            ],
          ))
        ],
      )
    );
  }
}