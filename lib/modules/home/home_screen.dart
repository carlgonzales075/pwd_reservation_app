import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/home/widgets/booking_info_card.dart';
import 'package:pwd_reservation_app/modules/home/widgets/rfid_info_card.dart';
import 'package:pwd_reservation_app/modules/home/widgets/side_menu.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/passengers.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/reservations.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/seat_assignment.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';


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
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: CustomThemeColors.themeBlue,
            foregroundColor: CustomThemeColors.themeWhite
          ),
          onPressed: () async {
            //Refactor to another file
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
            }
          },
          child: const Text('Refresh Bus Location')
        )
      ],
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/edit-profile");
                },
                child: const ProfilePicture()
              ),
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
    return const ApiProfileImage(
      width: 40,
      height: 40,
      scale: true
    );
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

class BookReservationButton extends StatefulWidget {
  const BookReservationButton({
    super.key,
  });

  @override
  State<BookReservationButton> createState() => _BookReservationButtonState();
}

class _BookReservationButtonState extends State<BookReservationButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PassengerProvider, ReservationProvider>(
      builder: (context, passenger, reservation, child) {
        if (passenger.seatAssigned == null) {
          return const BookReservationButtonInner();
        } else {
          final String? seatName = reservation.seatName;
          final int? distance = reservation.distance;

          if (distance != null) {
            if (distance <= 0) {
              return const RfidInfoCard();
            } else {
              return const CancelButton();
            } 
          } else if (seatName != null) {
            return const RfidInfoCard();
          } else {
            return const BookReservationButtonInner();
            
          }
        }
      },
    );
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
        //refactor this with customDialog
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
                    if (cancel) {
                      cancelBooking(context,
                        context.read<PassengerProvider>().id as String,
                        context.read<PassengerProvider>().seatAssigned as String
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
                                },
                              ),
                            ],
                          );
                        }
                      );
                    }
                  },
                  child: const Text('Confirm')
                )
              ],
            );
          }
        );
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