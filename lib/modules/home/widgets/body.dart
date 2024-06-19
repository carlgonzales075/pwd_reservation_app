import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/home/widgets/booking_info_card.dart';
import 'package:pwd_reservation_app/modules/home/widgets/header.dart';
import 'package:pwd_reservation_app/modules/home/widgets/rfid_info_card.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/passengers.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/reservations.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/seat_assignment.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

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