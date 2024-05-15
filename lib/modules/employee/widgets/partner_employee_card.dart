import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/partner_employee.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';

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
        final domain = context.read<DomainProvider>().url as String;
        final accessToken = context.read<CredentialsProvider>().accessToken.toString();
        final partnerUser = await getPartnerUser(domain, accessToken, partnerId);
        return partnerUser;
      } catch (e) {
        print('Error fetching partner user: $e');
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
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'No Partner Assigned',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: CustomThemeColors.themeWhite,
                ),
              ),
            ),
          );
        } else {
          final partnerEmployee = snapshot.data!;
          context.read<PartnerEmployeeProvider>().initEmployee(
            // partnerEmployee.userId,
            partnerEmployee.firstName,
            partnerEmployee.lastName,
            partnerEmployee.avatar,
            // partnerEmployee.email,
            // partnerEmployee.role,
          );
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
