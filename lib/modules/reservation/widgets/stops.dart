import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/stops.dart';
import 'package:pwd_reservation_app/modules/select_bus/drivers/geopoint_convert.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  final ItemScrollController _itemScrollController = ItemScrollController();

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
          return const TripSelectorAccessExpiredMessage();
        } else {
          List<Stops>? data = widget.reverse ? snapshot.data!.reversed.toList() : snapshot.data;
            return ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemCount: data!.length,
              itemBuilder: (context, index) {
                return Consumer<StopsProvider> (
                  builder: (context, stops, child) {
                    bool isSelected = stops.destinationId == data[index].id || stops.pickUpId == data[index].id;
                    bool completeSelection = stops.destinationId != null && stops.pickUpId != null;
                    final parentContext = context;
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.lightGreen.shade100 : Colors.lightBlue[50],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          _selectStop(stops, data, index, completeSelection, parentContext);
                        },
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
                    );
                  }
                );
              },
            );
        }
      }
    );
  }

  void _updateInBetween(StopsProvider stops, List<Stops> data) {
    if (stops.destinationId != null && stops.pickUpId != null) {
      final int smaller = stops.pickUpIndex! < stops.destinationIndex! ? stops.pickUpIndex! : stops.destinationIndex!;
      final int greater = stops.pickUpIndex! < stops.destinationIndex! ? stops.destinationIndex!: stops.pickUpIndex!;
      final inBetweenList = <Map<String, GeoPoint>>[];
      for (int i = smaller; i <= (greater - smaller); i++) {
        inBetweenList.add({
          data[i].stopName.toString(): convertPointToGeoPoint(
            data[i].stopPointLocation.toString()
          ),
        });
      }
      stops.updateInBetween(inBetween: inBetweenList);
      // print(stops.getIntersections());
    }
  }

  void _selectStop(StopsProvider stops, List<Stops> data, int index, bool completeSelection, BuildContext parentContext) {
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
            _updateInBetween(stops, data);
            _itemScrollController.scrollTo(index: index, duration: const Duration(milliseconds: 500));
          },
          firstLabel: 'Pickup',
          secondOption: () {
            stops.updateDestination(
              destinationId: data[index].id ?? '',
              stopNameDestination: data[index].stopName ?? '',
              destinationIndex: index,
              destinationPointLocation: data[index].stopPointLocation ?? ''
            );
            _updateInBetween(stops, data);
            _itemScrollController.scrollTo(index: index, duration: const Duration(milliseconds: 500));
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
          _itemScrollController.scrollTo(index: index, duration: const Duration(milliseconds: 500));
        } else {
          stops.updatePickUp(
            pickUpId: data[index].id ?? '',
            stopNamePickUp: data[index].stopName ?? '',
            pickUpIndex: index,
            pickUpPointLocation: data[index].stopPointLocation ?? ''
          );
          _itemScrollController.scrollTo(index: index, duration: const Duration(milliseconds: 500));
        }
        _updateInBetween(stops, data);
      }
    });
  }
}

class TripSelectorAccessExpiredMessage extends StatelessWidget {
  const TripSelectorAccessExpiredMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text('Please refresh this page.'),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomThemeColors.themeBlue,
            foregroundColor: CustomThemeColors.themeWhite
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, '/reservation');
          },
          child: const Text('Refresh')
        )
      ],
    );
  }
}