import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/passengers.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/stops.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/vehicles.dart';
import 'package:pwd_reservation_app/modules/select_bus/drivers/select_bus.dart';
import 'package:pwd_reservation_app/modules/select_bus/widgets/bus_info.dart';
import 'package:pwd_reservation_app/modules/select_bus/widgets/no_buses.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';

class BusSelector extends StatelessWidget {
  const BusSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: FutureBuilder<List<Vehicles>>(
        future: postVehicles(
          context,
          context.read<StopsProvider>().pickUpId as String,
          context.read<StopsProvider>().destinationId as String,
          context.read<PassengerProvider>().passengerType != 'Normal'
        ),
          builder: (BuildContext context, AsyncSnapshot<List<Vehicles>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: CustomThemeColors.themeBlue,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(text: TextSpan(
                            text: 'Nice! We found ',
                            style: const TextStyle(color: Colors.white),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${snapshot.data!.length} ',
                                style: TextStyle(
                                  color: Colors.green.shade300,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                )
                              ),
                              TextSpan(
                                text: '${snapshot.data!.length == 1 ? 'bus': 'buses'} along your way!',
                                style: const TextStyle(color: Colors.white),
                              )
                            ])
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Back')
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            Vehicles vehicle = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue[50],
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: ListTile(
                                  onTap: () {
                                    CustomDialogs.advCustomInfoDialog(
                                      context,
                                      Text(
                                        vehicle.getNestedValue('vehicle_id.vehicle_name'),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: CustomThemeColors.themeLightBlue,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      BusInfo(vehicle: vehicle),
                                      () {
                                        // selectBus(context, vehicle);
                                      }
                                    );
                                  },
                                  contentPadding: const EdgeInsets.all(10.0),
                                  leading: const Icon(
                                    Icons.bus_alert,
                                    color: CustomThemeColors.themeBlue,
                                  ),
                                  title: Text(
                                    vehicle.getNestedValue('vehicle_id.vehicle_name'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: CustomThemeColors.themeBlue
                                    ),
                                  ),
                                  subtitle: Text(
                                    vehicle.getNestedValue('vehicle_id.vehicle_plate_number'),
                                    style: const TextStyle(
                                      color: CustomThemeColors.themeBlue
                                    ),
                                  ),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CustomThemeColors.themeBlue,
                                      foregroundColor: CustomThemeColors.themeWhite
                                    ),
                                    onPressed: () {
                                      selectBus(context, vehicle);
                                    },
                                    child: const Text('Select'),
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: NoBusesMessage(),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              StopsProvider stops = context.read<StopsProvider>();
              return Text('${snapshot.error}, ${stops.destinationId}, ${stops.pickUpId}');
            }
      
            return const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator()
            );
          }),
    );
  }
}