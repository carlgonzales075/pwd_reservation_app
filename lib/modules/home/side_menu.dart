import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/auth/register/drivers/file_upload.dart';
// import 'package:pwd_reservation_app/modules/employee/drivers/dispatch_info.dart';
// import 'package:pwd_reservation_app/modules/employee/drivers/employee.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/screen_change.dart';
// import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_info_extended.dart';
// import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_selected.dart';
// import 'package:pwd_reservation_app/modules/reservation/drivers/routes.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';

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
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.input),
          //   title: const Text('Welcome'),
          //   onTap: () => {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.verified_user),
          //   title: const Text('Profile'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Change Domain'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/domain');
            },
          ),
          ListTile(
            leading: const Icon(Icons.wheelchair_pickup_sharp),
            title: const Text('Register as PWD/SC'),
            onTap: () async {
              Navigator.of(context).pop();
              int applicationCount = await checkApplicationApproval(
                context.read<DomainProvider>().url as String,
                context.read<CredentialsProvider>().accessToken as String,
                context.read<PassengerProvider>().id as String
              );
              if (applicationCount >= 1 && context.mounted) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Application Complete'),
                      content: const Text('You are already approved as a priority passenger.'),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Confirm')
                        )
                      ],
                    );
                  }
                );
              } else {
                if (context.mounted) {
                  int progressCount = await checkApplicationProgress(
                    context.read<DomainProvider>().url as String,
                    context.read<CredentialsProvider>().accessToken as String,
                    context.read<PassengerProvider>().id as String
                  );
                  if (context.mounted) {
                    if (progressCount >= 1) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Application Under Review'),
                            content: const Text('You\'re application is undergoing review. We will get back to you as soon as we can.'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Confirm')
                              )
                            ],
                          );
                        }
                      );
                    } else {
                      Navigator.pushNamed(context, '/register-upload');
                    }
                  }
                }
              }
            },
          )
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
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.swipe),
            title: Text('Switch to ${
              context.read<EmployeeScreenSwitcher>().screenSwitchPassenger ? 'Passenger': 'Employee'
            }'),
            onTap: () {
              if (context.read<EmployeeScreenSwitcher>().screenSwitchPassenger) {
                Navigator.pushNamed(context, "/home");
              } else {
                Navigator.pushNamed(context, "/employee-home");
              }
              context.read<EmployeeScreenSwitcher>().switchScreens();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Change Domain'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/domain');
            },
          ),
          ListTile(
            leading: const Icon(Icons.wheelchair_pickup_sharp),
            title: const Text('Register as PWD/SC'),
            onTap: () async {
              Navigator.of(context).pop();
              int applicationCount = await checkApplicationApproval(
                context.read<DomainProvider>().url as String,
                context.read<CredentialsProvider>().accessToken as String,
                context.read<PassengerProvider>().id as String
              );
              if (applicationCount >= 1 && context.mounted) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Application Complete'),
                      content: const Text('You are already approved as a priority passenger.'),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Confirm')
                        )
                      ],
                    );
                  }
                );
              } else {
                if (context.mounted) {
                  int progressCount = await checkApplicationProgress(
                    context.read<DomainProvider>().url as String,
                    context.read<CredentialsProvider>().accessToken as String,
                    context.read<PassengerProvider>().id as String
                  );
                  if (context.mounted) {
                    if (progressCount >= 1) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Application Under Review'),
                            content: const Text('You\'re application is undergoing review. We will get back to you as soon as we can.'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Confirm')
                              )
                            ],
                          );
                        }
                      );
                    } else {
                      Navigator.pushNamed(context, '/register-upload');
                    }
                  }
                }
              }
            },
          )
        ],
      ),
    );
  }
}