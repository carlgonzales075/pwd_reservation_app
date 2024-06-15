import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
// import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
// import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
// import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
// import 'package:pwd_reservation_app/modules/employee/drivers/partner_employee.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/employee/modules/inspect_seats/drivers/last_update.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class VehicleCardBody extends StatelessWidget {
  const VehicleCardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DecoratedBox(
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
                              ),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomThemeColors.themeWhite,
                                    foregroundColor: CustomThemeColors.themeBlue,
                                    fixedSize: const Size(200, 20)
                                  ),
                                  onPressed: () {
                                    context.read<LastUpdateProvider>().resetNotif();
                                    Navigator.pushNamed(context, '/seats');
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Inspect Seats'),
                                      AlertForPwd()
                                    ],
                                  )
                                ),
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
      ),
    );
  }
}

class AlertForPwd extends StatelessWidget {
  const AlertForPwd({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LastUpdateProvider>(
      builder: (context, hasUpdates, child) {
        final bool finalNotif = hasUpdates.showNotif as bool
            && hasUpdates.hasUpdates as int > 0
            && hasUpdates.isPlayed as bool;
        if (finalNotif) {
          FlutterRingtonePlayer().play(
            android: AndroidSounds.notification,
            ios: IosSounds.glass,
            looping: false,
            volume: 0.5,
            asAlarm: false,
          );
          // hasUpdates.updateIsPlayed();
        }
        return Visibility(
          visible: (hasUpdates.hasUpdates ?? 0) > 0,
          child: const Icon(
            Icons.circle,
            size: 10,
            color: Colors.red,
          ),
        );
      }
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