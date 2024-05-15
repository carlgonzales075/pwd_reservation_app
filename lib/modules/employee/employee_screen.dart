import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/dispatch_info.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/employee.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/partner_employee.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/screen_change.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/employee/widgets/employee_header.dart';
import 'package:pwd_reservation_app/modules/employee/widgets/next_stop_card_employee.dart';
import 'package:pwd_reservation_app/modules/employee/widgets/partner_employee_card.dart';
import 'package:pwd_reservation_app/modules/employee/widgets/vehicle_card_employee.dart';
import 'package:pwd_reservation_app/modules/home/side_menu.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_operations.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_selected.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/routes.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});

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
              context.read<EmployeeScreenSwitcher>().resetSwitcher();
              context.read<PartnerEmployeeProvider>().resetValues();
              context.read<VehicleRouteInfoProvider>().resetVehicleRouteInfo();
              context.read<DispatchInfoProvider>().resetDispatchInfo();
              context.read<VehicleInfoExtendedProvider>().resetVehicleInfoExtended();
              Navigator.pushNamed(context, '/');
            },
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      drawer: const NavDrawer(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewPortConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewPortConstraints.maxHeight,
              ),
              child: const Column(
                children: <Widget>[
                EmployeeHomeScreenHeader(),
                PartnerCard(),
                SizedBox(height: 12,),
                VehicleCard(),
                SizedBox(height: 12),
                NextStopCard(),
              ],
            ),)
          );
        }
      ),
      persistentFooterButtons: const <Widget>[
        DynamicButtons()
      ],
    );
  }
}

// class DynamicButtons extends StatefulWidget {
//   const DynamicButtons({
//     super.key,
//   });

//   @override
//   State<DynamicButtons> createState() => _DynamicButtonsState();
// }

// class _DynamicButtonsState extends State<DynamicButtons> {
//   int getRemainingStops(List<dynamic> items) {
//   // Filtering the list based on the condition
//     List filteredItems = items.where((item) {
//       if (item is Map<String, dynamic>) {
//         return item['arrival_datetime'] == null && item['departure_datetime'] == null;
//       }
//       return false;
//     }).toList();

//     // Returning the length of the filtered list
//     return filteredItems.length;
//   }

//   int getRemainingStopsbyArrival(List<dynamic> items) {
//   // Filtering the list based on the condition
//     List filteredItems = items.where((item) {
//       if (item is Map<String, dynamic>) {
//         return item['arrival_datetime'] == null;
//       }
//       return false;
//     }).toList();

//     // Returning the length of the filtered list
//     return filteredItems.length;
//   }

//   int getRemainingStopsbyDeparture(List<dynamic> items) {
//   // Filtering the list based on the condition
//     List filteredItems = items.where((item) {
//       if (item is Map<String, dynamic>) {
//         return item['departure_datetime'] == null;
//       }
//       return false;
//     }).toList();

//     // Returning the length of the filtered list
//     return filteredItems.length;
//   }

//   int getOriginalTripStopNumber(List<dynamic> items) {
//     return items.length;
//   }

//   String getCurrentStop(List<dynamic> items) {
//     // items.sort((a, b) => a['stop_number'].compareTo(b['stop_number'])) as List<Map<String, dynamic>>;
//     final int remaining = getRemainingStops(items);
//     final int original = getOriginalTripStopNumber(items);
//     return items[original - remaining]['stop_name'];
//   }

//   int getCurrentId(List<dynamic> items) {
//     // items.sort((a, b) => a['stop_number'].compareTo(b['stop_number']));
//     final int remaining = getRemainingStops(items);
//     final int original = getOriginalTripStopNumber(items);
//     return items[original - remaining]['id'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     List? tripStops = context.read<VehicleInfoExtendedProvider>().tripStops;
//     if (tripStops != null) {
//       String? currentStop = context.read<VehicleRouteInfoProvider>().currentStopId;
//       if (getRemainingStops(tripStops) == getOriginalTripStopNumber(tripStops)) {
//         return ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size.fromHeight(60),
//             backgroundColor: Colors.green,
//             foregroundColor: CustomThemeColors.themeWhite
//           ),
//           onPressed: () async {
//             print(getRemainingStops(tripStops));
//             try {
//               await BusOperations.startTrip(
//                 context.read<DomainProvider>().url as String,
//                 context.read<CredentialsProvider>().accessToken as String,
//                 getCurrentId(tripStops),
//                 context.read<DispatchInfoProvider>().dispatchId as String,
//               );
//               if (context.mounted) {
//                 final vehicleInfoExtended = await getVehicleInfoExtended(
//                   context.read<DomainProvider>().url as String,
//                   context.read<CredentialsProvider>().accessToken as String,
//                   context.read<VehicleRouteInfoProvider>().vehicleId as String,
//                   context.read<VehicleRouteInfoProvider>().routeId as String,
//                   context.read<DispatchInfoProvider>().dispatchId as String,
//                 );
//                 if (context.mounted) {
//                   context.read<VehicleInfoExtendedProvider>().initVehicleInfoExtended(
//                     vehicleInfoExtended.vehicleName,
//                     vehicleInfoExtended.vehiclePlateNumber,
//                     vehicleInfoExtended.vehicleImageId,
//                     vehicleInfoExtended.driverUserId,
//                     vehicleInfoExtended.conductorUserId,
//                     vehicleInfoExtended.normalSeatsRemaining,
//                     vehicleInfoExtended.pwdSeatsRemaining,
//                     vehicleInfoExtended.tripStops
//                   );
//                   print(getRemainingStops(tripStops));
//                 }
//               }
//             } catch (e) {
//               if (context.mounted) {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: const Text('Error Encountered'),
//                       content: Text('$e'),
//                     );
//                   }
//                 );
//               }
//             }
//           },
//           child: const Text('Start Trip')
//         );
//       } else if (getRemainingStops(tripStops) == 1) {
//         return ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size.fromHeight(60),
//             backgroundColor: Colors.purple,
//             foregroundColor: CustomThemeColors.themeWhite
//           ),
//           onPressed: () {
        
//           },
//           child: const Text('End Trip')
//         );
//       } else {
//         if (currentStop != null) {
//           return ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size.fromHeight(60),
//               backgroundColor: Colors.deepOrange,
//               foregroundColor: CustomThemeColors.themeWhite
//             ),
//             onPressed: () {
          
//             },
//             child: const Text('Depart')
//           );
//         } else {
//           return ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size.fromHeight(60),
//               backgroundColor: CustomThemeColors.themeBlue,
//               foregroundColor: CustomThemeColors.themeWhite
//             ),
//             onPressed: () {
          
//             },
//             child: const Text('Arrive')
//           );
//         }
//       }
//     } else {
//       return ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size.fromHeight(60),
//               backgroundColor: Colors.black,
//               foregroundColor: CustomThemeColors.themeWhite,
//             ),
//             onPressed: () {
          
//             },
//             child: const Text('No Trip Assigned')
//           );
//     }
//   }
// }

class DynamicButtons extends StatefulWidget {
  const DynamicButtons({super.key});

  @override
  State<DynamicButtons> createState() => _DynamicButtonsState();
}

class _DynamicButtonsState extends State<DynamicButtons> {
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

  @override
  Widget build(BuildContext context) {
    return Consumer3<
        VehicleInfoExtendedProvider,
        VehicleRouteInfoProvider,
        DispatchInfoProvider>(
      builder: (context, vehicleInfoExtendedProvider, vehicleRouteInfoProvider, dispatchInfoProvider, child) {
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
                // print(getRemainingStops(tripStops));
                try {
                  await BusOperations.startTrip(
                    context.read<DomainProvider>().url as String,
                    context.read<CredentialsProvider>().accessToken as String,
                    getCurrentId(tripStops),
                    dispatchInfoProvider.dispatchId as String,
                  );
                  if (context.mounted) {
                    final vehicleInfoExtended = await getVehicleInfoExtended(
                      context.read<DomainProvider>().url as String,
                      context.read<CredentialsProvider>().accessToken as String,
                      vehicleRouteInfoProvider.vehicleId as String,
                      vehicleRouteInfoProvider.routeId as String,
                      dispatchInfoProvider.dispatchId as String,
                    );
                    if (context.mounted) {
                      vehicleInfoExtendedProvider.initVehicleInfoExtended(
                        vehicleInfoExtended.vehicleName,
                        vehicleInfoExtended.vehiclePlateNumber,
                        vehicleInfoExtended.vehicleImageId,
                        vehicleInfoExtended.driverUserId,
                        vehicleInfoExtended.conductorUserId,
                        vehicleInfoExtended.normalSeatsRemaining,
                        vehicleInfoExtended.pwdSeatsRemaining,
                        vehicleInfoExtended.tripStops,
                      );
                      VehicleRouteInfo vehicleRouteInfo = await getVehicleRouteInfo(
                        context.read<DomainProvider>().url as String,
                        context.read<CredentialsProvider>().accessToken as String,
                        context.read<EmployeeProvider>().id as String
                      );
                      if (context.mounted) {
                        context.read<VehicleRouteInfoProvider>().initVehicleRouteInfo(
                          vehicleRouteInfo.routeId,
                          vehicleRouteInfo.vehicleId,
                          vehicleRouteInfo.driverId,
                          vehicleRouteInfo.conductorId,
                          vehicleRouteInfo.currentStopId,
                          vehicleRouteInfo.goingToBusStopId
                        );
                      }
                      // print(getRemainingStops(tripStops));
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error Encountered'),
                          content: Text('$e'),
                        );
                      },
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
                  print('asd dasd');
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error Encountered'),
                          content: Text('$e'),
                        );
                      },
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
                      final vehicleInfoExtended = await getVehicleInfoExtended(
                        context.read<DomainProvider>().url as String,
                        context.read<CredentialsProvider>().accessToken as String,
                        vehicleRouteInfoProvider.vehicleId as String,
                        vehicleRouteInfoProvider.routeId as String,
                        dispatchInfoProvider.dispatchId as String,
                      );
                      if (context.mounted) {
                        vehicleInfoExtendedProvider.initVehicleInfoExtended(
                          vehicleInfoExtended.vehicleName,
                          vehicleInfoExtended.vehiclePlateNumber,
                          vehicleInfoExtended.vehicleImageId,
                          vehicleInfoExtended.driverUserId,
                          vehicleInfoExtended.conductorUserId,
                          vehicleInfoExtended.normalSeatsRemaining,
                          vehicleInfoExtended.pwdSeatsRemaining,
                          vehicleInfoExtended.tripStops,
                        );
                        VehicleRouteInfo vehicleRouteInfo = await getVehicleRouteInfo(
                          context.read<DomainProvider>().url as String,
                          context.read<CredentialsProvider>().accessToken as String,
                          context.read<EmployeeProvider>().id as String
                        );
                        if (context.mounted) {
                          context.read<VehicleRouteInfoProvider>().initVehicleRouteInfo(
                            vehicleRouteInfo.routeId,
                            vehicleRouteInfo.vehicleId,
                            vehicleRouteInfo.driverId,
                            vehicleRouteInfo.conductorId,
                            vehicleRouteInfo.currentStopId,
                            vehicleRouteInfo.goingToBusStopId
                          );
                        }
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error Encountered'),
                            content: Text('$e'),
                          );
                        },
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
                      final vehicleInfoExtended = await getVehicleInfoExtended(
                        context.read<DomainProvider>().url as String,
                        context.read<CredentialsProvider>().accessToken as String,
                        vehicleRouteInfoProvider.vehicleId as String,
                        vehicleRouteInfoProvider.routeId as String,
                        dispatchInfoProvider.dispatchId as String,
                      );
                      if (context.mounted) {
                        vehicleInfoExtendedProvider.initVehicleInfoExtended(
                          vehicleInfoExtended.vehicleName,
                          vehicleInfoExtended.vehiclePlateNumber,
                          vehicleInfoExtended.vehicleImageId,
                          vehicleInfoExtended.driverUserId,
                          vehicleInfoExtended.conductorUserId,
                          vehicleInfoExtended.normalSeatsRemaining,
                          vehicleInfoExtended.pwdSeatsRemaining,
                          vehicleInfoExtended.tripStops,
                        );
                        VehicleRouteInfo vehicleRouteInfo = await getVehicleRouteInfo(
                          context.read<DomainProvider>().url as String,
                          context.read<CredentialsProvider>().accessToken as String,
                          context.read<EmployeeProvider>().id as String
                        );
                        if (context.mounted) {
                          context.read<VehicleRouteInfoProvider>().initVehicleRouteInfo(
                            vehicleRouteInfo.routeId,
                            vehicleRouteInfo.vehicleId,
                            vehicleRouteInfo.driverId,
                            vehicleRouteInfo.conductorId,
                            vehicleRouteInfo.currentStopId,
                            vehicleRouteInfo.goingToBusStopId
                          );
                        }
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error Encountered'),
                            content: Text('$e'),
                          );
                        },
                      );
                    }
                  }
                },
                child: const Text('Arrive'),
              );
            }
          }
        } else {
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
        }
      },
    );
  }
}


class NextStopCard extends StatelessWidget {
  const NextStopCard({super.key});

 @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
          'Trip Info',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: CustomThemeColors.themeBlue
            ),
          ),
          NextStopBody(),
        ],
      )
    );
  }
}

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
          'Vehicle Info',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: CustomThemeColors.themeBlue
            ),
          ),
          VehicleCardBody(),
        ],
      )
    );
  }
}

class PartnerCard extends StatefulWidget {
  const PartnerCard({
    super.key,
  });

  @override
  State<PartnerCard> createState() => _PartnerCardState();
}

class _PartnerCardState extends State<PartnerCard> {
  @override
  Widget build(BuildContext context) {
    List<String> employeeRoles = ['Driver', 'Conductor'];
    String employeeRole = context.read<UserProvider>().role as String;
    String partnerRole;
    if (employeeRoles.contains(employeeRole)) {
      if (employeeRole == 'Driver') {
        partnerRole = ' Conductor';
      } else {
        partnerRole = ' Driver';
      }
    } else {
      partnerRole = '';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
          'Partner$partnerRole Info',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: CustomThemeColors.themeBlue
          ),
        ),
        const PartnerCardBody(),
      ])
    );
  }
}