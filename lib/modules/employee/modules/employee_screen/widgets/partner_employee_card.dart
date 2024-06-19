import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/partner_employee.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

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

class PartnerCardBody extends StatelessWidget {
  const PartnerCardBody({super.key});

  Future<PartnerUser?> fetchPartnerUser(BuildContext context) async {
    dynamic partnerId;
    String userRole = context.read<UserProvider>().role.toString();
    if (userRole == 'Driver') {
      partnerId = context.read<VehicleInfoExtendedProvider>().conductorUserId;
    } else if (userRole == 'Conductor') {
      partnerId = context.read<VehicleInfoExtendedProvider>().driverUserId;
    } else {
      partnerId = null;
    }

    if (partnerId != null) {
      try {
        final partnerUser = await getPartnerUser(context, partnerId);
        return partnerUser;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PartnerUser?>(
      future: fetchPartnerUser(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const DecoratedBox(
            decoration: BoxDecoration(
              color: CustomThemeColors.themeBlue,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'No Partner Assigned',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: CustomThemeColors.themeWhite,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          final partnerEmployee = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<PartnerEmployeeProvider>().initEmployee(
              partnerEmployee.firstName,
              partnerEmployee.lastName,
              partnerEmployee.avatar,
            );
          });
          return DecoratedBox(
              decoration: const BoxDecoration(
                color: CustomThemeColors.themeBlue,
                borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              child: Consumer<PartnerEmployeeProvider>(
                builder: (context, userProvider, child) {
                  String greet;
                  String name;
                  String partnerRole;
                  if (userProvider.firstName == null) {
                    greet = 'No Partner Assigned';
                    name = '';
                    partnerRole = '';
                  } else {
                    greet = 'Hi Partner!';
                    name = '${userProvider.firstName} ${userProvider.lastName}';
                    partnerRole = context.read<UserProvider>().role == 'Driver' ? 'Conductor': 'Driver';
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const PartnerProfilePicture(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                greet,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: CustomThemeColors.themeWhite
                                ),
                              ),
                              Text(
                                name,
                                style: const TextStyle(
                                  color: CustomThemeColors.themeWhite,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                partnerRole,
                                style: const TextStyle(color: CustomThemeColors.themeWhite)
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
              ),
            );
        }
      },
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
