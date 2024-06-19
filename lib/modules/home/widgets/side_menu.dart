import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/screen_change.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/home/drivers/check_pwd_approval.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> employeeRoles = ['Driver', 'Conductor', 'Employee'];
    bool isPassenger = !employeeRoles.contains(context.read<UserProvider>().role);
    if (isPassenger) {
      return const PassengerDrawer();
    } else {
      return const EmployeeDrawer();
    }
  }
}

class PassengerDrawer extends StatelessWidget {
  const PassengerDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
            child: Text(
              'PWD Reservation App',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          SideMenuListTile(
            icon: Icons.settings,
            title: 'Change Domain',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/domain');
            }
          ),
          SideMenuListTile(
            icon: Icons.wheelchair_pickup_sharp,
            title: 'Register as PWD/SC',
            onTap: () async {
              Navigator.of(context).pop();
              checkPWDApproval(context); 
            },
          ),
        ],
      ),
    );
  }
}

class EmployeeDrawer extends StatefulWidget {
  const EmployeeDrawer({
    super.key,
  });

  @override
  State<EmployeeDrawer> createState() => _EmployeeDrawerState();
}

class _EmployeeDrawerState extends State<EmployeeDrawer> {
  void _focusOnTrip(BuildContext context) {
    CustomDialogs.customErrorDialog(
      context,
      'Change Not Permitted',
      'Changing to passenger while in a trip is not allowed.'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
            child: Text(
              'PWD Bus Reservation',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          SideMenuListTile(
            icon: Icons.swipe,
            title: 'Switch to ${
                context.read<EmployeeScreenSwitcher>().screenSwitchPassenger ? 'Passenger': 'Employee'
              }',
            onTap: () {
              // Navigator.of(context).pop();
              if (context.read<EmployeeScreenSwitcher>().screenSwitchPassenger) {
                if (context.read<VehicleInfoExtendedProvider>().vehicleName == null) {
                  Navigator.pushReplacementNamed(context, "/home");
                  context.read<EmployeeScreenSwitcher>().switchScreens();
                } else {
                  _focusOnTrip(context);
                }
              } else {
                Navigator.pushReplacementNamed(context, "/employee-home");
                context.read<EmployeeScreenSwitcher>().switchScreens();
              }
            }
          ),
          SideMenuListTile(
            icon: Icons.settings,
            title: 'Change Domain',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/domain');
            }
          ),
          SideMenuListTile(
            icon: Icons.wheelchair_pickup_sharp,
            title: 'Register as PWD/SC',
            onTap: () async {
              Navigator.of(context).pop();
              if (context.read<VehicleInfoExtendedProvider>().vehicleName == null) {
                checkPWDApproval(context);
              } else {
                _focusOnTrip(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class SideMenuListTile extends StatelessWidget {
  const SideMenuListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build (BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: CustomThemeColors.themeBlue
        ),
        child: Icon(
          icon,
          color: CustomThemeColors.themeWhite,
        )
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: CustomThemeColors.themeBlue
        )
      ),
      onTap: onTap,
    );
  }
}