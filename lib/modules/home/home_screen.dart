import 'package:flutter/material.dart';
// import 'package:pwd_reservation_app/modules/home/footer_menu/footer_menu.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
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
      return BasicElevatedButton(
        buttonText: 'Book Reservation',
        onPressed: () {
          Navigator.pushNamed(context, '/reservation');
        }
      );
    } else {
      return ElevatedButton(
        onPressed: () {
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
        },
        style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.red
              ),
            ),
        child: const Text('Cancel Booking')
      );
    }
  }
}

class BookingInfoCard extends StatefulWidget {
  const BookingInfoCard({
    super.key
  });

  @override
  State<BookingInfoCard> createState() => _BookingInfoCard();
}
class _BookingInfoCard extends State<BookingInfoCard> {
  @override
  Widget build(BuildContext context) {
    if (context.read<PassengerProvider>().seatAssigned != null) {

      return Consumer<ReservationProvider>(
        builder: (context, reservation, child) {
          return Card(
            color: CustomThemeColors.themeLightBlue,
            child: SizedBox(
              height: 130,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${reservation.vehicleName}',
                        style: const TextStyle(
                          color: CustomThemeColors.themeWhite,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          Text(
                            '${reservation.busStopName}',
                            style: const TextStyle(
                              color: CustomThemeColors.themeWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),
                          ),
                          Text(
                            '${reservation.routeName}',
                            style: const TextStyle(
                              color: CustomThemeColors.themeWhite
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: RichText(
                        text: 
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: '${reservation.distance}',
                                style: const TextStyle(
                                  color: CustomThemeColors.themeWhite,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const TextSpan(
                                text: ' Stops to Go',
                                style: TextStyle(
                                  color: CustomThemeColors.themeWhite
                                ),
                              ),
                              const TextSpan(
                                text: ' | ',
                                style: TextStyle(
                                  color: CustomThemeColors.themeWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
                              ),
                              const TextSpan(
                                text: 'Seat #: ',
                                style: TextStyle(
                                  color: CustomThemeColors.themeBlue
                                ),
                              ),
                              TextSpan(
                                text: '${reservation.seatName}',
                                style: const TextStyle(
                                  color: CustomThemeColors.themeWhite,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        
                      ),
                    )
                  ],
                ),
              ),
            )
          );
        }
      );
    } else {
      return const Card(
            color: CustomThemeColors.themeLightBlue,
            child: SizedBox(
              height: 130,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        '',
                        style: TextStyle(
                          color: CustomThemeColors.themeWhite,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Book a Bus Now Below!!',
                        style: TextStyle(
                          color: CustomThemeColors.themeGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '',
                        style: TextStyle(
                          color: CustomThemeColors.themeWhite,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          );
        }
    }
  }