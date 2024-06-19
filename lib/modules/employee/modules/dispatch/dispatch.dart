import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/employee/modules/dispatch/dispatch_form.dart';
import 'package:pwd_reservation_app/modules/employee/modules/dispatch/drivers/dispatch.dart';
import 'package:pwd_reservation_app/modules/employee/modules/verify/drivers/verify.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';

class DispatchMenu extends StatelessWidget {
  const DispatchMenu({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Dispatch'),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: DirectusDispatch.getVehicleRoutes(
            context,
            limitQuery: 10,
            pageQuery: 1
          ),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              final data = snapshot.data;
              if (data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 80,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'No pending requests from passengers yet.',
                          style: TextStyle(
                            color: CustomThemeColors.themeBlue
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final vehicleInfo = data[index]['vehicle_id'];
                    return ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => DispatchForm(
                              title: vehicleInfo['vehicle_name'],
                              vehicleRouteId: data[index]['id'],
                            )
                          )
                        );
                      },
                      leading: IdNetworkImage(
                        assetId: vehicleInfo['vehicle_image'],
                        width: 40,
                        height: 40,
                      ),
                      title: Text(
                        '${vehicleInfo['vehicle_name']}',
                        style: const TextStyle(
                          color: CustomThemeColors.themeBlue,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: 'Plate Number: ',
                          style: const TextStyle(
                            color: Colors.black87
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${vehicleInfo['vehicle_plate_number']}',
                              style: const TextStyle(
                                color: CustomThemeColors.themeBlue
                              )
                            )
                          ]
                        ),
                      ),
                      // trailing: ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: CustomThemeColors.themeBlue,
                      //     foregroundColor: CustomThemeColors.themeWhite
                      //   ),
                      //   onPressed: () {
                      //     // Navigator.push(
                      //     //   context,
                      //     //   // MaterialPageRoute(
                      //     //   //   builder: (BuildContext context) => VerifyForm(
                      //     //   //     fullName: '${userInfo['first_name']} ${userInfo['last_name']}',
                      //     //   //     frontId: data[index]['id_image_front'],
                      //     //   //     backId: data[index]['id_image_back'],
                      //     //   //     selfie: data[index]['id_selfie'],
                      //     //   //     disabilityInfo: data[index]['passenger_id']['disability_info'],
                      //     //   //     rfidNo: data[index]['passenger_id']['rfid_tag'],
                      //     //   //     processingId: data[index]['id'],
                      //     //   //     passengerId: data[index]['passenger_id']['id'],
                      //     //   //   )
                      //     //   // )
                      //     // );
                      //   },
                      //   child: const Text('View'),
                      // ),
                    );
                  }
                );
              }
            }
          }
        ),
      ),
    );
  }
}