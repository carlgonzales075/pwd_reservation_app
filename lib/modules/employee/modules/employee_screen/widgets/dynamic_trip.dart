import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/dispatch_info.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/partner_employee.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_operations.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';
import 'package:pwd_reservation_app/modules/users/utils/user_info.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class DynamicButtons extends StatefulWidget {
  const DynamicButtons({super.key});

  @override
  State<DynamicButtons> createState() => _DynamicButtonsState();
}

class _DynamicButtonsState extends State<DynamicButtons> {
  @override
  Widget build(BuildContext context) {
    return Consumer4<
        VehicleInfoExtendedProvider,
        VehicleRouteInfoProvider,
        DispatchInfoProvider,
        UserProvider>(
      builder: (context, vehicleInfoExtendedProvider,
                vehicleRouteInfoProvider, dispatchInfoProvider,
                userProvider, child) {
        List? tripStops = vehicleInfoExtendedProvider.tripStops;
        String? currentStop = vehicleRouteInfoProvider.currentStopId;
        
        if (tripStops != null) {
          if (getRemainingStops(tripStops) == getOriginalTripStopNumber(tripStops)) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                backgroundColor: Colors.green,
                foregroundColor: CustomThemeColors.themeWhite,
              ),
              onPressed: () async {
                try {
                  await BusOperations.startTrip(
                    context.read<DomainProvider>().url as String,
                    context.read<CredentialsProvider>().accessToken as String,
                    getCurrentId(tripStops),
                    dispatchInfoProvider.dispatchId as String,
                  );
                  if (context.mounted) {
                    await UserInfo.getTripInfo(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    CustomDialogs.customFatalError(
                      context,
                      'Error Encountered',
                      () {}
                    );
                  }
                }
              },
              child: const Text('Start Trip'),
            );
          } else if (getRemainingStops(tripStops) == 0) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                backgroundColor: Colors.purple,
                foregroundColor: CustomThemeColors.themeWhite,
              ),
              onPressed: () async {
                // End Trip action
                try {
                  // print('asd dasd');
                  await BusOperations.endTrip(
                    context.read<DomainProvider>().url as String,
                    context.read<CredentialsProvider>().accessToken as String,
                    getLastId(tripStops),
                    dispatchInfoProvider.dispatchId as String,
                  );
                  if (context.mounted) {
                      vehicleInfoExtendedProvider.resetVehicleInfoExtended();
                      context.read<VehicleRouteInfoProvider>().resetVehicleRouteInfo();
                      context.read<PartnerEmployeeProvider>().resetValues();
                      context.read<DispatchInfoProvider>().resetDispatchInfo();
                  }
                } catch (e) {
                  if (context.mounted) {
                    CustomDialogs.customFatalError(
                      context,
                      'Error Encountered',
                      () {}
                    );
                  }
                }
              },
              child: const Text('End Trip'),
            );
          } else {
            if (currentStop != '') {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: CustomThemeColors.themeWhite,
                ),
                onPressed: () async {
                  // Depart action
                  try {
                    await BusOperations.departFromStation(
                      context.read<DomainProvider>().url as String,
                      context.read<CredentialsProvider>().accessToken as String,
                      getCurrentIdbyDeparture(tripStops)
                    );
                    if (context.mounted) {
                    await UserInfo.getTripInfo(context);
                  }
                  } catch (e) {
                    if (context.mounted) {
                      CustomDialogs.customFatalError(
                        context,
                        'Error Encountered',
                        () {}
                      );
                    }
                  }
                },
                child: const Text('Depart'),
              );
            } else {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  backgroundColor: Colors.lightGreen,
                  foregroundColor: CustomThemeColors.themeWhite,
                ),
                onPressed: () async {
                  // Arrive action
                  try {
                    await BusOperations.arriveAtStation(
                      context.read<DomainProvider>().url as String,
                      context.read<CredentialsProvider>().accessToken as String,
                      getCurrentIdbyDeparture(tripStops)
                    );
                    if (context.mounted) {
                    await UserInfo.getTripInfo(context);
                  }
                  } catch (e) {
                    if (context.mounted) {
                      CustomDialogs.customFatalError(
                        context,
                        'Error Encountered',
                        () {}
                      );
                    }
                  }
                },
                child: const Text('Arrive'),
              );
            }
          }
        } else {
          List<String> driverConductor = ['Driver', 'Conductor'];
          if (driverConductor.contains(userProvider.role)) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                backgroundColor: Colors.black,
                foregroundColor: CustomThemeColors.themeWhite,
              ),
              onPressed: () {
                // No Trip Assigned action
              },
              child: const Text('No Trip Assigned'),
            );
          } else {
            return Container();
          }
        }
      },
    );
  }

  int getRemainingStops(List<dynamic> items) {
    List filteredItems = items.where((item) {
      if (item is Map<String, dynamic>) {
        return item['arrival_datetime'] == null && item['departure_datetime'] == null;
      }
      return false;
    }).toList();
    return filteredItems.length;
  }

  int getRemainingStopsbyArrival(List<dynamic> items) {
    List filteredItems = items.where((item) {
      if (item is Map<String, dynamic>) {
        return item['arrival_datetime'] == null;
      }
      return false;
    }).toList();
    return filteredItems.length;
  }

  int getRemainingStopsbyDeparture(List<dynamic> items) {
    List filteredItems = items.where((item) {
      if (item is Map<String, dynamic>) {
        return item['departure_datetime'] == null;
      }
      return false;
    }).toList();
    return filteredItems.length;
  }

  int getOriginalTripStopNumber(List<dynamic> items) {
    return items.length;
  }

  String getCurrentStop(List<dynamic> items) {
    final int remaining = getRemainingStops(items);
    final int original = getOriginalTripStopNumber(items);
    return items[original - remaining]['stop_name'];
  }

  int getCurrentId(List<dynamic> items) {
    final int remaining = getRemainingStops(items);
    final int original = getOriginalTripStopNumber(items);
    return items[original - remaining]['id'];
  }

  int getLastId(List<dynamic> items) {
    return items.last['id'];
  }

  int getCurrentIdbyDeparture(List<dynamic> items) {
    final int remaining = getRemainingStopsbyDeparture(items);
    final int original = getOriginalTripStopNumber(items);
    return items[original - remaining]['id'];
  }
}