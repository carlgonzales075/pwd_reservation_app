import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
// import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
// import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
// import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
// import 'package:pwd_reservation_app/modules/employee/drivers/partner_employee.dart';
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
      child: Consumer<VehicleInfoExtendedProvider>(
        builder: (context, vehicle, child) {
          if (vehicle.vehicleName != null) {

            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BusImageProfile(assetId: vehicle.vehicleImageId.toString()),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              vehicle.vehicleName.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: CustomThemeColors.themeWhite
                              ),
                            ),
                            Text(
                              vehicle.vehiclePlateNumber ?? 'No Plate Number',
                              style: const TextStyle(
                                color: CustomThemeColors.themeWhite,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              'Remaining Normal Seats: ${vehicle.normalSeatsRemaining}',
                              style: const TextStyle(color: CustomThemeColors.themeWhite)
                            ),
                            Text(
                              'Remaining PWD Seats: ${vehicle.pwdSeatsRemaining}',
                              style: const TextStyle(color: CustomThemeColors.themeWhite)
                            )
                          ],
                        ),
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
                padding: EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    'No vehicle Assigned.',
                    style: TextStyle(color: CustomThemeColors.themeWhite)
                  ),
                ),
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