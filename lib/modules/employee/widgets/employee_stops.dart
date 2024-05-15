import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
// import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
// import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
// import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/partner_employee.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';

class VehicleCardBody extends StatelessWidget {
  const VehicleCardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: CustomThemeColors.themeBlue,
        borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      child: Consumer<PartnerEmployeeProvider>(
        builder: (context, userProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
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
                        context.read<VehicleInfoExtendedProvider>().vehicleName.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: CustomThemeColors.themeWhite
                        ),
                      ),
                      Text(
                        context.read<VehicleInfoExtendedProvider>().vehiclePlateNumber ?? 'No Plate Number',
                        style: const TextStyle(
                          color: CustomThemeColors.themeWhite,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        'Remaining Normal Seats: ${context.read<VehicleInfoExtendedProvider>().normalSeatsRemaining}',
                        style: const TextStyle(color: CustomThemeColors.themeWhite)
                      ),
                      Text(
                        'Remaining PWD Seats: ${context.read<VehicleInfoExtendedProvider>().pwdSeatsRemaining}',
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