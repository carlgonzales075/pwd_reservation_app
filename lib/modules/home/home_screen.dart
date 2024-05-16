import 'package:flutter/material.dart';
// import 'package:pwd_reservation_app/modules/home/footer_menu/footer_menu.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/dispatch_info.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/partner_employee.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/screen_change.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/home/body/booking_info_card.dart';
import 'package:pwd_reservation_app/modules/home/side_menu.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_selected.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/routes.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
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
              logOut(
                context.read<CredentialsProvider>().refreshToken,
                context.read<DomainProvider>().url as String
              );
              context.read<CredentialsProvider>().resetValues();
              context.read<StopsProvider>().resetValues();
              context.read<PassengerProvider>().resetPassenger();
              context.read<ReservationProvider>().resetReservation();
              context.read<EmployeeScreenSwitcher>().resetSwitcher();
              context.read<PartnerEmployeeProvider>().resetValues();
              context.read<VehicleRouteInfoProvider>().resetVehicleRouteInfo();
              context.read<DispatchInfoProvider>().resetDispatchInfo();
              context.read<VehicleInfoExtendedProvider>().resetVehicleInfoExtended();
              Navigator.pushNamed(context, '/');
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
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: CustomThemeColors.themeBlue,
            foregroundColor: CustomThemeColors.themeWhite
          ),
          onPressed: () async {
            if (context.read<ReservationProvider>().distance != null) {
              try {
                final reservation = await getReservationInfo (
                  context.read<CredentialsProvider>().accessToken as String,
                  context.read<PassengerProvider>().seatAssigned as String,
                  context.read<DomainProvider>().url as String
                );
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text(
                          'We have arrived!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white
                          ),
                        ),
                        content: Column(
                          children: [
                            Text(
                              'Please alight the bus safely.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white
                              ),
                            ),
                            Text(
                              'Do not hesitate to ask assistance.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  );
                }
              }
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('No Reservations yet'),
                    content: const Text('No need to use this button while there are no reservations yet.'),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK')
                      )
                    ],
                  );
                }
              );
            }
          },
          child: const Text('Refresh Bus Location')
        )
      ],
      // bottomNavigationBar: BottomAppBar(
      //   child: FooterMenu(),
      // ),
    );
  }
}

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: CustomThemeColors.themeBlue,
        borderRadius: BorderRadius.vertical(top: Radius.zero, bottom: Radius.circular(10))
      ),
      child: SizedBox(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: <Widget>[
            //     IconButton(
            //       onPressed: () {
            //         Navigator.pushNamed(context, "/domain");
            //       },
            //       icon: const Icon(
            //         Icons.menu,
            //         color: CustomThemeColors.themeWhite,
            //       )
            //     ),
            //     const LogOutButton()
            //   ],
            // ),
            HomeScreenNameCard()
          ],
        ),
      ),
    );
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
        logOut(credentials.refreshToken, context.read<DomainProvider>().url as String);
        credentials.resetValues();
        context.read<StopsProvider>().resetValues();
        context.read<PassengerProvider>().resetPassenger();
        context.read<ReservationProvider>().resetReservation();
        context.read<EmployeeScreenSwitcher>().resetSwitcher();
        context.read<PartnerEmployeeProvider>().resetValues();
        context.read<VehicleRouteInfoProvider>().resetVehicleRouteInfo();
        context.read<DispatchInfoProvider>().resetDispatchInfo();
        context.read<VehicleInfoExtendedProvider>().resetVehicleInfoExtended();
        Navigator.pushNamed(context, '/');
      },
      icon: const Icon(
        Icons.logout,
        color: CustomThemeColors.themeWhite,
      )
    );},
        );
  }
}

class HomeScreenNameCard extends StatelessWidget {
  const HomeScreenNameCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const ProfilePicture(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: CustomThemeColors.themeWhite
                      ),
                    ),
                    Text(
                      '${userProvider.firstName} ${userProvider.lastName}',
                      style: const TextStyle(
                        color: CustomThemeColors.themeWhite,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      context.read<PassengerProvider>().disabilityInfo ?? 'No Disability',
                      style: const TextStyle(color: CustomThemeColors.themeWhite)
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ApiProfileImage();
  }
}

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build (BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return const SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 15.0),
                Text(
                  'My PWD Card',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomThemeColors.themeBlue
                  ),
                ),
                SizedBox(height: 8.0),
                Card(
                  color: CustomThemeColors.themeBlue,
                  child: HomeScreenNameCard(),
                ),
                SizedBox(height: 14.0),
                Text(
                  'Booking Info',
                  style: TextStyle(
                    color: CustomThemeColors.themeBlue,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 8.0),
                BookingInfoCard(),
                SizedBox(height: 20.0),
                BookReservationButton()
              ],
            )
          ),
        );
      }
    );
  }
}

class BookReservationButton extends StatelessWidget {
  const BookReservationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (context.read<PassengerProvider>().seatAssigned == null) {
      return const BookReservationButtonInner();
    } else {
      int distance;
      if (context.read<ReservationProvider>().seatName != null) {
        distance = context.read<ReservationProvider>().distance as int;
        bool visibility = distance > 0;
        return Visibility(
          visible: visibility,
          child: const CancelButton(),
        );
        
      } else {
        if (context.read<ReservationProvider>().distance != null) {
          return const CancelButton();
        } else {
          return const BookReservationButtonInner();
        }
      }
    }
  }
}

class BookReservationButtonInner extends StatelessWidget {
  const BookReservationButtonInner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BasicElevatedButton(
      buttonText: 'Book Reservation',
      onPressed: () {
        Navigator.pushNamed(context, '/reservation');
      }
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        bool cancel = false;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cancel Booking?'),
              content: const Text('Are you sure you want to cancel your booking?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back')
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError
                  ),
                  onPressed: () {
                    cancel = true;
                    Navigator.of(context).pop();
                  },
                  child: const Text('Confirm')
                )
              ],
            );
          }
        );
        if (cancel) {
          cancelBooking(context.read<CredentialsProvider>().accessToken as String,
            context.read<PassengerProvider>().id as String,
            context.read<PassengerProvider>().seatAssigned as String,
            context.read<DomainProvider>().url as String
          );
          context.read<ReservationProvider>().resetReservation();
          context.read<PassengerProvider>().aloftSeat();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Cancelled Reservation'),
                content: const Text('You\'re cancellation is complete.'),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                ],
              );
            }
          );
        }
      },
      style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onError,
            foregroundColor: Theme.of(context).colorScheme.error,
            minimumSize: const Size.fromHeight(50)
          ),
      child: const Text('Cancel Booking')
    );
  }
}