import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
// import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
// import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
// import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
// import 'package:pwd_reservation_app/modules/employee/drivers/partner_employee.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';

class NextStopBody extends StatelessWidget {
  const NextStopBody({super.key});

  int getFilteredLength(List<dynamic> items) {
  // Filtering the list based on the condition
    List filteredItems = items.where((item) {
      if (item is Map<String, dynamic>) {
        return item['arrival_datetime'] == null && item['departure_datetime'] == null;
      }
      return false;
    }).toList();

    // Returning the length of the filtered list
    return filteredItems.length;
  }

  List getFilteredAndSortedList(List<dynamic> items) {
  // Filtering the list based on the condition
    List filteredItems = items.where((item) {
      if (item is Map<String, dynamic>) {
        return item['arrival_datetime'] == null && item['departure_datetime'] == null;
      }
      return false;
    }).toList();

    // Sorting the filtered list based on the 'sort' key
    filteredItems.sort((a, b) {
      // Assuming the 'sort' key has comparable values like int, double, or String
      var aSort = a['sort'];
      var bSort = b['sort'];

      if (aSort is Comparable && bSort is Comparable) {
        return aSort.compareTo(bSort);
      } else {
        return 0; // If sort keys are not comparable, treat them as equal
      }
    });

    return filteredItems;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: CustomThemeColors.themeBlue,
        borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      child: Consumer<VehicleInfoExtendedProvider>(
        builder: (context, vehicle, child) {
          if (vehicle.tripStops != null) {
            int remainingStops = getFilteredLength(vehicle.tripStops as List<dynamic>);
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Remaining Stops: $remainingStops',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: CustomThemeColors.themeWhite
                          ),
                        ),
                        Consumer<VehicleRouteInfoProvider>(
                          builder: (context, routeInfo, child) {
                            return Text(
                              "${
                                routeInfo.currentStopId == '' ? 'Going to' : 'Currently in'
                                } ${
                                  routeInfo.currentStopId == '' ? routeInfo.goingToBusStopId : routeInfo.currentStopId
                                }",
                              style: const TextStyle(
                                color: CustomThemeColors.themeWhite,
                                fontWeight: FontWeight.bold
                              ),
                            );
                          }
                        ),
                        // Text(
                        //   'Remaining Normal Seats: ${context.read<VehicleInfoExtendedProvider>().normalSeatsRemaining}',
                        //   style: const TextStyle(color: CustomThemeColors.themeWhite)
                        // ),
                        // Text(
                        //   'Remaining PWD Seats: ${context.read<VehicleInfoExtendedProvider>().pwdSeatsRemaining}',
                        //   style: const TextStyle(color: CustomThemeColors.themeWhite)
                        // )
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox(
              width: double.infinity,
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Center(
                  child: Text(
                    'No Trip Assigned',
                    style: TextStyle(color: CustomThemeColors.themeWhite)
                  ),
                )
              ),
            );
          }
        }
      ),
    );
  }
}

class PartnerProfilePicture extends StatelessWidget {
  const PartnerProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ApiPartnerImage();
  }
}