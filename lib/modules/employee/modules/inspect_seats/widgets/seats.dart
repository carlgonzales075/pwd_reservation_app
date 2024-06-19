import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/employee/modules/inspect_seats/drivers/last_update.dart';
import 'package:pwd_reservation_app/modules/employee/modules/inspect_seats/drivers/seat_status.dart';
import 'package:pwd_reservation_app/modules/reservation/widgets/select_bus_archive.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class SeatsGrid extends StatelessWidget {
  const SeatsGrid({
    super.key
  });

  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<dynamic>>(
        future: getSeatsUpdates(
          context,
          context.read<VehicleRouteInfoProvider>().vehicleId as String,
          context.read<UserProvider>().userId as String
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final gridList = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items in each row
                crossAxisSpacing: 8.0, // Spacing between items horizontally
                mainAxisSpacing: 8.0, // Spacing between items vertically
                childAspectRatio: 1, // Aspect ratio for the items
              ),
              itemCount: gridList.length, // Number of items in the grid
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blue, // Background color of the container
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: SeatsTile(
                    seatName: gridList[index]['seat_name'],
                    occupancyCode: gridList[index]['occupancy_code'],
                    seatType: gridList[index]['seat_type'],
                    isNew: gridList[index]['is_updated'],
                    passengerInfos: gridList[index]['passenger_infos'],
                    pickup: gridList[index]['pickup'],
                    destination: gridList[index]['destination'],
                    seatId: gridList[index]['id'],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class SeatsTile extends StatefulWidget {
  const SeatsTile({
    super.key,
    required this.seatName,
    required this.occupancyCode,
    required this.seatType,
    required this.isNew,
    required this.passengerInfos,
    required this.pickup,
    required this.destination,
    required this.seatId
  });

  final String seatName;
  final int occupancyCode;
  final String seatType;
  final bool isNew;
  final List passengerInfos;
  final String pickup;
  final String destination;
  final String seatId;

  @override
  State<SeatsTile> createState() => _SeatsTileState();
}

class _SeatsTileState extends State<SeatsTile> {
  List<Color> colorCode = [
    Colors.green.shade300, //Vacant
    Colors.amber.shade300, //Reserved
    Colors.grey.shade700 //Occupied
  ];

  void alertRestrictedInfo(BuildContext context, String seatId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restricted Info'),
          content: const Text(
            'Normal Passengers are restricted for viewing.',
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50)
              ),
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/seats');
                await updateReadBy(
                  context,
                  context.read<UserProvider>().userId as String,
                  seatId
                );
                if (context.mounted) {
                  LastUpdate hasUpdates = await checkUpdates(
                    context,
                    context.read<VehicleRouteInfoProvider>().vehicleId as String,
                    DateTime.now(),
                    context.read<UserProvider>().userId as String
                  );
                  if (context.mounted) {
                    context.read<LastUpdateProvider>().updateNow(
                      hasUpdates.updates,
                      hasUpdates.showNotif
                    );
                    context.read<LastUpdateProvider>().resetIsPlayed();
                  }
                }
              },
              child: const Text('OK')
            )
          ],
          actionsAlignment: MainAxisAlignment.start,
        );
      }
    );
  }

  void showPassengerProfile(BuildContext context, List passengerInfo, String pickup, String destination, String seatId) async {
    if (passengerInfo.isNotEmpty) {
      final Map<String, dynamic> firstPassenger = passengerInfo[0];
      await updateReadBy(
        context,
        context.read<UserProvider>().userId as String,
        seatId
      );
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: CustomThemeColors.themeWhite,
              content: FutureBuilder<Map<String, dynamic>>(
                future: getPassengerUserInfo(
                  context,
                  firstPassenger['user_id']
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No data available for this user.');
                  } else {
                    final passengerUserInfo = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 180,
                            width: 180,
                            child: PassengerImage(
                              width: 200,
                              height: 200,
                              scale: false,
                              imageUrl: passengerUserInfo['avatar'],
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Text(
                            '${passengerUserInfo['first_name']} ${passengerUserInfo['last_name']}'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.green,
                        
                            ),
                          ),
                          const SizedBox(height: 20,),
                          RowDesc(
                            title: 'Disability',
                            desc: '${firstPassenger['disability_info']}',
                            color: Colors.green,
                            visible: true,
                          ),
                          RowDesc(
                            title: 'Pickup',
                            desc: pickup,
                            color: CustomThemeColors.themeBlue,
                            visible: true,
                          ),
                          RowDesc(
                            title: 'Destination',
                            desc: destination,
                            color: CustomThemeColors.themeBlue,
                            visible: true,
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
              contentTextStyle: const TextStyle(
                color: CustomThemeColors.themeBlue,
                fontWeight: FontWeight.bold
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/seats');
                    LastUpdate hasUpdates = await checkUpdates(
                      context,
                      context.read<VehicleRouteInfoProvider>().vehicleId as String,
                      DateTime.now(),
                      context.read<UserProvider>().userId as String
                    );
                    if (context.mounted) {
                      context.read<LastUpdateProvider>().updateNow(
                        hasUpdates.updates,
                        hasUpdates.showNotif
                      );
                      context.read<LastUpdateProvider>().resetIsPlayed();
                    }
                  },
                  child: const Text('OK')
                )
              ],
              actionsAlignment: MainAxisAlignment.start,
            );
          }
        );
        LastUpdate hasUpdates = await checkUpdates(
          context,
          context.read<VehicleRouteInfoProvider>().vehicleId as String,
          DateTime.now(),
          context.read<UserProvider>().userId as String
        );
        if (context.mounted) {
          context.read<LastUpdateProvider>().updateNow(
            hasUpdates.updates,
            hasUpdates.showNotif
          );
        }
      }
    }
  }

  @override
  Widget build (BuildContext context) {
    bool isPwd = widget.seatType == 'PWD';
    return Container(
      decoration: BoxDecoration(
        color: isPwd ? CustomThemeColors.themeBlue : CustomThemeColors.themeGrey,
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorCode[widget.occupancyCode],
                borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Visibility(
                    visible: widget.isNew,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.5), // Shadow color with opacity
                              spreadRadius: 2, // Spread radius of the shadow
                              blurRadius: 3, // Blur radius of the shadow
                              offset: const Offset(0, 0), // Offset of the shadow
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.circle_sharp,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            widget.seatName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPwd ? CustomThemeColors.themeWhite : Colors.black54
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isPwd ? CustomThemeColors.themeWhite : CustomThemeColors.themeLightBlue,
                foregroundColor: isPwd ? CustomThemeColors.themeBlue : CustomThemeColors.themeWhite
              ),
              onPressed: widget.passengerInfos.isNotEmpty ? () {
                if (isPwd) {
                  showPassengerProfile(context, widget.passengerInfos, widget.pickup,
                            widget.destination, widget.seatId);
                } else {
                  alertRestrictedInfo(context, widget.seatId);
                }
              } : null,
              child: const Text(
                'Check Passenger',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}