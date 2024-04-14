import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/routes.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/reservation/select_bus.dart';
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
  // ignore: library_private_types_in_public_api
  _StopsListView createState() => _StopsListView();
}

class _StopsListView extends State<StopsListView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CredentialsProvider> (
      builder: (context, credentials, child) {
        return FutureBuilder(
          future: getStops('${credentials.accessToken}'),
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
              // return Center(
              //   child: Text('${snapshot.data}'),
              // );
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
                                stops.updateDestination(
                                  stopNameDestination: null,
                                  destinationIndex: null
                                );
                              } else if (stops.pickUpIndex == index) {
                                stops.updatePickUp(
                                  stopNamePickUp: null,
                                  pickUpIndex: null
                                );
                              } else {
                                if (stops.destinationIndex == null) {
                                  stops.updateDestination(
                                    stopNameDestination: data[index].stopName ?? '',
                                    destinationIndex: index
                                  );
                                } else {
                                  stops.updatePickUp(
                                    stopNamePickUp: data[index].stopName ?? '',
                                    pickUpIndex: index
                                  );
                                }
                              }
                              if (stops.destinationIndex != null && stops.pickUpIndex != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SelectBusScreen()
                                  )
                                );
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