import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/dispatch_info.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/employee.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_selected.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth_convert.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<DomainProvider>(
          builder: (context, myData, child) {
            if (myData.ipAddress == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const NoDomainAlert();
                  },
                );
              });
            }
            return const HomePageLogo();

          },
        ),
        const LoginCard()
      ],
    );
  }
}

class NoDomainAlert extends StatefulWidget {
  const NoDomainAlert({super.key});

  @override
  State<NoDomainAlert> createState() => _NoDomainAlert();
}

class _NoDomainAlert extends State<NoDomainAlert> {
  @override
  Widget build (BuildContext context) {
    return AlertDialog(
      title: const Text('No Domain Set'),
      content: const Text('Set the domain to start testing.'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, '/domain');
          },
          child: const Text('OK')
        )
      ],
    );
  }
}

class HomePageLogo extends StatelessWidget {
  const HomePageLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        SizedBox(
          height: 350,
          width: 300,
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Image(
              image: AssetImage('assets/images/pwd.png')
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            height: 200,
            width: 200,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 15, 0),
              child: Text(
                'Priority Passenger App',
                textAlign: TextAlign.right,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  color: CustomThemeColors.themeWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                )
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: const SizedBox(
          height: 400,
          child: Card(
            semanticContainer: false,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: LoginScreenFields(),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreenFields extends StatefulWidget {
  const LoginScreenFields({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenFields createState() => _LoginScreenFields();
}

class _LoginScreenFields extends State<LoginScreenFields> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  late Future<Credentials> credentials;

  Future _getUserInfo(String accessToken) async {
    try {
      if (mounted) {
        User user = await getUser(accessToken, context.read<DomainProvider>().url as String);
        if (mounted) {
          Provider.of<UserProvider>(context, listen: false).updateUser(
            userId: user.userId,
            firstName: user.firstName,
            lastName: user.lastName,
            avatar: user.avatar,
            email: user.email,
            role: user.role
          );
          List<String> validRoles = ['Driver', 'Conductor', 'Employee'];
          if (validRoles.contains(user.role)) {
            Employee employee = await getEmployeeInfo(
              context.read<DomainProvider>().url as String,
              accessToken,
              user.userId
            );
            if (mounted) {
              context.read<EmployeeProvider>().initEmployee(
                employee.id,
                employee.isConductor,
                employee.isDriver,
                employee.assignedVehicle
              );
              // print('${employee.assignedVehicle}');
              if (employee.assignedVehicle != null) {
                VehicleRouteInfo vehicleRouteInfo = await getVehicleRouteInfo(
                  context.read<DomainProvider>().url as String,
                  accessToken,
                  employee.id
                );
                if (mounted) {
                  context.read<VehicleRouteInfoProvider>().initVehicleRouteInfo(
                    vehicleRouteInfo.routeId,
                    vehicleRouteInfo.vehicleId,
                    vehicleRouteInfo.driverId,
                    vehicleRouteInfo.conductorId,
                    vehicleRouteInfo.currentStopId,
                    vehicleRouteInfo.goingToBusStopId
                  );
                  DispatchInfo dispatchInfo = await getDispatchInfo(
                    context.read<DomainProvider>().url as String,
                    accessToken,
                    vehicleRouteInfo.vehicleId as String,
                    vehicleRouteInfo.routeId as String
                  );
                  if (mounted) {
                    context.read<DispatchInfoProvider>().initDispatchInfo(
                      dispatchInfo.dispatchId,
                      dispatchInfo.dateOfDispatch
                    );
                    VehicleInfoExtended vehicleInfoExtended = await getVehicleInfoExtended(
                      context.read<DomainProvider>().url as String,
                      accessToken,
                      vehicleRouteInfo.vehicleId as String,
                      vehicleRouteInfo.routeId as String,
                      dispatchInfo.dispatchId as String
                    );
                    if (mounted) {
                      // print('how this in');
                      context.read<VehicleInfoExtendedProvider>().initVehicleInfoExtended(
                        vehicleInfoExtended.vehicleName,
                        vehicleInfoExtended.vehiclePlateNumber,
                        vehicleInfoExtended.vehicleImageId,
                        vehicleInfoExtended.driverUserId,
                        vehicleInfoExtended.conductorUserId,
                        vehicleInfoExtended.normalSeatsRemaining,
                        vehicleInfoExtended.pwdSeatsRemaining,
                        vehicleInfoExtended.tripStops
                      );
                    //   dynamic partnerId;
                    //   if (user.role == 'Driver') {
                    //     partnerId = vehicleInfoExtended.conductorUserId;
                    //   } else if (user.role == 'Conductor') {
                    //     partnerId = vehicleInfoExtended.driverUserId;
                    //   } else {
                    //     partnerId = null;
                    //   }
                    //   // print('$partnerId');
                    //   if (partnerId != null) {
                    //     print('this is partnerId $partnerId');
                    //     PartnerUser partnerEmployee = await getPartnerUser(
                    //       context.read<DomainProvider>().url as String,
                    //       accessToken,
                    //       partnerId
                    //     );
                    //     print(partnerEmployee.firstName);
                    //     // if (mounted) {
                    //     //   context.read<PartnerEmployeeProvider>().initEmployee(
                    //     //     partnerEmployee.userId,
                    //     //     partnerEmployee.firstName,
                    //     //     partnerEmployee.lastName,
                    //     //     partnerEmployee.avatar,
                    //     //     partnerEmployee.email,
                    //     //     partnerEmployee.role
                    //     //   );
                    //     //   print('asdfag ad ');
                    //     // }
                      // }
                    }
                  }
                }
              } else {

              }
            }
            return 'Employee';
          } else {
            Passengers passenger = await getPassenger(user.userId, accessToken,
            context.read<DomainProvider>().url as String);
            if (mounted) {
              context.read<PassengerProvider>().initPassenger(
                id: passenger.id,
                passengerType: passenger.passengerType,
                disabilityInfo: passenger.disabilityInfo,
                seatAssigned: passenger.seatAssigned,
                isWaiting: passenger.isWaiting,
                isOnRoute: passenger.isOnRoute
              );
            }
            if (mounted) {
              if (passenger.seatAssigned != null) {
                ReservationInfo reservationInfo = await getReservationInfo(
                  accessToken, passenger.seatAssigned as String, context.read<DomainProvider>().url as String);
                if (mounted) {
                  context.read<ReservationProvider>().initReservation(
                    reservationInfo.seatName,
                    reservationInfo.routeName,
                    reservationInfo.vehicleName,
                    reservationInfo.busStopName,
                    reservationInfo.distance
                  );
                }
              }
            }
            return 'Passenger';
          }
        }
      }
      return 'Passenger';
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('User Info Request Failed'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
      );
    }
  }

  Future<void> _login(String domain) async {
    String email = _userNameController.text;
    String password = _passWordController.text;

    try {
      late String userType;
      if (mounted) {
        Credentials credentials = await postLogin(email, password, domain);
        
        if (mounted) {
          Provider.of<CredentialsProvider>(context, listen: false).updateCredentials(
            accessToken: credentials.accessToken,
            refreshToken: credentials.refreshToken,
            expires: credentials.expires
          );
          userType = await _getUserInfo(credentials.accessToken);
        }
      }
      if (mounted) {
        if (userType == 'Passenger') {
          Navigator.pushNamed(context, '/home');
        } else {
          Navigator.pushNamed(context, '/employee-home');
        }
      }
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserNameTextField(controller: _userNameController),
        PassWordTextField(controller: _passWordController),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 15,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/domain");
            },
            child: const Text('Forgot Password?'),
          ),
        ),
        BasicElevatedButton(
          buttonText: 'Login',
          onPressed: () {
            _login(context.read<DomainProvider>().url as String);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text('Don\'t have an account?'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: CustomThemeColors.themeBlue,
              ),
              child: const Text('Sign Up')
              )
          ],
        )
      ],
    );
  }
}