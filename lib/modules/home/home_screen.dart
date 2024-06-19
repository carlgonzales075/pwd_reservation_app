import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/home/widgets/body.dart';
import 'package:pwd_reservation_app/modules/home/widgets/header.dart';
import 'package:pwd_reservation_app/modules/home/widgets/side_menu.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/passengers.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/reservations.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    _startPeriodicUpdates(context, 60);
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: CustomThemeColors.themeBlue,
        foregroundColor: CustomThemeColors.themeWhite,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              DirectusAuth directusAuth = DirectusAuth(context);
              directusAuth.logOutDialog(context);
            },
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      drawer: const NavDrawer(),
      body: const SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            HomeScreenHeader(),
            HomeScreenBody(),
          ],
        ),
      ),
    );
  }

  void _startPeriodicUpdates(BuildContext context, int seconds) {
    _timer = Timer.periodic(Duration(seconds: seconds), (timer) async {
      await refreshSeatStatus(context);
    });
  }

  Future<void> refreshSeatStatus(BuildContext context) async {
    final Passengers updatedPassenger = await Passengers.getPassenger(context);
    if (context.mounted) {
      context.read<PassengerProvider>().initPassenger(
        id: updatedPassenger.id,
        passengerType: updatedPassenger.passengerType,
        disabilityInfo: updatedPassenger.disabilityInfo,
        seatAssigned: updatedPassenger.seatAssigned,
        isWaiting: updatedPassenger.isWaiting,
        isOnRoute: updatedPassenger.isOnRoute
      );
      if (context.read<ReservationProvider>().distance != null) {
        try {
          final reservation = await getReservationInfo(
            context, context.read<PassengerProvider>().seatAssigned as String);
          if (context.mounted) {
            context.read<ReservationProvider>().initReservation(
              reservation.seatName,
              reservation.routeName,
              reservation.vehicleName,
              reservation.busStopName,
              reservation.distance
            );
          }
        } catch (e) {
          if (context.mounted) {
            context.read<ReservationProvider>().resetReservation();
            CustomDialogs.customInfoDialog(
              context,
              'We have arrived!',
              'Please alight the bus safely. Do not hesitate to ask assistance.',
              () {}
            );
          }
        }
      }
    }
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CredentialsProvider>(
      builder: (context, credentials, child) {
      return IconButton(
      onPressed: () {
        DirectusAuth directusAuth = DirectusAuth(context);
        directusAuth.logOut(credentials.refreshToken);
      },
      icon: const Icon(
        Icons.logout,
        color: CustomThemeColors.themeWhite,
      )
    );},
        );
  }
}