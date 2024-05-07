import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/routes.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
// import 'package:pwd_reservation_app/modules/reservation/select_bus.dart';
// import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Consumer<StopsProvider> (
          builder: (context, stops, child) {
            return Text(
              'Select ${stops.stopNameDestination == null ? 'Destination' : 'Pickup'}',
              style: const TextStyle(
                color: CustomThemeColors.themeWhite
              ),
            );
          },
        ),
        backgroundColor: CustomThemeColors.themeBlue,
      ),
      body: const StopsListView()
    );
  }
}

class StopsListView extends StatefulWidget {
  const StopsListView({super.key});

  @override
  State<StopsListView> createState() => _StopsListView();
}

class _StopsListView extends State<StopsListView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CredentialsProvider> (
      builder: (context, credentials, child) {
        return FutureBuilder(
          future: getStops('${credentials.accessToken}', context.read<DomainProvider>().url as String),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
              child: Text('Error: ${snapshot.error}'),
            );
            } else {
              List<Stops>? data = snapshot.data;
                return ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return Consumer<StopsProvider> (
                      builder: (context, stops, child) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (stops.destinationIndex == index) {
                                stops.resetDestination();
                              } else if (stops.pickUpIndex == index) {
                                stops.resetPickup();
                              } else {
                                if (stops.pickUpIndex == null) {
                                  stops.updatePickUp(
                                    pickupId: data[index].id ?? '',
                                    stopNamePickUp: data[index].stopName ?? '',
                                    pickUpIndex: index
                                  );
                                } else {
                                  stops.updateDestination(
                                    destinationId: data[index].id ?? '',
                                    stopNameDestination: data[index].stopName ?? '',
                                    destinationIndex: index
                                  );
                                }
                              }
                              if (stops.destinationIndex != null && stops.pickUpIndex != null) {
                                Navigator.pushNamed(context, '/select-bus');
                                
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            decoration: BoxDecoration(
                              color: stops.destinationIndex == index || stops.pickUpIndex == index ? Colors.lightBlue[100] : Colors.lightBlue[50],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              title: Text(
                                '${data[index].stopName}',
                                style: TextStyle(
                                  fontWeight: stops.destinationIndex == index || stops.pickUpIndex == index ? FontWeight.bold : FontWeight.normal,
                                  color: CustomThemeColors.themeBlue
                                ),
                              ),
                              subtitle: Text(
                                '${data[index].stopName} Carousel Bus Stop',
                                style: TextStyle(
                                  fontWeight: stops.destinationIndex == index || stops.pickUpIndex == index ? FontWeight.bold : FontWeight.normal,
                                  color: CustomThemeColors.themeBlue
                                )
                              ),
                            ),
                          ),
                        );
                      }
                    );
                  },
                );
            }
          }
        );
      },
    );
  }
}