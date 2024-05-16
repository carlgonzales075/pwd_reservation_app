import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_selected.dart';

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
          if (reservation.distance != null) {

            if (reservation.distance! > 0) {
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
            } else if (reservation.distance! == 0) {
              return const Card(
                color: Colors.green,
                child: SizedBox(
                  height: 130,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text(
                      'Prepare to Board!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ))
                  ),
                )
              );
            } else {
              return Card(
                color: Colors.blue.shade600,
                child: const SizedBox(
                  height: 130,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'YOUR ARE NOW BOARDED',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white
                          ),
                        ),
                        Center(
                          child: Text(
                            'Please remain seated while riding and',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'pay your fare to the conductor.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Have a safe trip!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ))
                  ),
                )
              );
            }
          } else {
            return const NoBookingCard();
          }
        }
      );
    } else {
      return const NoBookingCard();
        }
    }
  }

class NoBookingCard extends StatelessWidget {
  const NoBookingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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