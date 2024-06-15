import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/stops.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';

class StopsListView extends StatefulWidget {
  const StopsListView({
    super.key,
    required this.reverse
  });

  final bool reverse;

  @override
  State<StopsListView> createState() => _StopsListView();
}

class _StopsListView extends State<StopsListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getStops(context),
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
          List<Stops>? data = widget.reverse ? snapshot.data!.reversed.toList() : snapshot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                return Consumer<StopsProvider> (
                  builder: (context, stops, child) {
                    bool isSelected = stops.destinationId == data[index].id || stops.pickUpId == data[index].id;
                    bool completeSelection = stops.destinationId != null && stops.pickUpId != null;
                    final parentContext = context;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (stops.destinationId == data[index].id) {
                            stops.resetDestination();
                          } else if (stops.pickUpId == data[index].id) {
                            stops.resetPickup();
                          } else if (completeSelection) {
                            CustomDialogs.customTwoChoiceDialog(
                              parentContext,
                              'Select ${data[index].stopName}?',
                              'Would you like use ${data[index].stopName} as the pickup or destination?',
                              firstOption: () {
                                stops.updatePickUp(
                                  pickUpId: data[index].id ?? '',
                                  stopNamePickUp: data[index].stopName ?? '',
                                  pickUpIndex: index,
                                  pickUpPointLocation: data[index].stopPointLocation ?? ''
                                );
                              },
                              firstLabel: 'Pickup',
                              secondOption: () {
                                stops.updateDestination(
                                  destinationId: data[index].id ?? '',
                                  stopNameDestination: data[index].stopName ?? '',
                                  destinationIndex: index,
                                  destinationPointLocation: data[index].stopPointLocation ?? ''
                                );
                              },
                              secondLabel: 'Destination'
                            );
                          } else {
                            if (stops.destinationId == null) {
                              stops.updateDestination(
                                destinationId: data[index].id ?? '',
                                stopNameDestination: data[index].stopName ?? '',
                                destinationIndex: index,
                                destinationPointLocation: data[index].stopPointLocation ?? ''
                              );
                            } else {
                              stops.updatePickUp(
                                pickUpId: data[index].id ?? '',
                                stopNamePickUp: data[index].stopName ?? '',
                                pickUpIndex: index,
                                pickUpPointLocation: data[index].stopPointLocation ?? ''
                              );
                            }
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.lightGreen.shade100 : Colors.lightBlue[50],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.pin_drop,
                            color: isSelected ? Colors.green[700] : CustomThemeColors.themeBlue,
                          ),
                          title: Text(
                            '${data[index].stopName}',
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.green[700] : CustomThemeColors.themeBlue
                            ),
                          ),
                          subtitle: Text(
                            '${data[index].stopName} Carousel Bus Stop',
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.green[700] : CustomThemeColors.themeBlue
                            )
                          ),
                          trailing: Builder(
                            builder: (context) {
                              if (stops.destinationId == data[index].id) {
                                return Column(
                                  children: [
                                    Text(
                                      'End',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[700]
                                      ),
                                    ),
                                    const Icon(
                                      Icons.last_page_sharp,
                                      color: Colors.green,
                                      size: 30,
                                      weight: 100,
                                    ),
                                  ],
                                );
                              } else if (stops.pickUpId == data[index].id) {
                                return Column(
                                  children: [
                                    Text(
                                      'Start',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[700]
                                      ),
                                    ),
                                    const Icon(
                                      Icons.start_sharp,
                                      color: Colors.green,
                                      size: 30,
                                      weight: 100,
                                    ),
                                  ],
                                );
                              } else {
                                return const Icon(
                                  Icons.circle_sharp,
                                  color: CustomThemeColors.themeBlue,
                                  size: 10,
                                );
                              }
                            },
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
  }
}