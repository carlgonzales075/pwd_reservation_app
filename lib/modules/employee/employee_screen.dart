import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/dispatch_info.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/partner_employee.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/screen_change.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/employee/widgets/employee_header.dart';
import 'package:pwd_reservation_app/modules/employee/widgets/next_stop_card_employee.dart';
import 'package:pwd_reservation_app/modules/employee/widgets/partner_employee_card.dart';
import 'package:pwd_reservation_app/modules/employee/widgets/vehicle_card_employee.dart';
import 'package:pwd_reservation_app/modules/home/side_menu.dart';
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

class DynamicButtons extends StatelessWidget {
  const DynamicButtons({
    super.key,
  });

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

  int getOriginalLength(List<dynamic> items) {
    return items.length;
  }

  @override
  Widget build(BuildContext context) {
    List? tripStops = context.read<VehicleInfoExtendedProvider>().tripStops;
    if (tripStops != null) {
      String? currentStop = context.read<VehicleRouteInfoProvider>().currentStopId;
      if (getFilteredLength(tripStops) == getOriginalLength(tripStops)) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(60),
            backgroundColor: Colors.green,
            foregroundColor: CustomThemeColors.themeWhite
          ),
          onPressed: () {
        
          },
          child: const Text('Start Trip')
        );
      } else if (getFilteredLength(tripStops) == 0) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(60),
            backgroundColor: Colors.purple,
            foregroundColor: CustomThemeColors.themeWhite
          ),
          onPressed: () {
        
          },
          child: const Text('End Trip')
        );
      } else {
        if (currentStop != null) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(60),
              backgroundColor: Colors.deepOrange,
              foregroundColor: CustomThemeColors.themeWhite
            ),
            onPressed: () {
          
            },
            child: const Text('Depart')
          );
        } else {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(60),
              backgroundColor: CustomThemeColors.themeBlue,
              foregroundColor: CustomThemeColors.themeWhite
            ),
            onPressed: () {
          
            },
            child: const Text('Arrive')
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
          
            },
            child: const Text('No Trip Assigned')
          );
    }
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