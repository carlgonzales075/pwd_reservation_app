import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/widgets/dynamic_trip.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/widgets/employee_grid_menu.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/widgets/employee_header.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/widgets/next_stop_card_employee.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/widgets/notif_modal.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/widgets/partner_employee_card.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/widgets/vehicle_card_employee.dart';
import 'package:pwd_reservation_app/modules/employee/modules/inspect_seats/drivers/last_update.dart';
import 'package:pwd_reservation_app/modules/home/widgets/side_menu.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  LastUpdateProvider? _lastUpdateProvider;

  @override
  void initState() {
    _lastUpdateProvider = context.read<LastUpdateProvider>();
    _lastUpdateProvider?.startPeriodicUpdates(context);
    super.initState();
  }

  @override
  void dispose() {
    _lastUpdateProvider?.stopPeriodicUpdates(context);
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
    final String? userRole = context.read<UserProvider>().role;
    final List<String> driverConductor = ['Driver', 'Conductor'];
    final bool isDriverConductor = driverConductor.contains(userRole);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: CustomThemeColors.themeBlue,
        foregroundColor: CustomThemeColors.themeWhite,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              DirectusAuth directusAuth = DirectusAuth(context);
              directusAuth.logOutDialog(context);
            },
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      drawer: const NavDrawer(),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewPortConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewPortConstraints.maxHeight,
                  ),
                  child: Column(
                    children: <Widget>[
                    const EmployeeHomeScreenHeader(),
                    isDriverConductor ? const DriverConductorCards() : const EmployeeMenus()
                  ],
                ),)
              );
            }
          ),
          if (context.read<LastUpdateProvider>().showNotif ?? false)
            const Align(
              alignment: Alignment.topCenter,
              child: NotifModal(
                id: 'notif1'
              ),
            )
        ],
      ),
      persistentFooterButtons: isDriverConductor ? const <Widget>[
        DynamicButtons()
      ] : null,
    );
  }
}

class DriverConductorCards extends StatelessWidget {
  const DriverConductorCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        PartnerCard(),
        SizedBox(height: 2,),
        VehicleCard(),
        SizedBox(height: 2),
        NextStopCard(),
      ],
    );
  }
}